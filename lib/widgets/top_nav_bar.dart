import 'package:flutter/material.dart';
import '../theme/app_text_styles.dart';

class TopNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int>? onNavTap;

  const TopNavBar({
    super.key,
    this.selectedIndex = 1,
    this.onNavTap,
  });

  static const _items = [
    (label: 'Riwayat', icon: Icons.history),
    (label: 'Dashboard', icon: Icons.dashboard),
    (label: 'Alokasi', icon: Icons.assignment_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    final others = [0, 1, 2].where((i) => i != selectedIndex).toList();

    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(child: _pill(others[0])),
          const SizedBox(width: 8),
          Container(
            width: 64,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: Colors.white, width: 1),
            ),
            child: Icon(
              _items[selectedIndex].icon,
              size: 22,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: _pill(others[1])),
        ],
      ),
    );
  }

  Widget _pill(int index) {
    return InkWell(
      onTap: () => onNavTap?.call(index),
      borderRadius: BorderRadius.circular(50),
      child: Container(
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: Colors.white, width: 1),
        ),
        child: Text(_items[index].label, style: AppTextStyles.navPill),
      ),
    );
  }
}