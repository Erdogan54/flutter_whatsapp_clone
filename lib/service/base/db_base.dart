import '../../models/chat_model.dart';

import '../../models/message_model.dart';
import '../../models/user_model.dart';

abstract class DBBase {
  Future<bool> saveUser({required UserModel user});
  Future<UserModel?>? readUser(String userId);
  Future<bool> updateUserName({required String? userId, required String newUserName});
  Future<bool> updateProfilePhoto({required String? userId, required String? photoUrl});
  Future<List<UserModel>> getUsersWithPagination(UserModel lastUser, int userCount);
  // Future<List<UserModel>> getAllUsers(); //conversations
  Stream<List<ChatModel>> getAllConversations(String fromUserId);
  Stream<List<MessageModel>> getMessages(String fromUserId, String toUserId);
  Future<bool> sendAndSaveMessage(MessageModel willBeSavedMessage);
  Future<DateTime?> getServerDateTime(String? fromUserId);
}
