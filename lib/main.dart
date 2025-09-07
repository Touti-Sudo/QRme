import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:qrme/pages/home_page.dart';
import 'package:qrme/pages/scan_page.dart';
import 'package:qrme/settings/SettingsProvider.dart';
import 'package:qrme/theme/proviertheme.dart';
import 'models/qr_code_model.dart';
import 'pages/qr_render_page.dart';
import 'pages/history_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(QrCodeModelAdapter());
  await Hive.openBox<QrCodeModel>('qrcodes');
  await Hive.openBox('settings');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Themeprovider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: const MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,
            theme: Provider.of<Themeprovider>(context).themeData,
      routes: {
        "/scanpage": (context) => ScanPage(),
        "/qrrender": (context) => QrRenderPage(),
        "/homepage": (context) => HomePage(),
        '/history': (_) => const HistoryPage(),
      },
    );
  }
}
