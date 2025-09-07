import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/qr_code_model.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<QrCodeModel>('qrcodes');

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("QR History"),
        backgroundColor: Colors.transparent,
      ),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<QrCodeModel> box, _) {
          if (box.isEmpty) {
            return const Center(child: Text("No QR codes yet"));
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final qr = box.getAt(index)!;

              return Dismissible(
                key: Key(qr.dateCreated.toIso8601String()),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (direction) {
                  box.deleteAt(index);

                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("QR Code deleted"),backgroundColor: Theme.of(context).colorScheme.primary,));
                },
                child: Card(
                  color: Theme.of(context).colorScheme.primary,
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: Image.file(
                      File(qr.imagePath),
                      width: 50,
                      height: 50,
                    ),
                    title: Text(
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.surface,
                      ),
                      qr.data,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      qr.dateCreated.toString().split(".").first,
                      style: const TextStyle(fontSize: 12),
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text(
                            "QR Preview"
                          ),
                          backgroundColor:  Theme.of(context).colorScheme.primary,
                          content: Image.file(File(qr.imagePath)),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
