import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/my_const.dart';
import '../../models/user_model.dart';
import '../../view_model/user_view_model.dart';
import 'initialize_page.dart';
import 'chat_page.dart';

class KullanicilarPage extends StatelessWidget {
  const KullanicilarPage({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint("kullanıcılar page build");
    final viewUserModelRead = context.read<UserViewModel>();
    final viewUserModelWatch = context.watch<UserViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kullanıcılar Sayfası"),
      ),
      body: FutureBuilder<List<UserModel>>(
        future: viewUserModelWatch.getAllUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              // print(snapshot.data.toString());
              final userList = snapshot.data;
              userList?.removeWhere((element) => element.userId == viewUserModelRead.user?.userId);

              StreamBuilder<String?> subtitleLastMessage(int index) {
                UserModel? fromUser = viewUserModelRead.user;
                UserModel? toUser = userList?[index];
                String? subtitle;

                return StreamBuilder<String?>(
                  stream: viewUserModelWatch.getLastMessage(fromUser?.userId, toUser?.userId),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      subtitle = snapshot.data ?? fromUser?.email;
                    }
                    return Text(subtitle ?? "");
                  },
                );
              }

              return ListView.builder(
                itemCount: userList?.length,
                itemBuilder: (context, index) => ListTile(
                  onTap: () => Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                    builder: (context) => ChatPage(
                      fromUser: viewUserModelRead.user,
                      toUser: userList?[index],
                    ),
                  )),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(userList?[index].photoUrl ?? MyConst.defaultProfilePhotoUrl),
                  ),
                  title: Text(userList?[index].userName ?? "null"),
                  subtitle: subtitleLastMessage(index),
                ),
              );
            }
            return SingleChildScrollView(
              child: Center(
                child: Text("${snapshot.error}"),
              ),
            );
          }
          return const InitializePage(
            pageName: "kullanıcılar page",
          );
        },
      ),
    );
  }
}
