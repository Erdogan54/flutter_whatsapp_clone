import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InitializePage extends StatelessWidget {
  final String? locatePage;
  const InitializePage({Key? key, this.locatePage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            const CircularProgressIndicator(),
            SizedBox(height: 50.h),
            Text("Veriler yükleniyor..\n$locatePage"),
          ],
        ),
      ),
    );
  }
}
