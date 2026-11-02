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

  static const _label = ['Riwayat', 'Dashboard', 'Alokasi'];
  static const _icon = [Icons.history, Icons.dashboard, Icons.assignment_outlined];

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    for (var i = 0; i < _label.length; i++) {
      if(i > 0) children.add(const SizedBox(width: 8));
      children.add(
        i == selectedIndex ? _activeCapsule(i) : Expanded(child: _pill(i)),
      );
    }

    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(children: children),
    );
  }

  Widget _activeCapsule(int index) {
    return Container(
      width: 72,
      height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: Colors.white, width: 1),
      ),
      child: Icon(_icon[index], size: 22, color: Colors.white),
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
        child: Text(_label[index], style: AppTextStyles.navPill,),
      ),
    );
  }
}