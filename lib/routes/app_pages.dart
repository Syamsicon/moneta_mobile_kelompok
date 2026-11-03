import 'package:get/get.dart';
import 'package:moneta/controllers/alokasi_binding.dart';
import 'package:moneta/controllers/rekomendasi_binding.dart';
import 'package:moneta/views/alokasi_view.dart';
import 'package:moneta/views/rekomendasi_view.dart';

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
    GetPage(
      name: AppRoutes.alokasi,
      page: () => const AlokasiView(),
      binding: AlokasiBinding(),
    ),
    GetPage(
      name: AppRoutes.rekomendasi,
      page: () => const RekomendasiView(),
      binding: RekomendasiBinding()
    ),
  ];
}
