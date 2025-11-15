import 'dart:developer';

import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sangaivendorapp/config/cons.dart';
import 'package:sangaivendorapp/model/ticketdetailssumary.dart';
import 'package:sangaivendorapp/routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authcontroller extends GetxController {
  RxBool islogin = false.obs;
  int? _userid;
  int? get userid => _userid;

  bool _isfetchingdata = false;
  bool get isfetchingdata => _isfetchingdata;

  String _fullname = '';
  String get fullname => _fullname;

  TicketSumaryModel? _ticketSummaryModel;
  TicketSumaryModel? get ticketSummaryModel => _ticketSummaryModel;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    Future.delayed(
      const Duration(milliseconds: 10),
    ).whenComplete(() => FlutterNativeSplash.remove());
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
      _fullname = prefs.getString('fullname')!;

      log(_userid.toString());

      ///caazscsac
      update();
      getsummarydetailsbyuserid(userid: _userid!);
    } else {
      islogin.value = false;
    }
  }

  getsummarydetailsbyuserid({required int userid}) async {
    _isfetchingdata = true;
    update();
    try {
      final response = await http.get(
        Uri.parse('$baselocalapi/TicketsApi/summary?activatedBy=$userid'),
      );
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        print(response.body);

        final data = ticketSumaryModelFromJson(response.body);
        _ticketSummaryModel = data;

        _isfetchingdata = false;
        update();
      } else {
        _isfetchingdata = false;
        update();
        print('Error ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (e) {
      _isfetchingdata = false;
      update();
      print('Exceptiondsd: $e');
    }
  }

  logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();

    getData();
    Get.offAllNamed(AppRoutes.handlepage);
  }
}
