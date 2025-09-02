import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class QrRenderPage extends StatefulWidget {
  const QrRenderPage({super.key});

  @override
  State<QrRenderPage> createState() => _QrRenderPageState();
}

class _QrRenderPageState extends State<QrRenderPage> {
    void Function()? open_link(code)  {
  final uri = Uri.tryParse(code);
  if (uri != null && uri.hasAbsolutePath) {
    launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
  File? _image;
  Future<void> pickFromFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _image = File(result.files.single.path!);
      });
    }
  }
  TextEditingController textController=TextEditingController();
  double sizeLogo = 50;

  final List<Color> colors = [
    Colors.orange,
    Colors.indigo,
    Colors.pink,
    Colors.red,
    Colors.yellow,
    Colors.blue,
    Colors.grey,
    Colors.purple,
    Colors.green,
    Colors.black,
  ];

  double size = 200;
  QrEyeShape eyeShape = QrEyeShape.circle;
  QrDataModuleShape moduleShape = QrDataModuleShape.circle;
  Color eyeColor = Colors.black;
  Color moduleColor = Colors.black;

  int selectedEyeIndex = 9;
  int selectedModuleIndex = 9;

  ScreenshotController screenshotController = ScreenshotController();
  String? qrdata;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create QR Code"),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 100.0, left: 30, right: 30),
              child: TextField(
                controller: textController,
                decoration: InputDecoration(
                  hintText: 'Enter your URL',
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
                children: [
                  Padding(
                    padding: const EdgeInsets.all(40),
                    child: Screenshot(
                      controller: screenshotController,
                      child: Center(
                        child: GestureDetector(
                          onTap: () => open_link(textController.text),
                          child: QrImageView(
                            data: qrdata!,
                            size: size,
                            eyeStyle: QrEyeStyle(
                              eyeShape: eyeShape,
                              color: eyeColor,
                            ),
                            gapless: false,
                              errorCorrectionLevel: QrErrorCorrectLevel.H,
                            embeddedImage: _image != null
                                ? FileImage(_image!)
                                : null,
                          
                            embeddedImageStyle: QrEmbeddedImageStyle(
                              size: Size(sizeLogo,sizeLogo),
                            ),
                            dataModuleStyle: QrDataModuleStyle(
                              dataModuleShape: moduleShape,
                              color: moduleColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Text(
                          "Customization:",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: IconButton(
                          icon: Icon(Icons.add_a_photo, size: 25),
                          onPressed: pickFromFiles,
                        ),
                      ),
                    ],
                  ),
                  if (_image != null)
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 45,
                            right: 8,
                            left: 15,
                          ),
                          child: Text(
                            "Logo Size",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 19,
                            ),
                          ),
                        ),
                      ],
                    ),
                  if (_image != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Slider.adaptive(
                        value: sizeLogo,
                        min: 10,
                        max: 50,
                        divisions: 10,
                        label: sizeLogo.toStringAsFixed(1),
                        onChanged: (double value) {
                          setState(() {
                            sizeLogo = value;
                          });
                        },
                      ),
                    ),

                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 45,
                          right: 8,
                          left: 15,
                        ),
                        child: Text(
                          "Qrcode size:",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 19,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Slider.adaptive(
                      value: size,
                      min: 50,
                      max: 340,
                      label: size.round().toString(),
                      activeColor: Colors.lightBlueAccent,
                      inactiveColor: Colors.black,
                      onChanged: (double value) {
                        setState(() {
                          size = value;
                        });
                      },
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0, top: 10),
                        child: Text(
                          "Eyes:",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 19,
                          ),
                        ),
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 15.0, right: 8, left: 20),
                        child: Text("Colors:"),
                      ),
                    ],
                  ),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: List.generate(colors.length, (index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            eyeColor = colors[index];
                            selectedEyeIndex = index;
                          });
                        },
                        child: AnimatedScale(
                          scale: eyeColor == colors[index] ? 1.2 : 1.0,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOut,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                color: colors[index],
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: selectedEyeIndex == index
                                      ? Colors.black
                                      : Colors.grey,
                                  width: selectedEyeIndex == index ? 3 : 1,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 20.0,
                            bottom: 10,
                          ),
                          child: Text("Shape:"),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () =>
                            setState(() => eyeShape = QrEyeShape.square),
                        icon: const Icon(Icons.square_rounded),
                        label: const Text("Square"),
                      ),
                      ElevatedButton.icon(
                        onPressed: () =>
                            setState(() => eyeShape = QrEyeShape.circle),
                        icon: const Icon(Icons.circle_rounded),
                        label: const Text("Circle"),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0, top: 45),
                        child: Text(
                          "Modules:",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 19,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 10, right: 8, left: 20),
                        child: Text("Colors:"),
                      ),
                    ],
                  ),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: List.generate(colors.length, (index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            moduleColor = colors[index];
                            selectedModuleIndex = index;
                          });
                        },
                        child: AnimatedScale(
                          scale: moduleColor == colors[index] ? 1.2 : 1.0,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOut,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                color: colors[index],
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: selectedModuleIndex == index
                                      ? Colors.black
                                      : Colors.grey,
                                  width: selectedModuleIndex == index ? 3 : 1,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 20.0,
                            bottom: 10,
                          ),
                          child: Text("Shape:"),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => setState(
                          () => moduleShape = QrDataModuleShape.square,
                        ),
                        icon: const Icon(Icons.square_rounded),
                        label: const Text("Square"),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => setState(
                          () => moduleShape = QrDataModuleShape.circle,
                        ),
                        icon: const Icon(Icons.circle_rounded),
                        label: const Text("Circle"),
                      ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 40.0, bottom: 30),
                    child: ElevatedButton.icon(
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
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
