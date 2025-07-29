import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class QrRenderPage extends StatefulWidget {
  const QrRenderPage({super.key});

  @override
  State<QrRenderPage> createState() => _QrRenderPageState();
}

class _QrRenderPageState extends State<QrRenderPage> {
  final ScreenshotController screenshotController = ScreenshotController();
  String? qrdata;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Creat QR Code"),
        actions: [
          GestureDetector(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.qr_code_scanner_sharp),
            ),
            onTap: () {
              Navigator.pushReplacementNamed(context, "/scanpage");
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 50,
                width: 350,
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onSubmitted: (value) {
                    setState(() {
                      qrdata = value;
                    });
                  },
                ),
              ),
              if (qrdata != null)
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(40),
                      child: Screenshot(
                        controller: screenshotController,
                        child: PrettyQrView.data(
                          data: qrdata!,
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () async {
                        final image = await screenshotController.capture();
                        if (image != null) {
                          final directory = await getTemporaryDirectory();
                          final imagePath = '${directory.path}/qr.png';
                          final file = File(imagePath);
                          await file.writeAsBytes(image);
                          await Share.shareXFiles([
                            XFile(imagePath),
                          ], text: 'Scan this QR code!');
                        }
                      },
                      icon: const Icon(Icons.share),
                      label: const Text('Share QR Code'),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
