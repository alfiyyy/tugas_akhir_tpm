import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:proyek_akhir_tpm/model/coffee.dart';
import 'package:proyek_akhir_tpm/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  late SharedPreferences pref;
  List<Coffee> coffeeList = [];

  void loadData() async {
    pref = await SharedPreferences.getInstance();

    var userBox = await Hive.openBox<User>("userBox");

    int accIndex = pref.getInt("accIndex")!;

    User? currentUser = userBox.getAt(accIndex);

    if (currentUser != null) {
      setState(() {
        coffeeList = currentUser.coffees;
      });
    }

    await userBox.close();
  }

  String getPriceText(Coffee coffee) {
    switch (coffee.region) {
      case "USD":
        return "Price : \$ ${coffee.price?.toStringAsFixed(2)}";
      case "IDR":
        return "Price : Rp ${coffee.price?.toStringAsFixed(2)}";
      case "EUR":
        return "Price : € ${coffee.price?.toStringAsFixed(2)}";
      default:
        return "";
    }
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order History"),
      ),
      body: ListView.builder(
        itemCount: coffeeList.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height: 150,
            padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
            child: Card(
              shape: const ContinuousRectangleBorder(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (coffeeList[index].imageUrl != null)
                    Container(
                      width: 100,
                      child: Image.network("${coffeeList[index].imageUrl}"),
                    ),
                  Container(
                    width: coffeeList[index].imageUrl != null ? 280 : 380,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${coffeeList[index].name}",
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(getPriceText(coffeeList[index])),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
