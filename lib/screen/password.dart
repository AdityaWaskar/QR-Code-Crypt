import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_code_crypt/screen/information.dart';
import 'package:qr_code_crypt/screen/qrcodedisplay.dart';

class PasswordScreen extends StatelessWidget {
  final Information info;
  PasswordScreen(this.info, {super.key});
  final passwordController = TextEditingController();
  static const platform = MethodChannel('com.example.qr_code_crypt/crypto');

  Future<String> encryptData() async {
    try {
      final result = await platform.invokeMethod('encrypt',
          {"userText": info.toString(), "userPass": passwordController.text});
      return result;
    } on PlatformException catch (e) {
      return "Error : $e";
    }
  }

  onClickedEvent(context, info, password) {
    encryptData().then((value) => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => QrCodeDisplay(value, password))));
  }

  @override
  Widget build(BuildContext context) {
    // return Container(
    //   padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
    //   child: Text("${info.name.toString()},${info.dob.toString()}"),
    // );
    return Scaffold(
      appBar: AppBar(
        title: const Text("Password Screen"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            children: [
              // Row(
              //   children: [
              //     Text("Name : ", style: TextStyle(fontSize: 25)),
              //     Text("${info.name.toString()} ",
              //         style: TextStyle(fontSize: 25))
              //   ],
              // )
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1.0),
                  borderRadius: BorderRadius.circular(10.0),
                  // Background Color
                  color: Colors.grey[200],
                  // Box Shadow
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    dynamicRow("Name", info.name.toString()),
                    const SizedBox(height: 10),
                    dynamicRow("DOB", info.dob.toString()),
                    const SizedBox(height: 10),
                    dynamicRow("Gender", info.gender.toString()),
                    const SizedBox(height: 10),
                    dynamicRow("Phone No.", info.phoneNo.toString()),
                    const SizedBox(height: 10)
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text("Password", style: TextStyle(fontSize: 25)),
              const SizedBox(height: 30),
              const Text("Protect you data by entering the password..."),
              const SizedBox(height: 10),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(
                    hintText: "eg. protecttheinfomation",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock)),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () =>
                      onClickedEvent(context, info, passwordController.text),
                  child: const Text("PROTECT YOUR DATA"))
            ],
          ),
        ),
      ),
    );
  }
}

Row dynamicRow(label, value) {
  return Row(
    children: [
      Text("$label : ", style: GoogleFonts.montserrat(fontSize: 20)),
      Text("$value", style: GoogleFonts.montserrat(fontSize: 20))
    ],
  );
}
