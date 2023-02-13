import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../constants/my_const.dart';
import '../../../../models/user_model.dart';
import '../../../../view_model/user_view_model.dart';
import '../between_user_chat_page.dart/between_user_chat_page.dart';
import '../../initialize_page.dart';

class KullanicilarPage extends StatefulWidget {
  const KullanicilarPage({super.key});

  @override
  State<KullanicilarPage> createState() => _KullanicilarPageState();
}

class _KullanicilarPageState extends State<KullanicilarPage> {
  @override
  Widget build(BuildContext context) {
    debugPrint("kullanıcılar page build");
    final userViewModelRead = context.read<UserViewModel>();
    final userViewModelWatch = context.watch<UserViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kullanıcılar Sayfası"),
      ),
      body: RefreshIndicator(
        onRefresh: () => _refresh(),
        child: FutureBuilder<List<UserModel>>(
          future: userViewModelWatch.getAllUsers(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const InitializePage();
            }
            if (snapshot.connectionState == ConnectionState.done) {
              if (!snapshot.hasData) {
                return SingleChildScrollView(
                  child: Center(
                    child: Text("${snapshot.error}"),
                  ),
                );
              }
              final userList = snapshot.data;
              if (userList?.isNotEmpty ?? false) {
                return ListView.builder(
                  itemCount: userList?.length,
                  itemBuilder: (context, index) => ListTile(
                    onTap: () => Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                      builder: (context) => ChatPage(
                        fromUser: userViewModelRead.user,
                        toUser: userList?[index],
                      ),
                    )),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(userList?[index].photoUrl ?? MyConst.defaultProfilePhotoUrl),
                    ),
                    title: Text(userList?[index].userName ?? "username null"),
                    // title: Text("userName: ${userList?[index].userName}/\nuserId: ${userList?[index].userId}"),
                  ),
                );
              } else {
                final height = MediaQuery.of(context).size.height;
                return SingleChildScrollView(
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
                );
              }
            }

            return SingleChildScrollView(
              child: Center(
                child: Text("${snapshot.error}"),
              ),
            );
          },
        ),
      ),
    );
  }

  _refresh() async {
    print("refresh");
    setState(() {});
  }
}
