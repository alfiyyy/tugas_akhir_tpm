import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:proyek_akhir_tpm/model/user.dart';
import 'package:proyek_akhir_tpm/pages/order_history.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

late SharedPreferences pref;

class _ProfilePageState extends State<ProfilePage> {
  String? username = "";
  String? email = "";
  String? birth = "";
  String? _imageFilePath;
  final ImagePicker _picker = ImagePicker();
  String currentTime = "";
  String currentZone = "WIB";
  Timer? _timer;

  void loadAccInfo() async {
    pref = await SharedPreferences.getInstance();
    var userBox = await Hive.openBox<User>("userBox");

    int accIndex = pref.getInt("accIndex")!;

    setState(() {
      username = userBox.getAt(accIndex)!.username;
      email = userBox.getAt(accIndex)!.email;
      birth = userBox.getAt(accIndex)!.birth;
      _imageFilePath = userBox.getAt(accIndex)?.profilePicPath;
    });

    await userBox.close();
  }

  void choosePhoto(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      var userBox = await Hive.openBox<User>("userBox");

      int accIndex = pref.getInt("accIndex")!;

      User user = userBox.getAt(accIndex)!;
      user.profilePicPath = pickedFile.path;

      await userBox.putAt(accIndex, user);

      if (mounted) {
        setState(() {
          _imageFilePath = userBox.getAt(accIndex)?.profilePicPath;
        });
      }

      await userBox.close();
    }
  }

  void updateTime() {
    DateTime now = DateTime.now();
    String timeZone;

    switch (currentZone) {
      case "WIB":
        timeZone = "Asia/Jakarta";
        break;
      case "WIT":
        timeZone = "Asia/Jayapura";
        break;
      case "WITA":
        timeZone = "Asia/Makassar";
        break;
      case "London":
        timeZone = "Europe/London";
        break;
      default:
        timeZone = "Asia/Jakarta";
    }

    final DateFormat formatter = DateFormat('HH:mm:ss');
    final time = now.toUtc().add(Duration(hours: _getOffset(timeZone)));
    if (mounted) {
      setState(() {
        currentTime = formatter.format(time);
      });
    }
  }

  int _getOffset(String timeZone) {
    switch (timeZone) {
      case "Asia/Jakarta":
        return 7;
      case "Asia/Jayapura":
        return 9;
      case "Asia/Makassar":
        return 8;
      case "Europe/London":
        return 0;
      default:
        return 7;
    }
  }

  @override
  void initState() {
    super.initState();
    loadAccInfo();
    updateTime();
    // Update time every second
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      updateTime();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.home),
        title: const Text("Profile"),
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
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 80,
                              backgroundImage: _imageFilePath != null
                                  ? FileImage(File(_imageFilePath!))
                                  : null,
                              child: _imageFilePath == null
                                  ? const Icon(Icons.person, size: 80)
                                  : null,
                            ),
                            Positioned(
                              bottom: 10,
                              right: 20,
                              child: IconButton(
                                onPressed: () {
                                  choosePhoto(ImageSource.gallery);
                                },
                                icon: const Icon(Icons.camera_alt),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Expanded(
                              flex: 1,
                              child: Text("Username"),
                            ),
                            const Text(" : "),
                            Expanded(
                              flex: 2,
                              child: Text("$username"),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Expanded(
                              flex: 1,
                              child: Text("Email"),
                            ),
                            const Text(" : "),
                            Expanded(
                              flex: 2,
                              child: Text("$email"),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Expanded(
                              flex: 1,
                              child: Text("Birth"),
                            ),
                            const Text(" : "),
                            Expanded(
                              flex: 2,
                              child: Text("$birth"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  showbuyHistory();
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const OrderHistoryPage();
                  }));
                },
                child: const Text("List Order Coffee"),
              ),
            ),
            const SizedBox(height: 50),
            Text(
              currentTime,
              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 50,
                  height: 35,
                  decoration: BoxDecoration(
                    color: currentZone == "WIB" ? Colors.brown.shade300 : Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                    ),
                  ),
                  child: Center(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          currentZone = "WIB";
                          updateTime();
                        });
                      },
                      child: Text(
                        "WIB",
                        style: TextStyle(
                          color: currentZone == "WIB" ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 50,
                  height: 35,
                  decoration: BoxDecoration(
                    color: currentZone == "WIT" ? Colors.brown.shade300 : Colors.white,
                  ),
                  child: Center(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          currentZone = "WIT";
                          updateTime();
                        });
                      },
                      child: Text(
                        "WIT",
                        style: TextStyle(
                          color: currentZone == "WIT" ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 50,
                  height: 35,
                  decoration: BoxDecoration(
                    color: currentZone == "WITA" ? Colors.brown.shade300 : Colors.white,
                  ),
                  child: Center(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          currentZone = "WITA";
                          updateTime();
                        });
                      },
                      child: Text(
                        "WITA",
                        style: TextStyle(
                          color: currentZone == "WITA" ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 70,
                  height: 35,
                  decoration: BoxDecoration(
                    color: currentZone == "London" ? Colors.brown.shade300 : Colors.white,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                  ),
                  child: Center(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          currentZone = "London";
                          updateTime();
                        });
                      },
                      child: Text(
                        "London",
                        style: TextStyle(
                          color: currentZone == "London" ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void showbuyHistory() async {
  pref = await SharedPreferences.getInstance();
  var userBox = await Hive.openBox<User>("userBox");

  int accIndex = pref.getInt("accIndex")!;

  print(userBox.getAt(accIndex)?.coffees);
}
