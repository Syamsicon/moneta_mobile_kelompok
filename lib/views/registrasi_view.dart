import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/registrasi_controller.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_colors.dart';

class RegistrasiView extends GetView<RegistrasiController> {
  const RegistrasiView({super.key});

  @override
  Widget build(BuildContext context) {
    var isLoginLinkHovered = false;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - 
                  MediaQuery.of(context).padding.top - 
                  MediaQuery.of(context).padding.bottom - 48,
              ),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Top Section: Logo & Title
                  Column(
                    children: [
                      // Moneta Logo / Icon Section[cite: 1]
                      Column(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black, width: 1.5),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Center(
                              child: Text(
                                'Icon',
                                style: AppTextStyles.icon,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'MONETA',
                            style: AppTextStyles.icon,
                          ),
                        ],
                      ),
                    ],
                  ),
                  
                  // Middle Section: Form Fields
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Text(
                          'Registrasi Akun',
                          style: AppTextStyles.title,
                        ),
                      ),
                      const SizedBox(height: 24),

                      Text(
                        'Nama',
                        style: AppTextStyles.label,
                      ),
                      SizedBox(height: 8),
                      TextField(
                        controller: controller.nameController,
                        decoration: InputDecoration(
                          hintText: 'Ikan',
                          hintStyle: AppTextStyles.hint,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.black, width: 1.5),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      Text(
                        'Email',
                        style: AppTextStyles.label,
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: controller.emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'ikan@gmail.com',
                          hintStyle: AppTextStyles.hint,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.black, width: 1.5),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      Text(
                        'Password',
                        style: AppTextStyles.label,
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: controller.passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: '123345',
                          hintStyle: AppTextStyles.hint,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.black, width: 1.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  // Bottom Section: Action Buttons
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Sudah punya akun?',
                            style: AppTextStyles.label,
                          ),
                          const SizedBox(width: 4),
                          StatefulBuilder(
                            builder: (context, setState) => InkWell(
                              onHover: (isHovered) {
                                if (isLoginLinkHovered != isHovered) {
                                  setState(() {
                                    isLoginLinkHovered = isHovered;
                                  });
                                }
                              },
                              onTap: () {
                                Get.toNamed('/login');
                              },
                              child: Text(
                                'Login',
                                style: AppTextStyles.link(
                                  isHovered: isLoginLinkHovered,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      ElevatedButton(
                        onPressed: () {
                          controller.register();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Daftar',
                          style: AppTextStyles.buttonPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      OutlinedButton(
                        onPressed: () {
                          exit(0); // Exit the app
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.black,
                          side: const BorderSide(color: Colors.black, width: 1),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: Text(
                          'Keluar',
                          style: AppTextStyles.buttonSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
