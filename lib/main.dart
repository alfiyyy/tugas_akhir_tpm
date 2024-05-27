import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:proyek_akhir_tpm/model/coffee.dart';
import 'package:proyek_akhir_tpm/model/user.dart';
import 'package:proyek_akhir_tpm/pages/login.dart';

void main() async{
  await Hive.initFlutter();
  Hive.registerAdapter(CoffeeAdapter());
  Hive.registerAdapter(UserAdapter());

  // await clearUserBox();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Future<void> clearUserBox() async {
//   var userBox = await Hive.openBox<User>("userBox");
//   await userBox.clear();
//   await userBox.close();
// }
