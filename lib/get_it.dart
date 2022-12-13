import 'package:flutter_whatsapp_clone/repository/user_repository.dart';
import 'package:flutter_whatsapp_clone/service/fake_auth_service.dart';
import 'package:flutter_whatsapp_clone/service/firebase_auth_service.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

setup() {
  getIt.registerLazySingleton(() => FirebaseAuthService());
  getIt.registerLazySingleton(() => FakeAuthenticationService());
  getIt.registerLazySingleton(() => UserRepository());
}
