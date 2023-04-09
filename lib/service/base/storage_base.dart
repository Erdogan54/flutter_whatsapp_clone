import 'dart:io';


abstract class StorageBase {
  Future<String?> uploadFile({required String? userId, required String? fileType,required File? file});
}
