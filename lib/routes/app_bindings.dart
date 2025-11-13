import 'package:get/get.dart';
import 'package:sangaivendorapp/controller/managementcon.dart';


class AppBindings extends Bindings {
  @override
  void dependencies() {
   
    Get.put(Managementcontroller());
 
  }
}
