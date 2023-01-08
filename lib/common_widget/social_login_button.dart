import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

@immutable
// ignore: must_be_immutable
class SocialLoginButton extends StatelessWidget {
  final String buttonText;
  final Color? textColor;
  final Color? buttonColor;
  double? radius;
  double? buttonHeight;
  final Widget? buttonIcon;
  double? titleSize;
  double? iconSize;
  final void Function()? onPressed;

  SocialLoginButton({
    super.key,
    this.buttonColor,
    this.radius,
    required this.buttonText,
    this.textColor,
    this.buttonHeight,
    this.buttonIcon,
    required this.onPressed,
    this.titleSize,
  });

  @override
  Widget build(BuildContext context) {
    buttonHeight ??= 100.sp;
    titleSize ??= 50.sp;
    radius ??= 40.r;
    iconSize ??= 60.sp;

    return SizedBox(
      height: buttonHeight,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(buttonColor),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius ?? 0)))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(height: iconSize, child: buttonIcon ?? const SizedBox()),
            Text(
              textAlign: TextAlign.center,
              buttonText,
              style: TextStyle(color: textColor, fontSize: titleSize),
            ),
            Opacity(
                opacity: 0,
                child: SizedBox(
                  height: buttonIcon == null ? null : iconSize,
                )),
          ],
        ),
      ),
    );
  }
}
