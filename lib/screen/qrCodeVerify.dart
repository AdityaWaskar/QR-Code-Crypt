import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:qr_code_crypt/screen/information.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class QrCodeVerifyScreen extends StatefulWidget {
  final String info;
  final Function() closeScanner;

  const QrCodeVerifyScreen(
      {super.key, required this.closeScanner, required this.info});
  static const platform = MethodChannel('com.example.qr_code_crypt/crypto');

  @override
  State<QrCodeVerifyScreen> createState() => _QrCodeVerifyScreenState();
}

class _QrCodeVerifyScreenState extends State<QrCodeVerifyScreen> {
  Information information = Information(
      name: "xxxxxxxx xxxxxxxx",
      dob: "xx/xx/xxxx",
      gender: "xxxx",
      phoneNo: "xxxxxxxxxx");
  final _passwordGlobalKey2 = GlobalKey<FormState>();

  bool _isVisible = true;
  bool _isLoading = false;
  bool _isReadOnly = false;

  final passwordController = TextEditingController();

  Future<String> decryptData() async {
    try {
      final result = await QrCodeVerifyScreen.platform.invokeMethod('decrypt',
          {"info": widget.info, "password": passwordController.text});
      return result;
    } on PlatformException catch (e) {
      return "Error : $e";
    }
  }

  Future<void> onClickedEvent(context, info, password) async {
    setState(() => _isLoading = true);
    try {
      String value = await decryptData();
      Information _info = Information().parseInformation(value.toString());
      await Future.delayed(const Duration(seconds: 1));
      if (_info.name == null) {
        Fluttertoast.showToast(
          msg: "Access Denied !",
          toastLength: Toast.LENGTH_SHORT, // or Toast.LENGTH_LONG
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        Fluttertoast.showToast(
          msg: "Access Granted !",
          toastLength: Toast.LENGTH_SHORT, // or Toast.LENGTH_LONG
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        setState(() {
          information = _info;
          _isReadOnly = true;
          _isVisible = true;
        });
      }
      setState(() => _isLoading = false);
    } on PlatformException catch (e) {
      setState(() => _isLoading = false);
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Identity Verification",
          style: GoogleFonts.roboto(),
        ),
        leading: IconButton(
            onPressed: () {
              widget.closeScanner();
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black87,
            )),
        centerTitle: true,
      ),
      body:
          //  _isLoading
          //     ? loadingScreen()
          //     :
          SingleChildScrollView(
        child: Padding(
          // padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            // color: Colors.red,
                            child: Image.asset(
                              "images/profile.png",
                              width: 100,
                              height: 100,
                            ),
                          ),
                          const SizedBox(width: 10),
                          SingleChildScrollView(
                            child: SizedBox(
                              // color: Colors.blue,
                              width: 200,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // * right section
                                  Skeletonizer(
                                    enabled: _isLoading,
                                    child: SizedBox(
                                      width: 200,
                                      child: Text("Name : ${information.name}",
                                          style: GoogleFonts.montserrat(
                                              fontSize: 13)),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Skeletonizer(
                                    enabled: _isLoading,
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: Text("DOB : ${information.dob}",
                                          style: GoogleFonts.montserrat(
                                              fontSize: 13)),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Skeletonizer(
                                    enabled: _isLoading,
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: Text(
                                          "Gender : ${information.gender}",
                                          style: GoogleFonts.montserrat(
                                              fontSize: 13)),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Skeletonizer(
                                    enabled: _isLoading,
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: Text(
                                          "Phone No. : ${information.phoneNo}",
                                          style: GoogleFonts.montserrat(
                                              fontSize: 13)),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  // * End of right section
                                ],
                              ),
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
                    "Unlock your data with correct password.  ",
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Form(
                key: _passwordGlobalKey2,
                child: TextFormField(
                  controller: passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password field mandatory*';
                    }
                    return null;
                  },
                  obscureText: _isVisible,
                  readOnly: _isReadOnly,
                  decoration: InputDecoration(
                      hintText: "eg. protecttheinfomation",
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _isVisible = !_isVisible;
                            });
                          },
                          icon: _isVisible
                              ? const Icon(
                                  Icons.visibility_off,
                                  color: Colors.grey,
                                )
                              : const Icon(
                                  Icons.visibility,
                                  color: Colors.black,
                                ))),
                ),
              ),
              const SizedBox(height: 30),
              Container(
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                    onPressed: () => onClickedEvent(
                        context, widget.info, passwordController.text),
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
                    child: const Text("UNLOCK YOUR DATA",
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

Widget loadingScreen() {
  return Scaffold(
    body: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 150),
        // * Lottie is animation platform which has various types of animations
        Center(child: Lottie.asset('images/QR_code.json')),
        SizedBox(
          child: DefaultTextStyle(
            style: GoogleFonts.quicksand(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black),
            child: AnimatedTextKit(
                onFinished: () {},
                totalRepeatCount: 1,
                animatedTexts: [
                  TypewriterAnimatedText("Decoding.....",
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
