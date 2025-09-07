import 'package:hive/hive.dart';

part 'qr_code_model.g.dart';

@HiveType(typeId: 0)
class QrCodeModel extends HiveObject {
  @HiveField(0)
  String data;

  @HiveField(1)
  String imagePath; // path to saved QR image

  @HiveField(2)
  DateTime dateCreated;

  QrCodeModel({
    required this.data,
    required this.imagePath,
    required this.dateCreated,
  });
}
