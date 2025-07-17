import 'package:flutter/material.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';

class AnimationSnackbarComponent {
  static void showSuccess(BuildContext context, String title, String message) {
    AnimatedSnackBar.rectangle(
      title,
      message,
      type: AnimatedSnackBarType.success,
      brightness: Brightness.light,
      duration: const Duration(seconds: 3),
    ).show(context);
  }

  static void showError(BuildContext context, String title, String message) {
    AnimatedSnackBar.rectangle(
      title,
      message,
      type: AnimatedSnackBarType.error,
      brightness: Brightness.light,
      duration: const Duration(seconds: 3),
    ).show(context);
  }

  static void showInfo(BuildContext context, String title, String message) {
    AnimatedSnackBar.rectangle(
      title,
      message,
      type: AnimatedSnackBarType.info,
      brightness: Brightness.light,
      duration: const Duration(seconds: 3),
    ).show(context);
  }

  static void showWarning(BuildContext context, String title, String message) {
    AnimatedSnackBar.rectangle(
      title,
      message,
      type: AnimatedSnackBarType.warning,
      brightness: Brightness.light,
      duration: const Duration(seconds: 3),
    ).show(context);
  }
}
