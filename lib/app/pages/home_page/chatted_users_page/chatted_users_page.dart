import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_whatsapp_clone/admob/revarded_ad.dart';
import 'package:flutter_whatsapp_clone/view_model/all_user_view_model.dart';
import 'package:flutter_whatsapp_clone/view_model/chat_view_model.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../../../admob/banner_ad.dart';
import '../../initialize_page/initialize_page.dart';
import '../../../../models/chat_model.dart';
import '../../../../models/user_model.dart';
import 'package:provider/provider.dart';

import '../../../../constants/my_const.dart';
import '../../../../view_model/user_view_model.dart';
import '../chat_page/chat_page.dart';

class ChattedUserListPage extends StatefulWidget {
  const ChattedUserListPage({super.key});

  @override
  State<ChattedUserListPage> createState() => _ChattedUserListPageState();
}

class _ChattedUserListPageState extends State<ChattedUserListPage> {
  late UserViewModel _userViewModelRead;
  late AllUserViewModel _allUserViewModelRead;
  late UserViewModel _userViewModelWatch;

  @override
  void initState() {
    _userViewModelRead = context.read<UserViewModel>();
    _allUserViewModelRead = context.read<AllUserViewModel>();
    
    RewardedExampleState().loadAd();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _userViewModelWatch = context.watch<UserViewModel>();
    _userViewModelRead.getCurrentServerTime(_userViewModelRead.user?.userId);
    //_userViewModelWatch.showAd();
    var _bannerAd = BannerExampleState().loadAd();

    return Column(
      children: [
        Expanded(
          child: Scaffold(
            appBar: AppBar(
              title: const Text("Konusmalar Listesi"),
              actions: [
                IconButton(
                    onPressed: () {
                      RewardedExampleState().loadAd();
                    },
                    icon: const Icon(Icons.shop_two_rounded))
              ],
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
                      List<ChatModel> newModelList =
                          _userViewModelRead.chatModelDataUpdate(snapshot.data!, _allUserViewModelRead.allUser ?? []);
                      ChatModel chatModel = newModelList[index];

                      return ListTile(
                        onTap: () {
                          _navigateToChatPage(context, chatModel);
                        },
                        leading: CircleAvatar(
                          backgroundColor: Colors.white,
                          backgroundImage: NetworkImage(chatModel.toUserProfileURL ?? MyConst.defaultProfilePhotoUrl),
                        ),
                        title: Text(chatModel.toUserName ?? "null"),
                        subtitle: Row(
                          children: [
                            Text(chatModel.timeAgo ?? "null"),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
        if (_bannerAd != null)
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: SizedBox(
                width: _bannerAd!.size.width.toDouble(),
                height: _bannerAd!.size.height.toDouble(),
                child: AdWidget(ad: _bannerAd!),
              ),
            ),
          )
      ],
    );
  }

  void _navigateToChatPage(BuildContext context, ChatModel chatModel) {
    Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
      builder: (context) => ChatPage(
          fromUser: _userViewModelRead.user,
          toUser: UserModel.IdAndPhoto(userId: chatModel.toUserID, photoUrl: chatModel.toUserProfileURL)),
    ));
  }

  _onRefresh() async {
    await _userViewModelRead.getCurrentServerTime(_userViewModelRead.user?.userId);
    //await _userViewModelRead.getAllUsers();
    setState(() {});
    print("refresh yapıldı");
  }
}
