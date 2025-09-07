import 'package:flutter/material.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:provider/provider.dart';
import 'package:qrme/settings/SettingsProvider.dart';
import 'package:qrme/theme/proviertheme.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 40, top: 40, bottom: 20),
                  child: Text(
                    "General",
                    style: TextStyle(
                      color: Colors.orange[900],
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 50.0),
                  child: Text(
                    "Theme",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: SizedBox(
                    height: 50,
                    width: 120,
                    child: Consumer<Themeprovider>(
                      builder: (context, themeProvider, _) {
                        return LiteRollingSwitch(
                          value: themeProvider.isDark,
                          onTap: () {},
                          onDoubleTap: () {},
                          onSwipe: () {},
                          onChanged: (newValue) {
                            themeProvider.toggeletheme();
                          },
                          colorOn: Colors.black,
                          colorOff: Colors.amber,
                          iconOn: Icons.nightlight,
                          iconOff: Icons.sunny,
                          textOn: "Dark",
                          textOff: "Light",
                          textOnColor: Colors.white,
                          textOffColor: Colors.black,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 40, bottom: 20, top: 25),
                  child: ElevatedButton.icon(
                    onPressed: () => _openLink("https://github.com/Touti-Sudo/QRme"),
                    icon: Image.asset(
                      "assets/github.png",
                      height: 30,
                      width: 30,
                    ),
                    label: const Text(
                      "Github Page",
                      style: TextStyle(color: Colors.black),
                    ),
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        Colors.lightBlue[300],
                      ),
                      shadowColor: const WidgetStatePropertyAll(Colors.redAccent),
                      overlayColor: const WidgetStatePropertyAll(Colors.white),
                      animationDuration: const Duration(milliseconds: 500),
                    ),
                  ),
                ),
              ],
            ),
            const Divider(),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 40, top: 40, bottom: 20),
                  child: Text(
                    "Scan Commands",
                    style: TextStyle(
                      color: Colors.orange[900],
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, bottom: 25),
                  child: Icon(Icons.pageview),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 20.0, bottom: 25),
                  child: Text(
                    "Open Urls automatically",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 15, bottom: 25),
                  child: Consumer<SettingsProvider>(
                    builder: (context, settings, _) {
                      return Switch(
                        value: settings.autoOpenUrls,
                        activeColor: Colors.green[900],
                        inactiveTrackColor: Colors.red[900],
                        thumbColor: const WidgetStatePropertyAll(Colors.white),
                        onChanged: (value) {
                          settings.toggleAutoOpenUrls(value);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Icon(Icons.save),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text(
                    "Automatically save created qr codes",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Consumer<SettingsProvider>(
                    builder: (context, settings, _) {
                      return Switch(
                        value: settings.autoSaveQRCodes,
                        activeColor: Colors.green[900],
                        inactiveTrackColor: Colors.red[900],
                        thumbColor: const WidgetStatePropertyAll(Colors.white),
                        onChanged: (value) {
                          settings.toggleAutoSaveQRCodes(value);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
