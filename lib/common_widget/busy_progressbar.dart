import 'package:flutter/material.dart';

class BusyProgressBar extends StatelessWidget {
  final bool? isBusy;
  const BusyProgressBar({super.key, this.isBusy});

  @override
  Widget build(BuildContext context) {
    return (isBusy != false)
        ? Stack(
            children: [
              Container(
                height: double.maxFinite,
                width: double.maxFinite,
                color: Colors.black.withOpacity(0.6),
              ),
              const Center(child: CircularProgressIndicator()),
            ],
          )
        : const SizedBox();
  }
}
