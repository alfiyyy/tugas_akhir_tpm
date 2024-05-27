import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:proyek_akhir_tpm/model/coffee.dart';
import 'package:proyek_akhir_tpm/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CoffeeDetailPage extends StatefulWidget {
  final Coffee data;
  const CoffeeDetailPage({super.key, required this.data});

  @override
  State<CoffeeDetailPage> createState() => _CoffeeDetailPageState();
}

late SharedPreferences pref;
double totalPrice = 0;

class _CoffeeDetailPageState extends State<CoffeeDetailPage> {
  String? flavorsList() {
    if (widget.data.flavorProfile != null &&
        widget.data.flavorProfile!.isNotEmpty) {
      return widget.data.flavorProfile!.join(", ");
    } else {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.keyboard_return_sharp)),
        title: const Text("Coffee Detail"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 350,
              child: Card(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(0, 25, 0, 25),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "\$${widget.data.price}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        Image.network("${widget.data.imageUrl}"),
                        Text(
                          "${widget.data.name}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        Container(
                          width: 290,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              Text(
                                "${widget.data.description}",
                                textAlign: TextAlign.justify,
                                style: const TextStyle(fontSize: 15),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Region : " + widget.data.region.toString(),
                                style: const TextStyle(fontSize: 15),
                              ),
                              Text(
                                "Flavour : " + "${flavorsList()}",
                                style: const TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Container(
              width: 200,
              child: ElevatedButton(
                  onPressed: () {
                    _showPopup(context, widget.data, 1);
                  },
                  child: const Text("Beli")),
            )
          ],
        ),
      ),
    );
  }
}

class PopupContent extends StatefulWidget {
  final double price;
  final Function(int) onCurrencyChange;

  PopupContent({required this.price, required this.onCurrencyChange});

  @override
  _PopupContentState createState() => _PopupContentState();
}

class _PopupContentState extends State<PopupContent> {
  int selectedButtonIndex = 1;
  int amount = 1;

  @override
  void initState() {
    super.initState();
    totalPrice = widget.price;
  }

  void _updateTotalPrice() {
    setState(() {
      if (selectedButtonIndex == 1) {
        totalPrice = widget.price * amount;
      } else if (selectedButtonIndex == 2) {
        totalPrice = usdToIdr(widget.price) * amount;
      } else if (selectedButtonIndex == 3) {
        totalPrice = usdToEur(widget.price) * amount;
      } else if (selectedButtonIndex == 4) {
        totalPrice = usdToYen(widget.price) * amount;
      }
    });
  }

  void _onCurrencyChange(int index) {
    setState(() {
      selectedButtonIndex = index;
      _updateTotalPrice();
      widget.onCurrencyChange(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (selectedButtonIndex == 1)
                Text(
                  "\$${totalPrice.toStringAsFixed(2)}",
                  style: const TextStyle(fontSize: 24),
                ),
              if (selectedButtonIndex == 2)
                Text(
                  "Rp${totalPrice.toStringAsFixed(2)}",
                  style: const TextStyle(fontSize: 24),
                ),
              if (selectedButtonIndex == 3)
                Text(
                  "€${totalPrice.toStringAsFixed(2)}",
                  style: const TextStyle(fontSize: 24),
                ),
              if (selectedButtonIndex == 4)
                Text(
                  "¥${totalPrice.toStringAsFixed(2)}",
                  style: const TextStyle(fontSize: 24),
                ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  color: Colors.brown.shade300,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  ),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      if (amount > 1) amount--;
                      _updateTotalPrice();
                    });
                  },
                ),
              ),
              Container(
                width: 50,
                height: 35,
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Center(
                  child: Text(
                    '$amount',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
              Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  color: Colors.brown.shade300,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      if (amount < 10) amount++;
                      _updateTotalPrice();
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Table(
            columnWidths: const <int, TableColumnWidth>{
              0: FlexColumnWidth(),
              1: FlexColumnWidth(),
            },
            children: [
              TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                    child: ElevatedButton(
                      onPressed: () {
                        _onCurrencyChange(1);
                      },
                      style: selectedButtonIndex == 1
                          ? ElevatedButton.styleFrom(
                              backgroundColor: Colors.green)
                          : ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey),
                      child: const Text(
                        'USD',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                    child: ElevatedButton(
                      onPressed: () {
                        _onCurrencyChange(2);
                      },
                      style: selectedButtonIndex == 2
                          ? ElevatedButton.styleFrom(
                              backgroundColor: Colors.green)
                          : ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey),
                      child: const Text(
                        'IDR',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
              TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                    child: ElevatedButton(
                      onPressed: () {
                        _onCurrencyChange(3);
                      },
                      style: selectedButtonIndex == 3
                          ? ElevatedButton.styleFrom(
                              backgroundColor: Colors.green)
                          : ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey),
                      child: const Text(
                        'EUR',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                    child: ElevatedButton(
                      onPressed: () {
                        _onCurrencyChange(4);
                      },
                      style: selectedButtonIndex == 4
                          ? ElevatedButton.styleFrom(
                              backgroundColor: Colors.green)
                          : ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey),
                      child: const Text(
                        'YEN',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void _showPopup(BuildContext context, Coffee coffee, int selectedButtonIndex) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirm Payment'),
        content: PopupContent(
          price: coffee.price!,
          onCurrencyChange: (index) {
            selectedButtonIndex = index;
          },
        ),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              addToBuyHistory(coffee.name!, totalPrice, selectedButtonIndex);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Coffe has been buyed"),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ));

              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Center(child: Text('Buy')),
          ),
        ],
      );
    },
  );
}

double usdToYen(double usd) {
  double yen;
  yen = usd * 156.88;
  return yen;
}

double usdToIdr(double usd) {
  double idr;
  idr = usd * 16045.00;
  return idr;
}

double usdToEur(double usd) {
  double eur;
  eur = usd * 0.92;
  return eur;
}

// double idrToUsd(double idr) {
//   double usd;
//   usd = idr * 0.000062;
//   return usd;
// }

// double idrToEur(double idr) {
//   double eur;
//   eur = idr * 0.000057;
//   return eur;
// }

// double eurToUsd(double eur) {
//   double usd;
//   usd = eur * 1.08;
//   return usd;
// }

// double eurToIdr(double eur) {
//   double idr;
//   idr = eur * 17406.42;
//   return idr;
// }

void addToBuyHistory(
    String coffeeName, double coffeePrice, int selectedCurrency) async {
  // Obtain shared preferences instance
  pref = await SharedPreferences.getInstance();

  // Open the Hive box for users
  var userBox = await Hive.openBox<User>("userBox");

  // Determine the currency based on the selectedCurrency index
  String currency;
  if (selectedCurrency == 1) {
    currency = "USD";
  } else if (selectedCurrency == 2) {
    currency = "IDR";
  } else if (selectedCurrency == 3) {
    currency = "EUR";
  } else {
    currency = "YEN";
  }

  // Get the current user's index from shared preferences
  int accIndex = pref.getInt("accIndex")!;

  // Create a new Coffee instance
  Coffee coffee = Coffee(
    name: coffeeName,
    price: coffeePrice,
    region: currency,
  );

  // Retrieve the current user from the box
  User? currentUser = userBox.getAt(accIndex);

  // If the user exists, add the coffee to their list
  if (currentUser != null) {
    currentUser.coffees.add(coffee);
    // Save the updated user back to the box
    await currentUser.save();
  }

  // Close the Hive box
  await userBox.close();
}
