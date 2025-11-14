import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sangaivendorapp/controller/authcontroller.dart';
import 'package:sangaivendorapp/pages/loginpage.dart';
import 'package:sangaivendorapp/pages/navigatepage.dart';

class AuthcheckPage extends StatelessWidget {
  const AuthcheckPage({super.key});

  @override
  Widget build(BuildContext context) {
    Authcontroller controller = Get.put(Authcontroller());
    return Obx(() {
      // if (controller.isserverok.value) {
      if (controller.islogin.value) {
        // If the screen width is less than 600, return the mobile view
        return MainScreen();
      } else {
        // If the screen width is 600 or more, return the web view
        return const LoginPage();
      }
      // } else {
      //   return const ServerErrorPage();
      // }
    });
  }
}
