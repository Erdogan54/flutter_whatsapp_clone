import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_whatsapp_clone/constants/my_const.dart';
import 'package:flutter_whatsapp_clone/models/message_model.dart';

import '../get_it.dart';
import '../models/user_model.dart';
import '../repository/user_repository.dart';

enum ChatViewState { Idle, Loaded, Busy }

class ChatViewModel with ChangeNotifier {
  UserModel? fromUser;
  UserModel? toUser;
  List<MessageModel> _allMessages = [];
  ChatViewState _state = ChatViewState.Idle;
  int reqMessageCount = 6;
  final _userRepo = getIt<UserRepository>();
  MessageModel? _paginationEndMessage;
  MessageModel? _firstMessage;
  bool? _hasMore;
  bool newMessageListener = false;

  int sendMessageCount = 0;


  ChatViewModel({this.fromUser, this.toUser}) {
    // print("chatviewModel tetiklendi");
    // _hasMore = true;
    // getMessages();
   
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  MessageModel? get lastMessage => _paginationEndMessage;

  List<MessageModel>? get allMessages => _allMessages;

  ChatViewState get state => _state;

 

 

  set state(ChatViewState value) {
    _state = value;
    print("notifyListeners");
    notifyListeners();
  }

  Future<List<MessageModel>?> getAllMessagesWithPagination() async {
    if (state == ChatViewState.Busy) return null;
    state = ChatViewState.Busy;
    print("getMessageWithPagination run");
    // print("fromUser?.userId: ${fromUser?.userId}");
    // print("toUser?.userId: ${toUser?.userId}");
    // print("request message count: $reqMessageCount");
    // print("lastMessages: ${_paginationEndMessage?.message}");

    List<MessageModel>? resMessagesList = await _userRepo.getMessagesWithPagination(
        fromUser?.userId, toUser?.userId, reqMessageCount, _paginationEndMessage);

    _hasMore = !(resMessagesList.length < reqMessageCount);
    // print("result MessagesList.lenght ${resMessagesList.length}");
    // print("_hasMore: $_hasMore");

    _allMessages.addAll(resMessagesList);

    _paginationEndMessage = resMessagesList.isNotEmpty ? resMessagesList.last : _paginationEndMessage;
    _firstMessage = resMessagesList.isNotEmpty ? resMessagesList.first : _firstMessage;

    print("last message: ${_paginationEndMessage?.message}");
    print("first message: ${_firstMessage?.message}");

    state = ChatViewState.Loaded;
    if (newMessageListener == false) {
      newMessageListener = true;
      newMessageListenerCreate();
    }

    return resMessagesList;
  }

  Future<bool> sendMessage(MessageModel sendMessageModel) async {
    // sendMessageModel.date = (FieldValue.serverTimestamp() as Timestamp).toDate();
    
    print(sendMessageModel);
    _allMessages.insert(0, sendMessageModel);
    notifyListeners();

    return await _userRepo.sendMessage(sendMessageModel,fromUser);
  }

  Future<List<MessageModel>?> getMessages() async {
    print("getMessages() - chatViewModel");
    if (state == ChatViewState.Busy) {
      print("state == ChatViewState.Busy olduğundan getMessages çalıştırılmadı..");
      return null;
    }

    if (_hasMore == true) {
      print("_hasMore == true - chatViewModel");
      // print("last message: $_lastMessages");
      return await getAllMessagesWithPagination();
    } else if (_hasMore == false) {
      // reqMessageCount = 0;
      //  MyConst.showSnackBar("getirelecek daha fazla mesaj bulunamadı", 1);
      print("_hasMore == false - chatViewModel");
    } else if (_hasMore == null) {
      print("hasMore null");
    }
    return null;
  }

  Future<void> onRefresh() async {
    getMessagesFirstrequest();
  }

  void getMessagesFirstrequest() {
    _hasMore = true;
    _paginationEndMessage = null;
    reqMessageCount = 15;
    _allMessages = [];
    getMessages();
  }

  void newMessageListenerCreate() {
    // print("listener atandı");
    _userRepo.getMessages(fromUser?.userId, toUser?.userId).listen(
      (messageModelList) {
        // print("listener tetiklendi son getrilen mesaj: ${messageModelList[0]}");

        if (messageModelList[0].date != null) {
          if (messageModelList[0].fromUserID == toUser?.userId) {
            // mesaj karşıdan gelmişse ekle yoksa her mesaj gönderildiğinde otomatik olarak ekleniyor
            _allMessages.insert(0, messageModelList[0]);
            notifyListeners();
          }
        }
      },
      onDone: () {
        print("dinleme sona erdi");
      },
      onError: (Object object, StackTrace stackTrace) {
        print("dinlemede bir hata oluştu");
      },
    );
  }
}
