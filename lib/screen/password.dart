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
        title: Text(
          "Password Screen",
          style: GoogleFonts.sourceCodePro(),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          // padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row(
              //   children: [
              //     Text("Name : ", style: TextStyle(fontSize: 25)),
              //     Text("${info.name.toString()} ",
              //         style: TextStyle(fontSize: 25))
              //   ],
              // )
              Container(
                // padding:
                //     const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
                  // border: Border.all(color: Colors.black, width: 0),
                  borderRadius: BorderRadius.circular(10.0),
                  // Background Color
                  color: Color.fromARGB(255, 245, 244, 244),
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
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 15, left: 15, right: 15, bottom: 10),
                      child: topBar(),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Container(
                          height: 0.5, // Adjust the height of the line
                          color: Colors.black),
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            // color: Colors.red,
                            child: Image.asset(
                              "images/profile.png",
                              width: 100,
                              height: 100,
                            ),
                          ),
                          Container(
                            // color: Colors.yellow,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // * right section
                                dynamicRow("Name", info.name.toString()),
                                const SizedBox(height: 10),
                                dynamicRow("DOB", info.dob.toString()),
                                const SizedBox(height: 10),
                                dynamicRow("Gender", info.gender.toString()),
                                const SizedBox(height: 10),
                                dynamicRow(
                                    "Phone No.", info.phoneNo.toString()),
                                const SizedBox(height: 15),
                                // * End of right section
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Container(
                          height: 0.5, // Adjust the height of the line
                          color: Colors.black),
                    ),
                    const SizedBox(height: 5),
                    Text("Secure your Identity with Digital ID Card",
                        style: GoogleFonts.sourceCodePro(fontSize: 10)),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              Center(
                  child: Text("Password",
                      style: GoogleFonts.sourceCodePro(
                          fontSize: 25, fontWeight: FontWeight.bold))),
              const SizedBox(height: 30),
              const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Icon(Icons.remove_red_eye,
                        size: 17, color: Colors.grey),
                  ),
                  Text(
                    "Protect you data by entering the password...",
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(
                    hintText: "eg. protecttheinfomation",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock)),
              ),
              const SizedBox(height: 30),
              Container(
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                    onPressed: () =>
                        onClickedEvent(context, info, passwordController.text),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              5.0), // Adjust the border radius as needed
                        ),
                      ),
                    ),
                    child: const Text("PROTECT YOUR DATA",
                        style: TextStyle(color: Colors.white))),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Row topBar() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Image.asset(
        "images/cardLogo.png",
        height: 35,
        width: 35,
        color: Color.fromARGB(
            162, 255, 255, 255), // Set the color and opacity (0.0 to 1.0)
        colorBlendMode: BlendMode.modulate,
        fit: BoxFit.cover,
      ),
      const SizedBox(width: 20),
      Center(
          child: Text("Digital ID Card",
              style: GoogleFonts.sourceCodePro(fontSize: 18))),
    ],
  );
}

Padding dynamicRow(label, value) {
  return Padding(
    padding: const EdgeInsets.only(left: 25, right: 25),
    child: Row(
      children: [
        Text("$label : ", style: GoogleFonts.montserrat(fontSize: 13)),
        Text("$value", style: GoogleFonts.montserrat(fontSize: 13))
      ],
    ),
  );
}
