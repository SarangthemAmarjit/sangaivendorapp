import 'dart:developer';

import 'package:get/get.dart';
import 'package:sangaivendorapp/routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authcontroller extends GetxController {
  RxBool islogin = false.obs;
  int? _userid;
  int? get userid => _userid;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    getData();
  }

  void getData() async {
    final prefs = await SharedPreferences.getInstance();
    // if (prefs.containsKey('threshold')) {
    //   getthreshold();
    // }

    if (prefs.containsKey('islogin')) {
      islogin.value = prefs.getBool('islogin')!;
      _userid = prefs.getInt('userid')!;

      log(_userid.toString());

      ///caazscsac
      update();
    } else {
      islogin.value = false;
    }
  }

  logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();

    getData();
    Get.offAllNamed(AppRoutes.handlepage);
  }
}
