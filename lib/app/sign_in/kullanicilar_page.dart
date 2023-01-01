import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class KullanicilarPage extends StatelessWidget {
  const KullanicilarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kullanıcılar Sayfası"),
       
      ),
      body: const Center(child: Text("Kullanıcılar Page")),
    );
  }
}

