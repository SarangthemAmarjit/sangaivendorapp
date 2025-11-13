import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sangaivendorapp/routes/app_bindings.dart';
import 'package:sangaivendorapp/routes/app_pages.dart';

void main() {
  runApp(const SangaiVendorApp());
}

class SangaiVendorApp extends StatelessWidget {
  const SangaiVendorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Sangai Vendor App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'KulimPark', useMaterial3: true),
      initialBinding: AppBindings(),
      getPages: AppPages.pages,
    );
  }
}
