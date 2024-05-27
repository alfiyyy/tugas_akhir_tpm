import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:proyek_akhir_tpm/model/user.dart';
import 'package:proyek_akhir_tpm/pages/home.dart';
import 'package:proyek_akhir_tpm/pages/signup.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late SharedPreferences pref;
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  // String? user;
  // String? pass;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final key = encrypt.Key.fromUtf8('my 32 length key................');
  final iv = encrypt.IV.fromUtf8("1234567890123456");

  void checkInputForLogin() async {
    var userBox = await Hive.openBox<User>("userBox");
    bool userFound = false; // Flag to track if credentials match

    for (int i = 0; i < userBox.length; i++) {
      if (userBox.getAt(i)!.username == usernameController.text &&
          decryptData(userBox.getAt(i)!.password) == passwordController.text) {
        userFound = true; // Set flag to true if credentials match
        pref = await SharedPreferences.getInstance();
        pref.setBool("logedIn", true);
        pref.setInt("accIndex", i);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
        break; // Exit the loop since credentials are found and valid
      }
    }

    if (!userFound) {
      // Show the Snackbar if no credentials matched
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Username or Password is Wrong"),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ));
    }

    await userBox.close(); // Close the Hive box
  }

  void clearUserBox() async {
    var userBox = await Hive.openBox<User>("userBox");
    await userBox.clear();
    await userBox.close();
    print("All data in the userBox has been cleared.");
  }

  String decryptData(String encryptText) {
    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    final decrypted = encrypter.decrypt64(encryptText, iv: iv);

    return decrypted;
  }

  void checkIfLogedIn() async {
    pref = await SharedPreferences.getInstance();

    bool logedIn = pref.getBool("logedIn") ?? false;

    if (logedIn) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return HomePage();
      }));
    } else {}
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkIfLogedIn();
    // clearUserBox();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Login",
                      style:
                          TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Please sign in to continue",
                      style: TextStyle(fontWeight: FontWeight.w400),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: usernameController,
                        keyboardType: TextInputType.name,
                        decoration: const InputDecoration(
                            labelText: "Username",
                            prefixIcon: Icon(Icons.account_circle_rounded)),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please insert an username";
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        decoration: const InputDecoration(
                            labelText: "Password",
                            prefixIcon: Icon(Icons.vpn_key)),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please insert the password";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return const SignupPage();
                              }));
                            },
                            child: const Text(
                              "Sign up",
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                          ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  checkInputForLogin();
                                  // clearUserBox();
                                }
                                // print(user);
                                // print(pass);
                              },
                              child: const Text(
                                "Sign in",
                                style: TextStyle(fontSize: 18),
                              ))
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 50,
          left: MediaQuery.of(context).size.width - 100,
          child: Container(
            width: 200,
            height: 200,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFAF8F6F),
            ),
          ),
        ),
        Positioned(
          top: 50,
          left: MediaQuery.of(context).size.width - 200,
          child: Container(
            width: 75,
            height: 75,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFAF8F6F),
            ),
          ),
        ),
      ]),
    );
  }
}
