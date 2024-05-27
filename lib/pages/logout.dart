import 'package:flutter/material.dart';
import 'package:proyek_akhir_tpm/pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogoutPage extends StatefulWidget {
  const LogoutPage({super.key});

  @override
  State<LogoutPage> createState() => _LogoutPageState();
}

class _LogoutPageState extends State<LogoutPage> {
  late SharedPreferences pref;

  void loadData() async {
    pref = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              pref.remove("logedIn");
              pref.remove("accIndex");
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                return LoginPage();
              }));
            },
            child: Text("Logout")),
      ),
    );
  }
}
