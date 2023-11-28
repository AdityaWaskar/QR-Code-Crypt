import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_crypt/screen/home.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:esys_flutter_share_plus/esys_flutter_share_plus.dart';

import 'dart:ui' as ui;

class QrCodeDisplay extends StatefulWidget {
  final String info;
  final String encryptionKey;
  const QrCodeDisplay(this.info, this.encryptionKey);

  @override
  State<QrCodeDisplay> createState() => _QrCodeDisplayState();
}

class _QrCodeDisplayState extends State<QrCodeDisplay> {
  final GlobalKey _globalKey = GlobalKey();

  Future<void> saveOnDevice() async {
    try {
      // Request storage permission
      var status = await Permission.storage.request();
      if (status.isGranted) {
        RenderRepaintBoundary boundary = _globalKey.currentContext!
            .findRenderObject() as RenderRepaintBoundary;
        ui.Image image = await boundary.toImage(pixelRatio: 3.0);
        ByteData? byteData =
            await image.toByteData(format: ui.ImageByteFormat.png);

        if (byteData == null) {
          print('Error: Captured image data is null.');
          return;
        }

        Uint8List pngBytes = byteData.buffer.asUint8List();

        // Save image to the temporary directory
        final tempDir = await getTemporaryDirectory();
        final file = await File('${tempDir.path}/image.png').create();
        await file.writeAsBytes(pngBytes);
        await file.writeAsBytes(pngBytes);

        // Save image to the gallery
        await ImageGallerySaver.saveFile(file.path);

        print('Image saved to gallery: ${file.path}');
      } else {
        print('Storage permission denied');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> shareQrCode() async {
    try {
      RenderRepaintBoundary boundary = _globalKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      var image = await boundary.toImage();
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        print('Error: Captured image data is null.');
        return;
      }
      Uint8List pngBytes = byteData.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/image.png').create();
      await file.writeAsBytes(pngBytes);
      String dataString = "qrCode";
      await Share.file(dataString, '$dataString.png', pngBytes, 'image/png');
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QR Code Display",
            style: GoogleFonts.roboto()), // * Header name
        centerTitle: true,
        toolbarHeight: 80,
        // backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 60),
            Center(
              child: RepaintBoundary(
                key: _globalKey,
                child: Container(
                  color: Colors.white,
                  child: QrImageView(
                    data: widget.info,
                    version: QrVersions.auto,
                    // embeddedImage: AssetImage('images/profile.png'),
                    size: 200.0,
                  ),
                ),
              ),
            ),
            Text("Password - ${widget.encryptionKey}"),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 130,
                  child: ElevatedButton(
                      onPressed: () async {
                        saveOnDevice().then((value) => Fluttertoast.showToast(
                              msg: "QR code downloaded successfully!",
                              toastLength:
                                  Toast.LENGTH_SHORT, // or Toast.LENGTH_LONG
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1, // only for iOS
                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            ));
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.blue),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                5.0), // Adjust the border radius as needed
                          ),
                        ),
                      ),
                      child: Text("Download",
                          style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15))),
                ),
                const SizedBox(width: 20),
                SizedBox(
                  width: 130,
                  child: ElevatedButton(
                      onPressed: () async {
                        shareQrCode().then((value) => Fluttertoast.showToast(
                              msg: "QR code shared successfully!",
                              toastLength:
                                  Toast.LENGTH_SHORT, // or Toast.LENGTH_LONG
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1, // only for iOS
                              backgroundColor: Colors.blue,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            ));
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.blue),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                5.0), // Adjust the border radius as needed
                          ),
                        ),
                      ),
                      child: Text("Share",
                          style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15))),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 280,
              height: 40,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()),
                        (route) => false);
                  },
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.home, color: Colors.white),
                      const SizedBox(width: 10),
                      Text("Home",
                          style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15))
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }
}
