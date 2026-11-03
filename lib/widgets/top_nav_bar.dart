import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:moneta/routes/app_routes.dart';
import '../theme/app_text_styles.dart';


class _NavItem {
  final String label;
  final IconData icon;
  final String routeName;

  const _NavItem({required this.label, required this.icon, required this.routeName});

}

class TopNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int>? onNavTap;

  const TopNavBar({
    super.key,
    this.selectedIndex = 1,
    this.onNavTap,
  });

  static const _items = [
    _NavItem(label: "Riwayat", icon: Icons.history, routeName: ''),
    _NavItem(label: "Dashboard", icon: Icons.dashboard, routeName: AppRoutes.dashboard),
    _NavItem(label: "Alokasi", icon: Icons.history, routeName: AppRoutes.alokasi)
  ];

  static const _label = ['Riwayat', 'Dashboard', 'Alokasi'];
  static const _icon = [Icons.history, Icons.dashboard, Icons.assignment_outlined];

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    for (var i = 0; i < _items.length; i++) {
      if(i > 0) children.add(const SizedBox(width: 8));
      children.add(
        i == selectedIndex ? _activeCapsule(_items[i]) : Expanded(child: _pill(_items[i])),
      );
    }

    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(children: children),
    );
  }

  Widget _activeCapsule(_NavItem item) {
    return Container(
      width: 72,
      height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: Colors.white, width: 1),
      ),
      child: Icon(item.icon, size: 22, color: Colors.white),
    );
  }

  Widget _pill(_NavItem item) {
    return InkWell(
      onTap: () => Get.offAllNamed(item.routeName),
      borderRadius: BorderRadius.circular(50),
      child: Container(
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: Colors.white, width: 1),
        ),
        child: Text(item.label, style: AppTextStyles.navPill,),
      ),
    );
  }
}