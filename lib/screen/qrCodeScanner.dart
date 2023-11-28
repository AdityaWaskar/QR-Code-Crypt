import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_code_crypt/screen/qrCodeVerify.dart';
import 'package:qr_scanner_overlay/qr_scanner_overlay.dart';

const bgColor = Color(0xfffafafa);

class QrCodeScanner extends StatefulWidget {
  const QrCodeScanner({Key? key}) : super(key: key);

  @override
  _QRScannerState createState() => _QRScannerState();
}

class _QRScannerState extends State<QrCodeScanner> {
  bool isScanCompleted = false;

  void closeScreen() {
    print("==========================closign closgin=========================");
    isScanCompleted = false;
  }

  // void openScreen() {
  //   isScanCompleted = true;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "QR Scanner",
          style: GoogleFonts.roboto(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              wordSpacing: 1.2
              // letterSpacing: 1,
              ),
        ),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Place the QR Code in the Area",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      // letterSpacing: 1,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Scanning will be started automatically",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: Stack(children: [
                MobileScanner(
                  allowDuplicates: true,
                  onDetect: (barcode, args) {
                    print(
                        "===============Running Running Runing==================");
                    if (!isScanCompleted) {
                      String code = barcode.rawValue ?? '---';
                      isScanCompleted = true;

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QrCodeVerifyScreen(
                            closeScanner: closeScreen,
                            info: code,
                          ),
                        ),
                      );
                    }
                  },
                ),
                QRScannerOverlay(
                  overlayColor: Colors.grey[50],
                  borderColor: Colors.blue,
                )
              ]),
            ),
            // QrScannerOverlayShape(overlayColor: bgColor),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  "QR CODE CRYPT",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                    // letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
