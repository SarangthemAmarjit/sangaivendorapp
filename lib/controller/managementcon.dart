import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sangaivendorapp/config/cons.dart';
import 'package:sangaivendorapp/controller/authcontroller.dart';
import 'package:sangaivendorapp/controller/pagecontroller.dart';
import 'package:sangaivendorapp/model/offlineticketmodel.dart';
import 'package:sangaivendorapp/model/userloginresmodel.dart';
import 'package:sangaivendorapp/model/userresponsemodel.dart';
import 'package:sangaivendorapp/routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class Managementcontroller extends GetxController {
  final TextEditingController ticketController = TextEditingController();
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

  bool _isactivation1completed = false;
  bool get isactivation1completed => _isactivation1completed;
  bool _isactivation2completed = false;
  bool get isactivation2completed => _isactivation2completed;
  bool _isactivation3completed = false;
  bool get isactivation3completed => _isactivation3completed;

  String _scanedticketnum = '';
  String get scanticketnum => _scanedticketnum;

  void reset() {
    _scanResult = null;
    _scanMessage = null;

    _showValidationButtons = false;
    _pendingTicketNo = null;

    _isticketvalided = false;

    _resultColor = Colors.red;
    _resultIcon = Icons.warning;
    ticketController.clear();
    update();
  }

  Future<void> activateTicket(BuildContext context) async {
    await updateofflineticket(id: _offlineticketModel!.offlineTicketId);
    await addpayment();
    await addticketdetails();

    if (_isactivation1completed &&
        _isactivation2completed &&
        isactivation3completed) {
      reset();
      Get.find<Authcontroller>().getData();
      showCommonDialog(
        context: context,
        title: 'Success',
        message: 'Ticket Activated Successfully',
        isSuccess: true,
      );
    } else {
      showCommonDialog(
        context: context,
        title: 'Error',
        message: 'Something Went Wrong Try Again',
        isSuccess: false,
      );
    }
  }

  // Future<void> scanBarcodeNormal(BuildContext context) async {
  //   String barcodeScanRes;
  //   // Platform messages may fail, so we use a try/catch PlatformException.
  //   try {
  //     barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
  //       '#ff6666',
  //       'Cancel',
  //       true,
  //       ScanMode.BARCODE,
  //     );
  //     print(barcodeScanRes);
  //   } on PlatformException {
  //     barcodeScanRes = 'Failed to get platform version.';
  //   }

  //   // If the widget was removed from the tree while the asynchronous platform
  //   // message was in flight, we want to discard the reply rather than calling
  //   // setState to update our non-existent appearance.

  //   _scanedticketnum = barcodeScanRes;
  //   update();
  //   getdatabybarcode(barcodenum: _scanedticketnum, context: context);
  // }
  bool containsSymbols(String input) {
    final symbolRegex = RegExp(r'[^a-zA-Z0-9]');
    return symbolRegex.hasMatch(input);
  }

  void scanticket(BuildContext context) async {
    String? res = await SimpleBarcodeScanner.scanBarcode(
      scanType: ScanType.barcode,
      scanFormat: ScanFormat.ONLY_BARCODE,
      context,
      barcodeAppBar: const BarcodeAppBar(
        centerTitle: false,
        enableBackButton: true,
        backButtonIcon: Icon(Icons.arrow_back_ios),
      ),
      isShowFlashIcon: true,
      delayMillis: 100,
      cameraFace: CameraFace.back,
    );
    log("Barcode result : $res!");
    _scanedticketnum = res!;
    update();

    if (containsSymbols(res)) {
      showCommonDialog(
        context: context,
        title: 'Scanned Error',
        message: 'Scan again and keep the barcode inside the frame',
        isSuccess: false,
      );
    } else {
      getdatabybarcode(barcodenum: _scanedticketnum, context: context);
    }

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
        Get.find<Authcontroller>().getsummarydetailsbyuserid(
          userid: res.userId,
        );
        // Optional: parse model
        // final data = registerModelFromJson(response.body);
        // _registerModel = data;
        _isloadingshopregister = false;
        update();
        await saveData(userid: res.userId, fullname: res.fullName);

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
        Get.find<PageManagementcontroller>().setnavindex(ind: 0);
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

    // Normalize today date
    final today = DateTime(now.year, now.month, now.day);
    final ticketDay = DateTime(
      ticketDate.year,
      ticketDate.month,
      ticketDate.day,
    );

    if (ticketDay.isAfter(today)) {
      // Future date → always valid
      return true;
    }

    if (ticketDay.isAtSameMomentAs(today)) {
      // Today → check before 8 PM
      final cutoffTime = DateTime(now.year, now.month, now.day, 20, 0);
      return now.isBefore(cutoffTime);
    }

    // Past date → invalid
    return false;
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
            _scanMessage =
                "Ticket #$barcodenum has expired and cannot be activated";
            _resultColor = Colors.red;
            _resultIcon = Icons.warning;
            _showValidationButtons = false;
            update();
          } else if (_offlineticketModel!.status == "Sold") {
            _scanResult = 'Ticket already sold';
            _isticketvalided = false;
            _scanMessage = "Ticket #$barcodenum has already been sold";
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
          _scanMessage =
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
      print('Exceptiondsd: $e');
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

  Future updateofflineticket({required int id}) async {
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
        "ticketDate": _offlineticketModel!.ticketDate.toIso8601String(),
        "price": _offlineticketModel!.price,
        "status": "Sold",
        "saleAt": DateTime.now().toIso8601String(),
        "generateAt": _offlineticketModel!.generateAt.toIso8601String(),
      });

      final response = await http.put(url, headers: headers, body: body);

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 204) {
        _isactivation1completed = true;
        update();
        print('Updated Successful');
      } else {
        _isactivation1completed = false;
        update();

        print(
          'Updated Failed (${response.statusCode}): ${response.reasonPhrase} ${response.body}',
        );
      }
    } catch (e) {
      _isactivation1completed = false;
      update();
      print('Exception: $e');

      return e.toString();
    }
  }

  Future addpayment() async {
    //     _isloadingshopregister = true;
    // update();
    try {
      final url = Uri.parse(
        '$baselocalapi/PaymentsApi',
      ); // change endpoint if needed

      final headers = {'Content-Type': 'application/json'};

      log(_offlineticketModel!.offlineTicketId.toString());

      final body = jsonEncode({
        "offlineTicketId": _offlineticketModel!.offlineTicketId,
        "amount": _offlineticketModel!.price,
        "paymentMethod": "Cash",

        "status": "Success",
      });

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        _isactivation2completed = true;
        update();
        print('Add Payment Successful');
      } else {
        _isactivation2completed = false;
        update();

        print(
          'Add Payment Failed (${response.statusCode}): ${response.reasonPhrase} ${response.body}',
        );
      }
    } catch (e) {
      _isactivation2completed = false;
      update();
      print('Exception: $e');
    }
  }

  Future addticketdetails() async {
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
        "ticketDate": _offlineticketModel!.ticketDate.toIso8601String(),
        "price": _offlineticketModel!.price,
        "status": "Activated",
        "activatedBy": Get.find<Authcontroller>().userid,
        "activatedAt": DateTime.now().toIso8601String(),
        // "usedAt": "2025-11-14T12:45:17.476Z",
      });

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        _isactivation3completed = true;
        print('Add TicketDetails Successful');
        _isloadingforactivate = false;
        update();
      } else {
        _isactivation3completed = false;

        _isloadingforactivate = false;

        update();
        print(
          'Add TicketDetails Failed (${response.statusCode}): ${response.reasonPhrase} ${response.body}',
        );
      }
    } catch (e) {
      _isactivation3completed = false;

      _isloadingforactivate = false;
      update();
      print('Exception: $e');
    }
  }
}
