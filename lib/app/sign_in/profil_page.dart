import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_whatsapp_clone/common_widget/platform_duyarli_alert_dialog.dart';
import 'package:flutter_whatsapp_clone/constants/my_const.dart';
import 'package:provider/provider.dart';

import '../../view_model/user_view_model.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  late TextEditingController _controUserName;

  @override
  void initState() {
    _controUserName = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserViewModel _viewModel = context.read<UserViewModel>();
    print("user info: ${_viewModel.user}");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil Sayfası"),
        actions: [_signOutButton(context)],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: profilPhoto(_viewModel),
                  radius: 75,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: _viewModel.user?.email,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "Email",
                    hintText: "Email",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: _viewModel.user?.userName,
                  decoration: InputDecoration(
                    labelText: "Kullanıcı Adı",
                    hintText: "Kullanıcı Adı",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  NetworkImage profilPhoto(UserViewModel _viewModel) {
    return NetworkImage(_viewModel.user?.photoUrl ?? "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__480.png");
  }

  IconButton _signOutButton(BuildContext context) {
    return IconButton(
      onPressed: () => _signOutDialog(context),
      icon: const Icon(Icons.exit_to_app),
    );
  }

  void _signOutDialog(BuildContext context) async {
    final result = await PlatformDuyarliAlertDialog(
      title: "Warning",
      contents: "Do you really want to go out?",
      positiveActionLabel: "Ok",
      negativeActionLabel: "Cancel",
    ).show(context);
    if (result == true) {
      _signOut(context);
    }
  }

  Future<bool> _signOut(context) async {
    UserViewModel userVm = Provider.of<UserViewModel>(context, listen: false);
    return await userVm.signOut();
  }
}
