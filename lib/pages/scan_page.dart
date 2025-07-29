import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  void Function()? open_link(code)  {
  final uri = Uri.tryParse(code);
  if (uri != null && uri.hasAbsolutePath) {
    launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

  DateTime? _lastScan;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Scan QR Code"),
        backgroundColor: Colors.white,
        actions: [
          GestureDetector(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.qr_code_2_sharp),
            ),
            onTap: () {Navigator.pushReplacementNamed(context,'/qrrender');},
          ),
        ],
      ),
      body: MobileScanner(
        controller: MobileScannerController(
          detectionSpeed: DetectionSpeed.normal,
        ),
        onDetect: (capture) {
          final now = DateTime.now();
          if (_lastScan == null ||
              now.difference(_lastScan!) > Duration(seconds: 5)) {
            _lastScan = now;
            List<Barcode> barcodes = capture.barcodes;
            for (final barcode in barcodes) {
              final String? code = barcode.rawValue;
              print(code);
              if (code != null) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("QR Code detected"),
                      content: GestureDetector(onTap:() =>  open_link(code), child: Text(code)),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Close"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            final value = ClipboardData(text: code);
                            Clipboard.setData(value);
                          },
                          child: const Text("Copie"),
                        ),
                      ],
                    );
                  },
                );
              }
            }
          }
        },
      ),
    );
  }
}
