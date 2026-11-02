import 'package:flutter/material.dart';
import '../theme/app_text_styles.dart';

class QuickAddButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const QuickAddButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onPressed,
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      elevation: 4,
      shape: const StadiumBorder(),
      icon: const Icon(
        Icons.add,
        color: Colors.white,
        size: 20,
      ),
      label: Text(
        'Quick Add',
        style: AppTextStyles.quickAdd,
      ),
    );
  }
}

