import 'package:flutter/material.dart';
import 'package:qrme/pages/qr_render_page.dart';
import 'package:qrme/pages/scan_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ScanPage(),
      debugShowCheckedModeBanner: false,
      routes: {
        "/scanpage":(context)=>ScanPage(),
        "/qrrender":(context)=>QrRenderPage()
      },
    );
  }
}