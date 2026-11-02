import 'package:get/get.dart';
import '../controllers/dashboard_binding.dart';
import '../views/dashboard_view.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.dashboard,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
    ),
  ];
}
