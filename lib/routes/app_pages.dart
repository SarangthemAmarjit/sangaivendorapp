import 'package:get/get.dart';
import 'package:sangaivendorapp/controller/managementcon.dart';
import 'package:sangaivendorapp/pages/loginpage.dart';
import 'package:sangaivendorapp/pages/navigatepage.dart';


import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.login,
      page: () => LoginPage(),

      binding: BindingsBuilder(
        () => Get.lazyPut(() => Managementcontroller()),
      ),
    ),
       GetPage(
      name: AppRoutes.mainpage,
      page: () => MainScreen(),

      binding: BindingsBuilder(
        () => Get.lazyPut(() => Managementcontroller()),
      ),
    ),


  ];
}
