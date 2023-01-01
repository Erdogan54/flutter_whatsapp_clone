import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_whatsapp_clone/common_widget/busy_progressbar.dart';
import 'package:flutter_whatsapp_clone/common_widget/platform_duyarli_alert_dialog.dart';
import 'package:flutter_whatsapp_clone/common_widget/social_login_button.dart';
import 'package:flutter_whatsapp_clone/main.dart';
import 'package:provider/provider.dart';

import '../../view_model/user_view_model.dart';

final controllerUserNameKey = GlobalKey<FormFieldState>();

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  late TextEditingController _controllerUserName;
  late UserViewModel _viewModelRead;
  late UserViewModel _viewModelWatch;

  @override
  void initState() {
    _viewModelRead = context.read<UserViewModel>();

    _controllerUserName = TextEditingController();
    _controllerUserName.text = _viewModelRead.user?.userName ?? "";
    super.initState();
  }

  @override
  void dispose() {
    _controllerUserName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _viewModelWatch = context.watch<UserViewModel>();
    return Stack(
      children: [
        _buildScaffold(context),
        BusyProgressBar(isBusy: _viewModelWatch.isUpdateUserInfo),
      ],
    );
  }

  Scaffold _buildScaffold(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil Sayfası"),
        actions: [_signOutButton(context)],
      ),
      body: _buildBody(context),
    );
  }

  SingleChildScrollView _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return SizedBox(
                        height: 200,
                        child: Column(
                          children: [
                            ListTile(
                              leading: const Icon(Icons.camera),
                              title: const Text("Kameradan Çek"),
                              onTap: () {
                                _viewModelRead.kameradanFotoCek();
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                                leading: const Icon(Icons.image),
                                title: const Text("Galeriden Seç"),
                                onTap: () {
                                  _viewModelRead.galeridenFotoSec();
                                  Navigator.pop(context);
                                })
                          ],
                        ),
                      );
                    },
                  );
                },
                child: _buildAvatarPhoto(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                initialValue: _viewModelRead.user?.email,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "Email",
                  hintText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _controllerUserName,
                key: controllerUserNameKey,
                decoration: const InputDecoration(
                  labelText: "Kullanıcı Adı",
                  hintText: "Kullanıcı Adı",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SocialLoginButton(
                buttonText: "Değişiklikleri Kaydet",
                onPressed: () {
                  _viewModelRead.updateUserName(context, newUserName: _controllerUserName.text, userId: _viewModelRead.user?.userId);
                  _viewModelRead.updateProfilPhoto();
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarPhoto() {
    return FutureBuilder(
      future: _viewModelWatch.resultPicker?.readAsBytes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          return Stack(
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: profilPhoto(),
                radius: 75,
              ),
              CircleAvatar(
                backgroundColor: Colors.black.withOpacity(0.5),
                child: const CircularProgressIndicator(),
              )
            ],
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return CircleAvatar(
              backgroundColor: Colors.white,
              radius: 75,
              backgroundImage: MemoryImage(snapshot.data as Uint8List),
            );
          }
        }

        return CircleAvatar(
          backgroundColor: Colors.white,
          backgroundImage: profilPhoto(),
          radius: 75,
        );
      },
    );
  }

  NetworkImage profilPhoto() {
    return NetworkImage(_viewModelRead.user?.photoUrl ?? "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__480.png");
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
      _viewModelRead.setUser(null);
    }
  }

  Future<bool> _signOut(context) async {
    return await _viewModelRead.signOut();
  }
}
