import 'package:get/get.dart';

class PageManagementcontroller extends GetxController {
  int _selectedIndex = 0;
  int get selectedindex => _selectedIndex;

  setnavindex({required int ind}) {
    _selectedIndex = ind;
    update();
  }
}
