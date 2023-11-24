import 'package:flutter/material.dart';
import 'package:qr_code_crypt/screen/information.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeDisplay extends StatelessWidget {
  final String info;
  final String encryptionKey;
  const QrCodeDisplay(this.info, this.encryptionKey);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("QR Code Display"), // * Header name
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: QrImageView(
              data: info,
              // "${info.name.toString()},${info.dob.toString()},${info.gender.toString()},${info.phoneNo.toString()}",
              version: QrVersions.auto,
              // embeddedImage: AssetImage('images/profile.png'),
              size: 200.0,
            ),
          ),
          Text("Password - $encryptionKey")
        ],
      ),
    );
  }
}
