import 'package:flutter_whatsapp_clone/service/notification/send_notification_service.dart';

import 'service/release/firebase_storege_service.dart';

import 'service/release/firestore_db_service.dart';

import 'repository/user_repository.dart';
import 'service/debug/fake_auth_service.dart';
import 'service/release/firebase_auth_service.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

getItSetup() {
  getIt.registerLazySingleton(() => FirebaseAuthService());
  getIt.registerLazySingleton(() => FakeAuthService());
  getIt.registerLazySingleton(() => UserRepository());
  getIt.registerLazySingleton(() => FireStoreDbService());
  getIt.registerLazySingleton(() => FirebaseStorageService());
  getIt.registerLazySingleton(() => SendingNotificationsService());
}
