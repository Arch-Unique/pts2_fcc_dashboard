import 'package:pts2_fcc/src/features/dashboard.dart';
import 'package:pts2_fcc/src/src_barrel.dart';
import 'package:pts2_fcc/src/utils/constants/routes/middleware/auth_middleware.dart';
import 'package:get/get.dart';

import '../../features/auth.dart';

class AppPages {
  static List<GetPage> getPages = [
    GetPage(
        name: AppRoutes.home,
        page: () => AuthScreen(),
        middlewares: [AuthMiddleWare()]),
    GetPage(name: AppRoutes.auth, page: () => AuthScreen()),
    GetPage(name: AppRoutes.dashboard, page: () => DashboardScreen()),
  ];
}
