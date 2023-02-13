import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_whatsapp_clone/app/pages/initialize_page.dart';
import 'package:flutter_whatsapp_clone/models/chat_model.dart';
import 'package:flutter_whatsapp_clone/models/user_model.dart';
import 'package:provider/provider.dart';

import '../../../../constants/my_const.dart';
import '../../../../view_model/user_view_model.dart';
import '../between_user_chat_page.dart/between_user_chat_page.dart';

class MyChatsPage extends StatefulWidget {
  const MyChatsPage({super.key});

  @override
  State<MyChatsPage> createState() => _MyChatsPageState();
}

class _MyChatsPageState extends State<MyChatsPage> {
  late UserViewModel _userViewModelRead;
  late UserViewModel _userViewModelWatch;

  @override
  void initState() {
    _userViewModelRead = context.read<UserViewModel>();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _userViewModelWatch = context.watch<UserViewModel>();
    _userViewModelRead.getCurrentServerTime(_userViewModelRead.user?.userId);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Konusmalar Listesi"),
      ),
      body: StreamBuilder<List<ChatModel>>(
        stream: _userViewModelWatch.getAllConversations(fromUserId: _userViewModelRead.user?.userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const InitializePage();
          }
          if (snapshot.data?.isEmpty ?? true) {
            final height = MediaQuery.of(context).size.height;
            return RefreshIndicator(
              onRefresh: () => _onRefresh(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Center(
                  child: SizedBox(
                    height: height - (height / 5),
                    //width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat,
                          color: Theme.of(context).primaryColor,
                          size: 100,
                        ),
                        const Text(
                          "Henüz bir konusma yok",
                          style: TextStyle(fontSize: 30),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => _onRefresh(),
            child: ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                List<ChatModel> newModelList = _userViewModelRead.chatModelDataUpdate(snapshot.data!);
                ChatModel chatModel = newModelList[index];

                return ListTile(
                  onTap: () => Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                    builder: (context) => ChatPage(
                      fromUser: _userViewModelRead.user,
                      toUser: UserModel.IdAndPhoto(userId: chatModel.toUserID, photoUrl: chatModel.toUserProfileURL),
                    ),
                  )),
                  leading: CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage(chatModel.toUserProfileURL ?? MyConst.defaultProfilePhotoUrl),
                  ),
                  title: Text(chatModel.toUserName ?? "null"),
                  subtitle: Text(_userViewModelWatch.currentServerTime != null ? (chatModel.timeAgo ?? "") : ""),
                );
              },
            ),
          );
        },
      ),
    );
  }

  // ChatModel? _findUser(ChatModel? toUser) {
  //   final allUser = _viewModelWatch.userRepo.allUser;

  //   for (var e in allUser) {
  //     if (e.userId == toUser?.toUserID) {
  //       toUser?.toUserName = e.userName;
  //       toUser?.toUserProfileURL = e.photoUrl;
  //       toUser?.timeAgo = _userViewModelRead.getTimeAgo(toUser.createdDate);
  //     }
  //   }
  //   return toUser;
  // }

  _onRefresh() async {
    await _userViewModelRead.getCurrentServerTime(_userViewModelRead.user?.userId);
    await _userViewModelRead.getAllUsers();
    setState(() {});
    print("refresh yapıldı");
  }
}
