import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmailSifreKayitLogin extends StatefulWidget {
  const EmailSifreKayitLogin({Key? key}) : super(key: key);

  @override
  State<EmailSifreKayitLogin> createState() => _EmailSifreKayitLoginState();
}

class _EmailSifreKayitLoginState extends State<EmailSifreKayitLogin> {
  
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  final Key _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Giriş/Kayıt"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.r)),
                    labelText: "Email",
                    hintText: "Enter email",
                    prefixIcon: const Icon(Icons.email)),
                onSaved: (value) {
                  value != null ? _emailController.text = value : null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.r)),
                    labelText: "Password",
                    hintText: "Enter password",
                    prefixIcon: const Icon(Icons.password_sharp)),
                onSaved: (value) {
                  value != null ? _passwordController.text = value : null;
                },
              ),
            ),
            TextButton(onPressed: () {
           
            }, child: const Text("Giriş Yap"))
          ],
        ),
      ),
    );
  }
}
