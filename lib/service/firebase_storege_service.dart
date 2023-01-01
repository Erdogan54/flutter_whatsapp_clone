import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_whatsapp_clone/constants/my_const.dart';
import 'package:flutter_whatsapp_clone/service/storage_base.dart';
import 'package:path_provider/path_provider.dart';

class FirebaseStorageService implements StorageBase {
  final _storageRef = FirebaseStorage.instance.ref();

  @override
  Future<String?> uploadFile({required String? userId, required String? fileType, required File? file}) async {
    if (userId != null && fileType != null && file != null) {
      final uploadTask = await _storageRef.child(userId).child(fileType).putFile(file);
      if (uploadTask.state == TaskState.success) {
        final url = await uploadTask.ref.getDownloadURL();
        MyConst.showSnackBar("profil foto güncellendi url:$url");
        return url;
      }

      return null;
    }
    MyConst.showSnackBar("profil foto null");
    return null;

    
  }
}
