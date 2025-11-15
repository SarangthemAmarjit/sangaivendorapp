import 'package:get/get.dart';
import 'package:sangaivendorapp/controller/authcontroller.dart';
import 'package:sangaivendorapp/controller/managementcon.dart';
import 'package:sangaivendorapp/controller/networkcon.dart';
import 'package:sangaivendorapp/pages/authcheck.dart';
import 'package:sangaivendorapp/pages/handlerwrapper.dart';
import 'package:sangaivendorapp/pages/loginpage.dart';
import 'package:sangaivendorapp/pages/navigatepage.dart';
import 'package:sangaivendorapp/pages/registrationpage.dart';

import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.netcheck,
      page: () => HomeWrapper(),

      binding: BindingsBuilder(() => Get.lazyPut(() => NetworkController())),
    ),
    GetPage(
      name: AppRoutes.handlepage,
      page: () => AuthcheckPage(),

      binding: BindingsBuilder(() => Get.lazyPut(() => Authcontroller())),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => LoginPage(),

      binding: BindingsBuilder(() => Get.lazyPut(() => Managementcontroller())),
    ),
    GetPage(
      name: AppRoutes.mainpage,
      page: () => MainScreen(),

      binding: BindingsBuilder(() => Get.lazyPut(() => Managementcontroller())),
    ),
    GetPage(
      name: AppRoutes.registrationpage,
      page: () => RegistrationPage(),

      binding: BindingsBuilder(() => Get.lazyPut(() => Managementcontroller())),
    ),
  ];
}
