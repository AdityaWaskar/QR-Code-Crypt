import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:qr_code_crypt/screen/information.dart';
import 'package:qr_code_crypt/screen/qrcodedisplay.dart';

class PasswordScreen extends StatefulWidget {
  final Information info;
  PasswordScreen(this.info, {super.key});
  static const platform = MethodChannel('com.example.qr_code_crypt/crypto');

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final passwordController = TextEditingController();

  final _passwordGlobalKey1 = GlobalKey<FormState>();

  bool _isVisible = false;
  bool _isPasswordEightCharater = false;
  bool _ispasswordContainsNumber = false;
  bool _isLoading = false;

  Future<String> encryptData() async {
    try {
      final result = await PasswordScreen.platform.invokeMethod('encrypt', {
        "userText": widget.info.toString(),
        "userPass": passwordController.text
      });
      return result;
    } on PlatformException catch (e) {
      return "Error : $e";
    }
  }

  onPasswordChange(password) {
    final numericRegex = RegExp(r'[0-9]');
    setState(() {
      _isPasswordEightCharater = false;
      if (password.length >= 8) _isPasswordEightCharater = true;

      _ispasswordContainsNumber = false;
      if (numericRegex.hasMatch(password)) _ispasswordContainsNumber = true;
    });
  }

  onClickedEvent(context, info, password) async {
    setState(() => _isLoading = true);

    if (_passwordGlobalKey1.currentState!.validate() &&
        _isPasswordEightCharater &&
        _ispasswordContainsNumber) {
      // Use await with Future.delayed to create a delay

      try {
        // Use await with encryptData to wait for its completion
        String value = await encryptData();

        // Navigate to the next screen
        await Future.delayed(const Duration(seconds: 1), () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QrCodeDisplay(value, password),
            ),
          );
        });
      } catch (e) {
        // Handle errors, if any
        print("Error: $e");
      } finally {
        // This block will be executed whether there's an error or not
        await Future.delayed(const Duration(seconds: 2),
            () => setState(() => _isLoading = false));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Password Screen",
          style: GoogleFonts.roboto(),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? loadingScreen()
          : SingleChildScrollView(
              child: Padding(
                // padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
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
                                  child: Container(
                                    // color: Colors.blue,
                                    width: 200,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // * right section
                                        Text(
                                            "Name : ${widget.info.name.toString()}",
                                            style: GoogleFonts.montserrat(
                                                fontSize: 13)),
                                        const SizedBox(height: 10),
                                        Text(
                                            "DOB : ${widget.info.dob.toString()}",
                                            style: GoogleFonts.montserrat(
                                                fontSize: 13)),
                                        const SizedBox(height: 10),
                                        Text(
                                            "Gender : ${widget.info.gender.toString()}",
                                            style: GoogleFonts.montserrat(
                                                fontSize: 13)),
                                        const SizedBox(height: 10),
                                        Text(
                                            "Phone No. : ${widget.info.phoneNo.toString()}",
                                            style: GoogleFonts.montserrat(
                                                fontSize: 13)),
                                        const SizedBox(height: 10),
                                        // dynamicRow("DOB", widget.info.dob.toString()),
                                        // const SizedBox(height: 10),
                                        // dynamicRow(
                                        //     "Gender", widget.info.gender.toString()),
                                        // const SizedBox(height: 10),
                                        // dynamicRow(
                                        //     "Phone No.", widget.info.phoneNo.toString()),
                                        // const SizedBox(height: 15),
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
                      // mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Icon(Icons.perm_device_information,
                              size: 17, color: Colors.grey),
                        ),
                        Flexible(
                          child: Text(
                            "Protect you data by entering the password including the following criteria below.",
                            style: TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Form(
                      key: _passwordGlobalKey1,
                      child: Column(
                        children: [
                          TextFormField(
                            onChanged: (password) => onPasswordChange(password),
                            obscureText: _isVisible,
                            controller: passwordController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password field mandatory*';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                hintText: "eg. protecttheinfomation",
                                border: const OutlineInputBorder(),
                                prefixIcon: Icon(Icons.lock),
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
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(children: [
                      AnimatedContainer(
                        duration: const Duration(microseconds: 500),
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                            color: _isPasswordEightCharater
                                ? Colors.green
                                : Colors.transparent,
                            border: _isPasswordEightCharater
                                ? Border.all(color: Colors.transparent)
                                : Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(50)),
                        child: const Center(
                            child: Icon(Icons.check,
                                color: Colors.white, size: 15)),
                      ),
                      const SizedBox(width: 10),
                      const Text("Contains at least 8 charaters."),
                    ]),
                    const SizedBox(height: 10),
                    Row(children: [
                      AnimatedContainer(
                        duration: const Duration(microseconds: 500),
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                            color: _ispasswordContainsNumber
                                ? Colors.green
                                : Colors.transparent,
                            border: _ispasswordContainsNumber
                                ? Border.all(color: Colors.transparent)
                                : Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(50)),
                        child: const Center(
                            child: Icon(Icons.check,
                                color: Colors.white, size: 15)),
                      ),
                      const SizedBox(width: 10),
                      const Text("Contains at least 1 number."),
                    ]),
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
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
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
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("$label : ", style: GoogleFonts.montserrat(fontSize: 13)),
        // fontSize: (value.length ? 13 : 10)),
        Text("$value", style: GoogleFonts.montserrat(fontSize: 13))
      ],
    ),
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
        Center(child: Lottie.asset('images/encryption1.json')),
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
                  TypewriterAnimatedText("Generating.....",
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
