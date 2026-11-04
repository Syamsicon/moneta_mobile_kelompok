import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moneta/routes/app_routes.dart';

class RegistrasiController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void register() {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Please fill in all fields');
      return;
    }

    // Skip actual registration logic for now, just show a success message

    Get.snackbar('Success', 'Registration successful');
    Get.offNamed(AppRoutes.dashboard);
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}