import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sangaivendorapp/controller/networkcon.dart';
import 'package:sangaivendorapp/pages/authcheck.dart';
import 'package:sangaivendorapp/pages/servererrorpage.dart';

class HomeWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final NetworkController net = Get.find<NetworkController>();

    return Obx(() {
      // Step 1: Still checking server → show loader
      if (net.ischecking.value) {
        return Scaffold(
          body: Center(
            child: SizedBox(
              height: 30,
              width: 30,
              child: CircularProgressIndicator(),
            ),
          ),
        );
      }

      // Step 2: Device online + Server OK → go to Auth page
      if (net.isOnline.value && !net.isservererror.value) {
        return AuthcheckPage();
      }

      // Step 3: Else → server error page
      return ServerErrorPage();
    });
  }
}
