import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InitializePage extends StatelessWidget {
  final String? pageName;
  const InitializePage({Key? key, this.pageName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint("initialize page build");
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            const CircularProgressIndicator(),
            SizedBox(height: 50.h),
            Text("Veriler yükleniyor..\n${pageName ?? ""}"),
          ],
        ),
      ),
    );
  }
}
