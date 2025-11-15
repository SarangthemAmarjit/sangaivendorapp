import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sangaivendorapp/controller/authcontroller.dart';

import '../config/cons.dart';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _subscription;

  // Observable network state
  RxBool isOnline = true.obs;

  // API server status
  RxBool isservererror = false.obs;

  // While checking server
  RxBool ischecking = false.obs;

  @override
  void onInit() {
    super.onInit();
    _checkInitialConnection();
    _listenToNetworkChanges();
  }

  /// Check the connection when the app starts
  Future<void> _checkInitialConnection() async {
    final result = await _connectivity.checkConnectivity();
    _updateStatus(result);

    // If device is online, check server immediately
    if (isOnline.value) {
      checkapiserver();
    }
  }

  /// Listen to connectivity changes
  void _listenToNetworkChanges() {
    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      if (results.isNotEmpty) {
        _updateStatus(results);

        // Auto test server when network becomes available
        if (isOnline.value) {
          checkapiserver();
        }
      }
    });
  }

  /// API server check
  Future<void> checkapiserver() async {
    ischecking.value = true;

    try {
      final response = await http.get(
        Uri.parse('$baselocalapi/TicketTypesApi'),
      );

      if (response.statusCode == 200) {
        Get.find<Authcontroller>().getData();
        isservererror.value = false;
      } else {
        isservererror.value = true;
        print('Server Error ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (e) {
      isservererror.value = true;
      print('API Exception: $e');
    } finally {
      ischecking.value = false;
    }
  }

  /// Update network (device-level) online status
  void _updateStatus(List<ConnectivityResult> result) {
    if (result.contains(ConnectivityResult.mobile) ||
        result.contains(ConnectivityResult.wifi) ||
        result.contains(ConnectivityResult.ethernet)) {
      isOnline.value = true;
    } else {
      isOnline.value = false;
      isservererror.value = true; // also mark server error (no network)
    }
  }

  @override
  void onClose() {
    _subscription.cancel();
    super.onClose();
  }
}
