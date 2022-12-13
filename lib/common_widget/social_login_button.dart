import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SocialLoginButton extends StatelessWidget {
  final String buttonText;
  final Color? textColor;
  final Color? buttonColor;
  final double? radius;
  final double? yukseklik;
  final Widget? buttonIcon;
  final void Function()? onPressed;

  const SocialLoginButton(
      {super.key,
      this.buttonColor,
      this.radius,
      required this.buttonText,
      this.textColor,
      this.yukseklik,
      this.buttonIcon,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: yukseklik,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(buttonColor),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius ?? 0)))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            buttonIcon ?? const SizedBox(),
            Text(
              textAlign: TextAlign.center,
              buttonText,
              style: TextStyle(color: textColor, fontSize: 40.sp),
            ),
            Opacity(opacity: 0, child: buttonIcon ?? const SizedBox()),
          ],
        ),
      ),
    );
  }
}
