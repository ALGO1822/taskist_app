import 'package:flutter/material.dart';
import 'package:taskist_app/constants/app_theme.dart';

class AppLogo extends StatelessWidget {
  final double radius;
  final double iconSize;

  const AppLogo({
    super.key,
    this.radius = 45,
    this.iconSize = 50,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.primaryBlue.withValues(alpha: 0.1),
      child: Icon(
        Icons.task_alt,
        size: iconSize,
        color: AppColors.primaryBlue,
      ),
    );
  }
}
