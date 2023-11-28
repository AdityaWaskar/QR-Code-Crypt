import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 150),
          // * Lottie is animation platform which has various types of animations
          Center(child: Lottie.asset('images/encryption1.json')),
          SizedBox(
            child: DefaultTextStyle(
              style: GoogleFonts.quicksand(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
              child: AnimatedTextKit(
                  onFinished: () {
                    
                  },
                  totalRepeatCount: 1,
                  animatedTexts: [
                    TypewriterAnimatedText("Generating QR Code",
                        curve: Curves.easeIn,
                        speed: const Duration(milliseconds: 80),
                        cursor: "|"),
                  ]),
            ),
          )
        ],
      ),
    );
  }
}
