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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kullanıcılar Sayfası"),
      ),
      body: FutureBuilder<List<UserModel>>(
        future: viewUserModelRead.getAllUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              // print(snapshot.data.toString());
              final userList = snapshot.data;
              userList?.removeWhere((element) => element.userId == viewUserModelRead.user?.userId);

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
                        subtitle: Text(userList?[index].email ?? "misafir"),
                      ));
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
