import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class InitializePage extends StatelessWidget {
  const InitializePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children:  [
            const CircularProgressIndicator(),
            SizedBox(height: 50.h),
            const Text("Veriler yükleniyor."),
          ],
        ),
      ),
    );
  }
}
