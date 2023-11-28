import 'package:flutter/material.dart';
import 'package:qr_code_crypt/screen/splash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR Code Crypt', // * title of the project
      debugShowCheckedModeBanner:
          false, // * Hides the debug tag which displays at top right in the device
      theme: ThemeData(primarySwatch: Colors.blue),
      color: Colors.transparent,
      home: const MyHomePage(title: 'QR CODE CRYPT'), // * Page name
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const SplashScreen(), // * Start with this splashScreen Screen
    );
  }
}
