import "package:curved_navigation_bar/curved_navigation_bar.dart";
import "package:flutter/material.dart";
import "package:qrme/pages/history_page.dart";
import "package:qrme/pages/qr_render_page.dart";
import "package:qrme/pages/scan_page.dart";
import "package:qrme/pages/settings_page.dart";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final pages = [ScanPage(),QrRenderPage(),HistoryPage(),SettingsPage()];
  dynamic index = 0;
  final List<Widget> items = [
    Icon(Icons.qr_code),
    Icon(Icons.create),
    Icon(Icons.history),
    Icon(Icons.settings),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        color: Theme.of(context).colorScheme.primary,
        items: items,
        index: index,
        onTap: (index) => setState(() => this.index = index),
      ),
      body: pages[index],
    );
  }
}
