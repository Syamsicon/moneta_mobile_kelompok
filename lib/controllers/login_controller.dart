import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moneta/routes/app_routes.dart';

class LoginController extends GetxController {
  final nameController = TextEditingController();
  final passwordController = TextEditingController();

  void login() {
    final name = nameController.text.trim();
    final password = passwordController.text.trim();

    if (name.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Please fill in all fields');
      return;
    }

    // Skip actual login logic for now, just show a success message

    Get.snackbar('Success', 'Login successful');
    Get.offNamed(AppRoutes.dashboard);
  }

  @override
  void onClose() {
    nameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}