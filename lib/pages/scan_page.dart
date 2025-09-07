import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qrme/settings/SettingsProvider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  late MobileScannerController _controller;
  bool torchOn = false;
  DateTime? _lastScan;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(detectionSpeed: DetectionSpeed.normal);
  }

  Future<void> _openLink(String code) async {
    final uri = Uri.tryParse(code);
    if (uri != null && (uri.scheme == 'http' || uri.scheme == 'https')) {
      try {
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Cannot open link')),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error opening link: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Scan QR Code"),
        backgroundColor: Colors.transparent,
        actions: [
          GestureDetector(
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.qr_code_2_sharp),
            ),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/qrrender');
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: (capture) async {
              final now = DateTime.now();
              if (_lastScan == null || now.difference(_lastScan!) > const Duration(seconds: 5)) {
                _lastScan = now;
                final settings = Provider.of<SettingsProvider>(context, listen: false);
                final barcodes = capture.barcodes;
                for (final barcode in barcodes) {
                  final code = barcode.rawValue;
                  if (code == null) continue;

                  if (settings.autoOpenUrls) {
                    await _openLink(code);
                    return;
                  }

                  if (!mounted) return;
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("QR Code detected"),
                        content: GestureDetector(
                          onTap: () async {
                            Navigator.of(context).pop();
                            await _openLink(code);
                          },
                          child: Text(code),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Close"),
                          ),
                          TextButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              await Clipboard.setData(ClipboardData(text: code));
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Copied to clipboard")),
                                );
                              }
                            },
                            child: const Text("Copy"),
                          ),
                          TextButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              await _openLink(code);
                            },
                            child: const Text("Open"),
                          ),
                        ],
                      );
                    },
                  );
                  return;
                }
              }
            },
          ),
          IgnorePointer(child: CustomPaint(size: Size.infinite, painter: ScannerOverlay())),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: FloatingActionButton(
                backgroundColor: Colors.white,
                child: Icon(
                  torchOn ? Icons.flash_on : Icons.flash_off,
                  color: torchOn ? Colors.yellow[800] : Colors.black,
                ),
                onPressed: () async {
                  await _controller.toggleTorch();
                  setState(() {
                    torchOn = !torchOn;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ScannerOverlay extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withOpacity(0.6);
    final overlay = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    const double boxSize = 250;
    final left = (size.width - boxSize) / 2;
    final top = (size.height - boxSize) / 2;
    final cutout = Path()..addRRect(RRect.fromRectAndRadius(Rect.fromLTWH(left, top, boxSize, boxSize), const Radius.circular(20)));
    final path = Path.combine(PathOperation.difference, overlay, cutout);
    canvas.drawPath(path, paint);
    final border = Paint()
      ..color = Colors.lightGreenAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(left, top, boxSize, boxSize), const Radius.circular(20)), border);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
