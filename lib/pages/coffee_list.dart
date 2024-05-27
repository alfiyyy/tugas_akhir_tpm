import 'package:flutter/material.dart';
import 'package:proyek_akhir_tpm/model/api_data_source.dart';
import 'package:proyek_akhir_tpm/model/coffee.dart';
import 'package:proyek_akhir_tpm/pages/coffee_detail.dart';

class CoffeeListPage extends StatefulWidget {
  const CoffeeListPage({super.key});

  @override
  State<CoffeeListPage> createState() => _CoffeeListPageState();
}

class _CoffeeListPageState extends State<CoffeeListPage> {
  List<Coffee> coffeeList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.home),
        title: const Text("Coffee List"),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: MySearchDelegate(coffeeList));
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: FutureBuilder(
        future: ApiDataSource.instance.loadApi(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            // Jika data ada error maka akan ditampilkan hasil error
            return Center(child: Text("${snapshot.error}"));
          }
          if (snapshot.hasData) {
            final List<dynamic> jsonList = snapshot.data as List<dynamic>;
            coffeeList = jsonList.map((json) => Coffee.fromJson(json)).toList();
            return ListView.builder(
              itemCount: coffeeList.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CoffeeDetailPage(
                        data: coffeeList[index],
                      ),
                    ),
                  ),
                  child: Container(
                    height: 150,
                    padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
                    child: Card(
                      shape: const ContinuousRectangleBorder(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 100,
                            child: Image.network("${coffeeList[index].imageUrl}"),
                          ),
                          Container(
                            width: 280,
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
                                Text("Price : \$${coffeeList[index].price}"),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class MySearchDelegate extends SearchDelegate {
  final List<Coffee> coffeeList;

  MySearchDelegate(this.coffeeList);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = "";
        },
        icon: const Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final List<Coffee> searchResults = coffeeList
        .where((coffee) => coffee.name!.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CoffeeDetailPage(
                data: searchResults[index],
              ),
            ),
          ),
          child: Container(
            height: 150,
            padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
            child: Card(
              shape: const ContinuousRectangleBorder(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 100,
                    child: Image.network("${searchResults[index].imageUrl}"),
                  ),
                  Container(
                    width: 280,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${searchResults[index].name}",
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        ),
                        Text("Price : \$${searchResults[index].price}"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    return Container();
    // final List<Coffee> suggestionList = coffeeList
    //     .where((coffee) => coffee.name!.toLowerCase().contains(query.toLowerCase()))
    //     .toList();

    // return ListView.builder(
    //   itemCount: suggestionList.length,
    //   itemBuilder: (context, index) {
    //     return ListTile(
    //       title: Text("${suggestionList[index].name}"),
    //       onTap: () {
    //         query = suggestionList[index].name!;
    //         showResults(context);
    //       },
    //     );
    //   },
    // );
  }
}
