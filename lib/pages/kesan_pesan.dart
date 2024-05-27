import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class KesanPesanPage extends StatelessWidget {
  const KesanPesanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.home),
        title: const Text("Kesan dan Pesan"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            child: Container(
              padding: const EdgeInsets.fromLTRB(0, 25, 0, 25),
              child: const Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Saran Dan Kesan Mata Kuliah Teknologi Pemrograman Mobile",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                      ),
                    ),
                    SizedBox(height: 10,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("1. "),
                        // const Text(" : "),
                        Expanded(child: Text("Untuk ujian setidaknya diperbolehkan untuk membawa cheatsheet 1 lembar HVS atau bahkan open book")),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("2. "),
                        // const Text(" : "),
                        Expanded(child: Text("Untuk pengerjaan waktu kuis bisa diperpanjang lagi")),
                      ],
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
