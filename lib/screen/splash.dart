import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:qr_code_crypt/screen/home.dart';

// * Use stateful widget
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  // * The aim of this initState fucntion : when app starts than for 3 second thid splash screen will render than the formScreen renders.
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            // builder: (context) => const LoadingScreen(),
            builder: (context) => const HomeScreen(),
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 150),
          // * Lottie is animation platform which has various types of animations
          Center(child: Lottie.asset('images/QR_code2.json')),
          Text(
            "QR Code Crypt",
            style: GoogleFonts.quicksand(
                fontSize: 25, fontWeight: FontWeight.w700),
          )
        ],
      ),
    );
  }
}
