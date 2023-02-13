import 'package:flutter_whatsapp_clone/models/chat_model.dart';

import '../../models/message_model.dart';
import '../../models/user_model.dart';

abstract class DBBase {
  Future<bool> saveUser({required UserModel user});
  Future<UserModel?>? readUser(String userId);
  Future<bool> updateUserName({required String? userId, required String newUserName});
  Future<bool> updateProfilePhoto({required String? userId, required String? photoUrl});
  Future<List<UserModel>> getAllUsers(); //conversations
  Stream<List<ChatModel>> getAllConversations(String fromUserId);
  Stream<List<MessageModel>> getMessages(String fromUserId, String toUserId);
  Future<bool> saveMessage(MessageModel willBeSavedMessage);
  Future<DateTime?> getServerDateTime(String? fromUserId);
}
