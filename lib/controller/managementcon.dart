import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sangaivendorapp/config/cons.dart';
import 'package:sangaivendorapp/controller/authcontroller.dart';
import 'package:sangaivendorapp/model/offlineticketmodel.dart';
import 'package:sangaivendorapp/model/userloginresmodel.dart';
import 'package:sangaivendorapp/model/userresponsemodel.dart';
import 'package:sangaivendorapp/routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class Managementcontroller extends GetxController {
  bool _isloadingshopregister = false;
  bool get isloadingshopregister => _isloadingshopregister;

  bool _isloadingforactivate = false;
  bool get isloadingforactivate => _isloadingforactivate;

  bool _isticketvalided = false;
  bool get isticketvalided => _isticketvalided;

  String _ticketcheckresult = '';
  String get ticketcheckresult => _ticketcheckresult;

  String? _errortext;
  String? get errortext => _errortext;

  bool _isticketchecking = true;
  bool get isticketchecking => _isticketchecking;

  OfflineticketModel? _offlineticketModel;
  OfflineticketModel? get offlineticketmodel => _offlineticketModel;

  String? _scanResult;
  String? get scanResult => _scanResult;

  String? _scanMessage;
  String? get scanMessage => _scanMessage;
  Color? _resultColor;
  Color? get resultColor => _resultColor;
  IconData? _resultIcon;
  IconData? get resultIcon => _resultIcon;
  bool _showValidationButtons = false;
  bool? get showValidationButtons => _showValidationButtons;
  int? _pendingTicketNo;
  int? get pendingTicketNo => _pendingTicketNo;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    Future.delayed(
      const Duration(milliseconds: 10),
    ).whenComplete(() => FlutterNativeSplash.remove());
  }

  String _scanedticketnum = '';
  String get scanticketnum => _scanedticketnum;

  void activateTicket(){
    updateofflineticket(id: _offlineticketModel!.offlineTicketId);
    addpayment();
    addticketdetails();
  }

  void scanticket(BuildContext context) async {
    String? res = await SimpleBarcodeScanner.scanBarcode(
      context,
      barcodeAppBar: const BarcodeAppBar(
        centerTitle: false,
        enableBackButton: true,
        backButtonIcon: Icon(Icons.arrow_back_ios),
      ),
      isShowFlashIcon: true,
      delayMillis: 2000,
      cameraFace: CameraFace.back,
    );
    log(res!);
    _scanedticketnum = res;
    update();
    getdatabybarcode(barcodenum: _scanedticketnum, context: context);
    // updateticketassold();
  }

  // Save data to local storage

  Future<void> saveData({required int userid, required String fullname}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('islogin', true);
    await prefs.setInt('userid', userid);
    await prefs.setString('fullname', fullname);

    update();
  }

  Future<String> registerShop({
    required String fullname,
    required String password,
    required String phonnumber,
  }) async {
    _isloadingshopregister = true;
    update();
    try {
      final url = Uri.parse(
        '$baselocalapi/UsersApi/register',
      ); // change endpoint if needed

      final headers = {'Content-Type': 'application/json'};

      final body = jsonEncode({
        "fullName": fullname,
        "username": phonnumber,
        "passwordHash": password,
        "role": "Shop",
        "phoneNumber": phonnumber,
      });

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Registration Successful');
        print('Response: ${response.body}');
        var res = userresponsemodelFromJson(response.body);
        // Optional: parse model
        // final data = registerModelFromJson(response.body);
        // _registerModel = data;
        _isloadingshopregister = false;
        update();
        saveData(userid: res.userId, fullname: res.fullName);
        Get.offAllNamed(AppRoutes.mainpage);
        return 'Registration Successfully';
      } else if (response.statusCode == 400) {
        return response.body;
      } else {
        _isloadingshopregister = false;
        update();
        print(
          'Registration Failed (${response.statusCode}): ${response.reasonPhrase} ${response.body}',
        );
        return 'Registration Failed';
      }
    } catch (e) {
      _isloadingshopregister = false;
      update();
      print('Exception: $e');

      return e.toString();
    }
  }

  Future<String> loginforshop({
    required String username,
    required String password,
  }) async {
    _isloadingshopregister = true;
    update();
    try {
      final url = Uri.parse(
        '$baselocalapi/UsersApi/login',
      ); // change endpoint if needed

      final headers = {'Content-Type': 'application/json'};

      final body = jsonEncode({"username": username, "password": password});

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Login Successful');
        print('Response: ${response.body}');
        var res = userloginresponsemodelFromJson(response.body);
        // Optional: parse model
        // final data = registerModelFromJson(response.body);
        // _registerModel = data;
        _isloadingshopregister = false;
        update();
        saveData(userid: res.userId, fullname: res.fullName);
        Get.offAllNamed(AppRoutes.mainpage);
        return 'Login Successfully';
      } else if (response.statusCode == 400) {
        return response.body;
      } else {
        _isloadingshopregister = false;
        update();
        print(
          'Login Failed (${response.statusCode}): ${response.reasonPhrase} ${response.body}',
        );
        return 'Invalid username or Password';
      }
    } catch (e) {
      _isloadingshopregister = false;
      update();
      print('Exception: $e');

      return e.toString();
    }
  }

  bool isTicketValid(DateTime ticketDate) {
    final now = DateTime.now();

    // Check if the ticket date is today
    bool isToday =
        ticketDate.year == now.year &&
        ticketDate.month == now.month &&
        ticketDate.day == now.day;

    // Check if current time is before 8 PM
    final cutoffTime = DateTime(now.year, now.month, now.day, 20, 0); // 8:00 PM
    bool isBefore8PM = now.isBefore(cutoffTime);

    return isToday && isBefore8PM;
  }

  getdatabybarcode({
    required String barcodenum,
    required BuildContext context,
  }) async {
    _isticketchecking = true;
    update();
    try {
      final response = await http.get(
        Uri.parse('$baselocalapi/OfflineTicketsApi/barcode/$barcodenum'),
      );
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        print(response.body);

        final data = offlineticketModelFromJson(response.body);
        _offlineticketModel = data;
        update();

        if (barcodenum.isNotEmpty &&
            (barcodenum[0] == '1' || barcodenum[0] == '2')) {
          if (!isTicketValid(_offlineticketModel!.ticketDate)) {
            _scanResult = 'Ticket Expired';
            _isticketvalided = false;
            _ticketcheckresult =
                "Ticket #$barcodenum has expired and cannot be activated";
            _resultColor = Colors.red;
            _resultIcon = Icons.warning;
            _showValidationButtons = false;
            update();
          } else if (_offlineticketModel!.status == "Sold") {
            _scanResult = 'Ticket already sold';
            _isticketvalided = false;
            _ticketcheckresult = "Ticket #$barcodenum has already been sold";
            _resultColor = Colors.orange;
            _resultIcon = Icons.info;
            _showValidationButtons = false;
            update();
          } else if (isTicketValid(_offlineticketModel!.ticketDate) &&
              _offlineticketModel!.status == "UnSold") {
            _isticketvalided = true;
            _scanResult = 'Ticket Validated';
            _scanMessage = 'Ticket #$barcodenum is valid and ready to activate';
            _resultColor = Colors.blue;
            _resultIcon = Icons.verified;
            _showValidationButtons = true;
            _pendingTicketNo = int.parse(barcodenum);
            update();
          }
        } else {
          _scanResult = 'Invalid Ticket';
          _isticketvalided = false;
          _ticketcheckresult =
              "Ticket #$barcodenum is not recognized as a valid offline ticket.";
          _resultColor = Colors.red;
          _resultIcon = Icons.error;
          _showValidationButtons = false;
          update();
        }
        _isticketchecking = false;
        update();
      } else {
        _isticketchecking = false;
        update();
        showCommonDialog(
          context: context,
          title: 'Error',
          message: 'Ticket Number Not Found',
          isSuccess: false,
        );
        print('Error ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (e) {
      _isticketchecking = false;
      update();
      print('Exception: $e');
    }
  }

  Future<String> verifyOtpforregister({
    required String fullname,
    required String pass,
    required String number,
    required String otp,
    required BuildContext context,
  }) async {
    if (otp == '123456') {
      var resstring = await registerShop(
        fullname: fullname,
        password: pass,
        phonnumber: number,
      );

      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => const MainScreen()),
      // );
      return resstring;
    } else {
      return 'Invalid OTP';
    }
  }

  void showCommonDialog({
    required BuildContext context,
    required String title,
    required String message,
    required bool isSuccess, // true = success, false = error
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                isSuccess ? Icons.check_circle : Icons.error,
                color: isSuccess ? Colors.green : Colors.red,
                size: 32,
              ),
              const SizedBox(width: 10),
              Text(title),
            ],
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  updateofflineticket({required int id}) async {
    _isloadingforactivate = true;
    update();
    try {
      final url = Uri.parse(
        '$baselocalapi/OfflineTicketsApi/$id',
      ); // change endpoint if needed

      final headers = {'Content-Type': 'application/json'};

      final body = jsonEncode({
        "offlineTicketId": id,
        "barcode": _offlineticketModel!.barcode,
        "ticketTypeId": _offlineticketModel!.ticketTypeId,
        "ticketDate": _offlineticketModel!.ticketDate,
        "price": _offlineticketModel!.price,
        "status": "Sold",
        "saleAt": DateTime.now().toIso8601String(),
        "generateAt": "2025-11-14T12:16:14.974Z",
      });

      final response = await http.put(url, headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Updated Successful');
      } else {
        update();
        print(
          'Updated Failed (${response.statusCode}): ${response.reasonPhrase} ${response.body}',
        );
      }
    } catch (e) {
      print('Exception: $e');

      return e.toString();
    }
  }

  addpayment() async {
    //     _isloadingshopregister = true;
    // update();
    try {
      final url = Uri.parse(
        '$baselocalapi/PaymentsApi',
      ); // change endpoint if needed

      final headers = {'Content-Type': 'application/json'};

      final body = jsonEncode({
        "ticketId": _offlineticketModel!.offlineTicketId,
        "amount": _offlineticketModel!.price,
        "paymentMethod": "cash",

        "status": "Sold",
        "paymentDate": DateTime.now().toIso8601String(),
      });

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Add Payment Successful');
      } else {
        update();
        print(
          'Add Payment Failed (${response.statusCode}): ${response.reasonPhrase} ${response.body}',
        );
      }
    } catch (e) {
      print('Exception: $e');
    }
  }

  addticketdetails() async {
    //     _isloadingshopregister = true;
    // update();
    try {
      final url = Uri.parse(
        '$baselocalapi/TicketsApi',
      ); // change endpoint if needed

      final headers = {'Content-Type': 'application/json'};

      final body = jsonEncode({
        "barcode": _offlineticketModel!.barcode,
        "ticketTypeId": _offlineticketModel!.offlineTicketId,
        "ticketDate": _offlineticketModel!.ticketDate,
        "price": _offlineticketModel!.price,
        "status": "Sold",
        "activatedBy": Get.find<Authcontroller>().userid,
        "activatedAt": DateTime.now().toIso8601String(),
        // "usedAt": "2025-11-14T12:45:17.476Z",
      });

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Add Payment Successful');
        _isloadingforactivate = false;
        update();
      } else {
        _isloadingforactivate = false;

        update();
        print(
          'Add Payment Failed (${response.statusCode}): ${response.reasonPhrase} ${response.body}',
        );
      }
    } catch (e) {
      _isloadingforactivate = false;
      update();
      print('Exception: $e');
    }
  }
}
