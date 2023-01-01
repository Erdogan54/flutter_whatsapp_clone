import 'package:flutter_whatsapp_clone/service/firebase_storege_service.dart';

import 'service/firestore_db_service.dart';

import 'repository/user_repository.dart';
import 'service/fake_auth_service.dart';
import 'service/firebase_auth_service.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

getItSetup() {
  getIt.registerLazySingleton(() => FirebaseAuthService());
  getIt.registerLazySingleton(() => FakeAuthService());
  getIt.registerLazySingleton(() => UserRepository());
  getIt.registerLazySingleton(() => FireStoreDbService());
  getIt.registerLazySingleton(() => FirebaseStorageService());
}
