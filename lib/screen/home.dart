import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_code_crypt/screen/form.dart';
import 'package:qr_code_crypt/screen/qrCodeScanner.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  navigateToForm(context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const FormScreen(),
          // builder: (context) => const FormScreen(),
        ));
  }

  navigateToScan(context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const QrCodeScanner(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("QR Code Crypt", style: GoogleFonts.roboto()),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 40),
            width: double.infinity,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () => navigateToForm(context),
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.all(16.0), // Adjust padding as needed
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              8.0), // Set the border radius
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.qr_code_2_outlined),
                          Text(
                            "Generate QR Code",
                            style: TextStyle(color: Colors.black),
                          ),
                          Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white54),
                              child: Icon(Icons.chevron_right_outlined))
                        ],
                      )),
                ),
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () => navigateToScan(context),
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.all(16.0), // Adjust padding as needed
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              8.0), // Set the border radius
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.qr_code_scanner),
                          Text(
                            "Scan QR Code",
                            style: TextStyle(color: Colors.black),
                          ),
                          Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white54),
                              child: Icon(Icons.chevron_right_outlined))
                        ],
                      )),
                ),
                SizedBox(height: 100),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 60),
                    child: Image.asset("images/welcomeQR.png")),
              ],
            ),
          ),
        ));
  }
}
