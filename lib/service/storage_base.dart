import 'dart:io';

import 'package:flutter_whatsapp_clone/models/user_model.dart';

abstract class StorageBase {
  Future<String?> uploadFile({required String? userId, required String? fileType,required File? file});
}
