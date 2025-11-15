import 'package:get/get.dart';
import 'package:sangaivendorapp/controller/authcontroller.dart';
import 'package:sangaivendorapp/controller/managementcon.dart';
import 'package:sangaivendorapp/controller/networkcon.dart';
import 'package:sangaivendorapp/controller/pagecontroller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(NetworkController());
    Get.put(Authcontroller());
    Get.put(Managementcontroller());
    Get.put(PageManagementcontroller());
  }
}
