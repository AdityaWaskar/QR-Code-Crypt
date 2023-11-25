import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:qr_code_crypt/screen/information.dart';
import 'package:qr_code_crypt/screen/password.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  var channel = MethodChannel("cryptography/chacha20-poly");

  // showPrint() {
  //   channel.invokeMethod("print");
  // }

  final _formfield = GlobalKey<
      FormState>(); // * Globalkey which maintains the state of a widget across the entire widget tree of the application.
  String selectGender = "Male"; // * Stores usergender value(default = Male)
  final nameController =
      TextEditingController(); // * Stores the user nameFiled input
  final dobController =
      TextEditingController(); // * Stores the user Date of birth input
  final phoneController =
      TextEditingController(); // * Stores the user phone No.
  final formGlobalKey = GlobalKey<
      FormState>(); // * Globalkey which maintains the state of a widget across the entire widget tree of the application.
  // DateTime date =
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Identity Card",
            style: GoogleFonts.sourceCodePro()), // * Header name
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Form(
              key: formGlobalKey,
              child: Column(
                children: [
                  // * User Profile icon
                  Image.asset("images/profile.png", height: 150, width: 150),
                  const SizedBox(height: 50),
                  // * input field 1 = Name
                  TextFormField(
                    // * validator which checks the field is not empty and must contains all alphabetical characters
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter you name !';
                      }
                      // else if (!isAlphabetical(value) || value.contains(" ")) {
                      //   return "Invalid name !";
                      // }
                      return null;
                    },
                    controller: nameController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                        labelText: "Name",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.account_circle)),
                  ),
                  const SizedBox(height: 20),

                  //* input field 2 = Date Of birth
                  TextFormField(
                    // * on optap the calendar appers in which user will picked the date
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime(2002, 12, 24),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100));

                      // * Formate the Date and convert it into string formate
                      if (pickedDate != null) {
                        String formattedDate =
                            DateFormat('dd-MM-yyyy').format(pickedDate);

                        // * Also update in User Interface
                        setState(() => dobController.text = formattedDate);
                      } else {
                        print("Date is not selected");
                      }
                    },
                    controller: dobController,
                    keyboardType: TextInputType.emailAddress,
                    readOnly: true,
                    decoration: const InputDecoration(
                        labelText: "DOB",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.calendar_today)),
                  ),
                  const SizedBox(height: 20),

                  // * input field 3 = Gender
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.black)),
                    width: 400,
                    // * Dropdown button which shows three options - Male, Female and Others
                    child: DropdownButton(
                      style: const TextStyle(color: Colors.black),
                      iconEnabledColor: Colors.black, // * down icon color
                      iconSize: 36,
                      isExpanded: true, //* gets the field widht full size
                      items: dropdownItems,
                      value: selectGender,
                      // * Also update the selectGender variable on change
                      onChanged: (String? newValue) {
                        setState(() => selectGender = newValue!);
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  // * input field 4 = phone no
                  TextFormField(
                    // * validator which cheks the input field is not empty and the phone No. must be 10 digits only.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter Phone No. !';
                      } else if (value.length != 10) {
                        return "Invalid Phone No.";
                      }
                      return null;
                    },
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                        labelText: "Phone No.",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.phone)),
                  ),
                  const SizedBox(height: 30),

                  //* button field
                  // * Create the button function which Generate QR code
                  button(
                      formGlobalKey,
                      "Generate QR Code",
                      _formfield,
                      nameController,
                      dobController,
                      selectGender,
                      phoneController,
                      context),

                  //* Create Scan button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have QR Code ? ",
                        style: TextStyle(fontSize: 16),
                      ),
                      TextButton(
                          onPressed: () {},
                          child: const Text(
                            "Scan",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          )),
                      const SizedBox(height: 50),
                    ],
                  ),
                ],
              )),
        ),
      ),
    );
  }
}

// * function for generate QR Code
InkWell button(_formKey, name, formField, nameController, dobController,
    selectGender, phoneController, context) {
  //* Inkwell will respond when the user clicks the button.
  return InkWell(
    onTap: () {
      //* If the all the input fileds are valid than globalKey (_formKey) is true else false.
      if (_formKey.currentState!.validate()) {
        // print("data is true");
        Information info = Information(
            name: nameController.text,
            dob: dobController.text,
            gender: selectGender,
            phoneNo: phoneController.text);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => PasswordScreen(info)));
        // print("(" +
        //     nameController.text +
        //     ", " +
        //     dobController.text +
        //     ", " +
        //     selectGender +
        //     ", " +
        //     phoneController.text +
        //     " )");
      } else {
        print("data is Invalid");
        // channel.invokeMethod("print");
      }
    },
    child: Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
          child: Text(
        "Generate QR Code",
        style: GoogleFonts.sourceCodePro(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      )),
    ),
  );
}

// * Create the Dropdown menu which includes the options like Male, Female and Others.
List<DropdownMenuItem<String>> get dropdownItems {
  List<DropdownMenuItem<String>> menuItems = [
    DropdownMenuItem(
      child: Row(
        children: const [
          Icon(Icons.male, size: 25, color: Colors.black),
          SizedBox(width: 12),
          Text("Male", style: TextStyle(fontSize: 16))
        ],
      ),
      value: "Male", // * For male
    ),
    DropdownMenuItem(
      child: Row(
        children: const [
          Icon(Icons.female, size: 25, color: Colors.black),
          SizedBox(width: 12),
          Text("Female", style: TextStyle(fontSize: 16))
        ],
      ),
      value: "Female", // * For female
    ),
    DropdownMenuItem(
      child: Row(
        children: const [
          Icon(Icons.transgender, size: 25, color: Colors.black),
          SizedBox(width: 12),
          Text("Other", style: TextStyle(fontSize: 16))
        ],
      ),
      value: "Other", // * For others
    ),
  ];
  return menuItems;
}

// * Function which checks Wheather the given string contains all the alphabets.
bool isAlphabetical(String inputString) {
  RegExp regex = RegExp(r'^[a-zA-Z]+$');
  return regex.hasMatch(inputString);
}
