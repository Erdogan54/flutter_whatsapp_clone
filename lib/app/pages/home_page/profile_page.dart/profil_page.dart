import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../../common_widget/busy_progressbar.dart';
import '../../../../common_widget/platform_duyarli_alert_dialog.dart';
import '../../../../common_widget/social_login_button.dart';

import 'package:provider/provider.dart';

import '../../../../constants/my_const.dart';
import '../../../../view_model/user_view_model.dart';

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
    debugPrint("profil page build");
    _viewModelWatch = context.watch<UserViewModel>();
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text("Profil Sayfası"),
            actions: [_signOutButton(context)],
          ),
          body: _buildBody(context),
        ),
        BusyProgressBar(isBusy: _viewModelWatch.isUpdateUserInfo),
      ],
    );
  }

  SingleChildScrollView _buildBody(BuildContext context) {
    var buildProfilePhoto = Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          _updatePhoto(context);
        },
        child: CircleAvatar(
          backgroundColor: Colors.white,
          backgroundImage: NetworkImage(_viewModelWatch.user?.photoUrl ?? MyConst.defaultProfilePhotoUrl),
          radius: 75,
        ),
      ),
    );

    var buildEmailArea = Padding(
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
    );
    var buildUserNameArea = Padding(
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
    );
    var buildSaveButton = Padding(
      padding: const EdgeInsets.all(8.0),
      child: SocialLoginButton(
        buttonText: "Değişiklikleri Kaydet",
        onPressed: () {
          _viewModelRead.updateUserName(context,
              newUserName: _controllerUserName.text, userId: _viewModelRead.user?.userId);
          _viewModelRead.updateProfilPhoto();
        },
      ),
    );

    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            buildProfilePhoto,
            buildEmailArea,
            buildUserNameArea,
            buildSaveButton,
          ],
        ),
      ),
    );
  }

  Future<dynamic> _updatePhoto(BuildContext context) {
    return showModalBottomSheet(
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
  }

  Widget _buildAvatarPhoto() {
    print(_viewModelWatch.user?.photoUrl ?? MyConst.defaultProfilePhotoUrl);
    return CircleAvatar(
      backgroundColor: Colors.white,
      backgroundImage: NetworkImage(_viewModelWatch.user?.photoUrl ?? MyConst.defaultProfilePhotoUrl),
      radius: 75,
    );
    // return FutureBuilder(
    //   future: _viewModelWatch.resultPicker?.readAsBytes(),
    //   builder: (context, snapshot) {
    //     print("connection state: ${ConnectionState.values}");
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       return Stack(
    //         children: [
    //           buildProfilePhoto,
    //           CircleAvatar(
    //             backgroundColor: Colors.black.withOpacity(0.5),
    //             child: const CircularProgressIndicator(),
    //           )
    //         ],
    //       );
    //     }
    //     if (snapshot.connectionState == ConnectionState.done) {
    //       if (snapshot.hasData) {
    //         return buildProfilePhoto;
    //       }
    //     }

    //     return buildProfilePhoto;
    //   },
    // );
  }

  IconButton _signOutButton(BuildContext context) {
    return IconButton(
      onPressed: () => _signOutDialog(context),
      icon: const Icon(Icons.exit_to_app),
    );
  }

  void _signOutDialog(BuildContext context) async {
    final result = await const PlatformDuyarliAlertDialog(
      title: "Warning",
      contents: "Do you really want to go out?",
      positiveActionLabel: "Ok",
      negativeActionLabel: "Cancel",
    ).show(context);
    if (result == true) {
      _signOut();
      _viewModelRead.setUser(null);
    }
  }

  Future<bool> _signOut() async {
    return await _viewModelRead.signOut();
  }
}
