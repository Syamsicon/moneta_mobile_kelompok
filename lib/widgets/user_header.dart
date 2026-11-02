import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class UserHeader extends StatelessWidget {
  final String userName;
  final String date;
  final String initial;
  final VoidCallback? onSettingsTap;

  const UserHeader({
    super.key,
    required this.userName,
    required this.date,
    required this.initial,
    this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // User Name & Date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  userName,
                  style: AppTextStyles.userName,
                ),
                const SizedBox(height: 2),
                Text(
                  date,
                  style: AppTextStyles.dateSubtitle,
                ),
              ],
            ),
          ),

          // Settings circle button
          InkWell(
            onTap: onSettingsTap,
            borderRadius: BorderRadius.circular(50),
            child: Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.border, width: 1),
              ),
              child: const Icon(
                Icons.settings,
                size: 20,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

