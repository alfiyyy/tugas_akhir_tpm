import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:proyek_akhir_tpm/model/user.dart';
import 'package:proyek_akhir_tpm/pages/home.dart';
import 'package:proyek_akhir_tpm/pages/login.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:shared_preferences/shared_preferences.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final birthController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final key = encrypt.Key.fromUtf8('my 32 length key................');
  final iv = encrypt.IV.fromUtf8("1234567890123456");

  late SharedPreferences pref;

  String encryptData(String plainText) {
    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return encrypted.base64;
  }

  String decryptData(String encryptText) {
    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    final decrypted = encrypter.encrypt(encryptText, iv: iv);

    return decrypted.base64;
  }

  void registerUser() async {
    var userBox = await Hive.openBox<User>("userBox");
    pref = await SharedPreferences.getInstance();

    // Check if the username already exists
    bool userFound =
        userBox.values.any((user) => user.username == usernameController.text);

    if (userFound) {
      print("Username already exists");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Username is already taken"),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ));
    } else {
      var encryptedPassword = encryptData(passwordController.text);

      var user = User(
        username: usernameController.text,
        email: emailController.text,
        birth: birthController.text,
        password: encryptedPassword,
        coffees: [],
        profilePicPath: "",
      );

      await userBox.add(user);

      // Set the accIndex based on the count of users in the Hive box
      int userCount = userBox.length;
      await pref.setInt("accIndex", userCount-1);
      await pref.setBool("logedIn", true);

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return HomePage();
      }));
      print("User registered successfully");
    }

    await userBox.close();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
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
                        "Sign Up",
                        style: TextStyle(
                            fontSize: 35, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Please sign up to create an account ",
                        style: TextStyle(fontWeight: FontWeight.w400),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Form(
                  key: _formKey,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
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
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                              labelText: "Email",
                              hintText: "loremipsum@gmail.com",
                              prefixIcon: Icon(Icons.mail)),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!value.contains('@')) {
                              return 'Please enter a valid email address (must contain \'@\')';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: birthController,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9/]')),
                            LengthLimitingTextInputFormatter(10),
                          ],
                          keyboardType: TextInputType.datetime,
                          maxLength: 10,
                          decoration: const InputDecoration(
                              labelText: "Birth (dd/mm/yyyy)",
                              hintText: "16/10/2003",
                              prefixIcon: Icon(Icons.date_range)),
                          validator: (value) {
                            if (!RegExp(r'^\d{2}/\d{2}/\d{4}$')
                                .hasMatch(value!)) {
                              return 'Invalid birth date format (dd/mm/yyyy)';
                            }

                            final parts = value.split('/');
                            final day = int.tryParse(parts[0]);
                            final month = int.tryParse(parts[1]);
                            final year = int.tryParse(parts[2]);
                            final leapDay = year! % 4;

                            if (day! < 1 || day > 31) {
                              return 'Day must be between 01 and 31';
                            }

                            if (month! < 1 || month > 12) {
                              return 'Month must be between 01 and 12';
                            }

                            if (month == 02 && day >= 29 && leapDay != 0) {
                              return "not a valid date";
                            }

                            if (year > 2003) {
                              return "must at least born in 2003";
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
                            if (value!.length < 6) {
                              return "password must contain more than 5 characters";
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
                                  return const LoginPage();
                                }));
                              },
                              child: const Text(
                                "Sign in",
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.w300),
                              ),
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    String username = usernameController.text;
                                    String email = emailController.text;
                                    String birth = birthController.text;
                                    String password = passwordController.text;
                                    if (username != "" &&
                                        email != "" &&
                                        birth != "" &&
                                        password != "") {
                                      registerUser();

                                      // User user = User(username: username,email: email,birth: birth,password: password)
                                      // loginData.setString('username', username);
                                      // loginData.setString('email', email);
                                      // loginData.setString('birth', birth);
                                      // loginData.setString('password', password);
                                      // loginData.setStringList('users', user);
                                      // Navigator.pushReplacement(context,
                                      //     MaterialPageRoute(builder: (context) {
                                      //   return HomePage();
                                      // }));
                                    }
                                  }
                                },
                                child: const Text(
                                  "Sign up",
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
        ),
        Positioned(
          top: MediaQuery.of(context).size.height - 100,
          left: -55,
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
          top: MediaQuery.of(context).size.height - 150,
          left: 120,
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
