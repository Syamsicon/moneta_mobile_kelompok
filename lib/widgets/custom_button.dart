import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final double? width;
  final double height;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final double borderRadius;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.width = double.infinity,
    this.height = 48,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.borderRadius = 50, // Pill radius 50
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBgColor = backgroundColor ??
        (isOutlined ? Colors.white : AppColors.primary);

    final effectiveTextColor = textColor ??
        (isOutlined ? AppColors.primary : Colors.white);

    final effectiveBorderColor = borderColor ?? AppColors.border;

    return SizedBox(
      width: width,
      height: height,
      child: isOutlined
          ? OutlinedButton(
              onPressed: isLoading ? null : onPressed,
              style: OutlinedButton.styleFrom(
                backgroundColor: effectiveBgColor,
                side: BorderSide(color: effectiveBorderColor, width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              child: _buildChild(effectiveTextColor),
            )
          : ElevatedButton(
              onPressed: isLoading ? null : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: effectiveBgColor,
                foregroundColor: effectiveTextColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              child: _buildChild(effectiveTextColor),
            ),
    );
  }

  Widget _buildChild(Color currentTextColor) {
    if (isLoading) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(currentTextColor),
        ),
      );
    }

    return Text(
      text,
      style: isOutlined
          ? AppTextStyles.buttonSecondary.copyWith(color: currentTextColor)
          : AppTextStyles.buttonPrimary.copyWith(color: currentTextColor),
    );
  }
}

