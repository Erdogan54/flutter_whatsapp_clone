import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import '../../constants/my_const.dart';
import '../base/storage_base.dart';

class FirebaseStorageService implements StorageBase {
  final _storageRef = FirebaseStorage.instance.ref();

  @override
  Future<String?> uploadFile({required String? userId, required String? fileType, required File? file}) async {
    if (userId != null && fileType != null && file != null) {
      final uploadTask = await _storageRef.child(userId).child(fileType).putFile(file);
      if (uploadTask.state == TaskState.success) {
        final url = await uploadTask.ref.getDownloadURL();
       // MyConst.showSnackBar("profil foto güncellendi url:$url");
        return url;
      }

      return null;
    }
    MyConst.showSnackBar("profil foto null");
    return null;

    
  }
}
