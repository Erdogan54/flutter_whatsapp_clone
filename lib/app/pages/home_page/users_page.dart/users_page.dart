import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_whatsapp_clone/constants/my_const.dart';
import 'package:flutter_whatsapp_clone/extensions/context_extension.dart';
import 'package:flutter_whatsapp_clone/view_model/all_user_view_model.dart';
import 'package:flutter_whatsapp_clone/view_model/chat_view_model.dart';
import 'package:flutter_whatsapp_clone/view_model/user_view_model.dart';
import 'package:provider/provider.dart';
import '../../../../models/user_model.dart';
import '../chat_page/chat_page.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final ScrollController _scrollController = ScrollController();
  final _scrollPhysics = ClampingScrollPhysics();
  late UserViewModel _userViewModelRead;
  late AllUserViewModel _allUserViewModelRead;
  late AllUserViewModel _allUserViewModelWatch;

  @override
  void initState() {
    _userViewModelRead = context.read<UserViewModel>();
    _allUserViewModelRead = context.read<AllUserViewModel>();
    // getMoreUser();
    // print("init state");

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _allUserViewModelRead.getAllUsers();

    });

    _scrollController.addListener(() {
      _scrollPosition();
    });

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollPosition() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      _allUserViewModelRead.getMoreUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    // print("page build");
    _allUserViewModelWatch = context.watch<AllUserViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: Text("Users - ${_allUserViewModelRead.allUser?.length}"),
        actions: [
          // IconButton(
          //     onPressed: () {
          //       _allUserViewModelRead.getMoreUser();
          //     },
          //     icon: const Icon(Icons.skip_next)),
        ],
      ),
      body: Consumer<AllUserViewModel>(
        builder: (context, value, child) {
          if (value.state == AllUserViewState.Busy) {
            if (value.isFirstRequest == true) {
              return Stack(
                children: [
                  Opacity(opacity: 0.5, child: _buildUserList(value)),
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
                ],
              );
            }
            return _buildUserList(value);
          }

          if (value.state == AllUserViewState.Loaded) {
            if (value.allUser?.isEmpty ?? true) {
              return _buildEmptyUserList();
            }
            return _buildUserList(value);
          }
          return const Center(
            child: Text("bir hata oluştu"),
          );
        },
      ),
    );
  }

  Widget _buildUserList(AllUserViewModel value) {
    return RefreshIndicator(
      onRefresh: () => _onRefresh(),
      child: ListView.builder(
        physics: _scrollPhysics,
        controller: _scrollController,
        itemCount: (value.allUser?.length ?? 0) + 1,
        itemBuilder: (context, index) {
          value.allUser?.length ?? const SizedBox();
          if (index == value.allUser?.length) {
            if (value.state == AllUserViewState.Busy && index == 0) {
              return SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: const Center(child: CircularProgressIndicator()),
              );
            }
            if (value.state == AllUserViewState.Busy) {
              return SizedBox(
                height: MediaQuery.of(context).size.height / 20,
                width: MediaQuery.of(context).size.height / 20,
                child: const Center(child: CircularProgressIndicator()),
              );
            } else {
              return const SizedBox.shrink();
            }
          } else {
            return _buildUserListItem(index);
          }
        },
      ),
    );
  }

  Widget _buildUserListItem(int index) {
    var toUser = _allUserViewModelRead.allUser![index];

    if (toUser.userId == _userViewModelRead.user?.userId) {
      return const SizedBox.shrink();
    }

    return Card(
      child: ListTile(
          onTap: () {
            Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
              builder: (context) => ChatPage(fromUser: _userViewModelRead.user, toUser: toUser),
            ));
          },
          title: Text(toUser.userName ?? ""),
          subtitle: toUser.email == null ? null : Text(toUser.email!),
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor.withAlpha(40),
            foregroundImage: NetworkImage(toUser.photoUrl ?? MyConst.defaultProfilePhotoUrl),
          )),
    );
  }

  Widget _buildEmptyUserList() {
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
                  Icons.supervised_user_circle,
                  color: Theme.of(context).primaryColor,
                  size: 100,
                ),
                const Text(
                  "Kayıtlı bir kullanıcı yok",
                  style: TextStyle(fontSize: 30),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    // print("refresh");
    _allUserViewModelRead.getAllUsers();
  }
}
