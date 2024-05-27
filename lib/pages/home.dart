import 'package:flutter/material.dart';
import 'package:proyek_akhir_tpm/pages/coffee_list.dart';
import 'package:proyek_akhir_tpm/pages/kesan_pesan.dart';
import 'package:proyek_akhir_tpm/pages/logout.dart';
import 'package:proyek_akhir_tpm/pages/profile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  final List<Widget> _listPages = [
    const CoffeeListPage(),
    const ProfilePage(),
    const KesanPesanPage(),
    const LogoutPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _listPages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          BottomNavigationBarItem(icon: Icon(Icons.info_outline), label: "Kesan"),
          BottomNavigationBarItem(icon: Icon(Icons.logout), label: "Logout"),
        ],
        currentIndex: currentIndex, // Added this line
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
          print(value);
        },
      ),
    );
  }
}
