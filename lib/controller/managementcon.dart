import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class Managementcontroller extends GetxController{



  String _scanedticketnum = '';
  String get scanticketnum => _scanedticketnum;

  void scanticket(BuildContext context)async{
    String? res = await SimpleBarcodeScanner.scanBarcode(
                  context,
                  barcodeAppBar: const BarcodeAppBar(
                    appBarTitle: 'Test',
                    centerTitle: false,
                    enableBackButton: true,
                    backButtonIcon: Icon(Icons.arrow_back_ios),
                  ),
                  isShowFlashIcon: true,
                  delayMillis: 2000,
                  cameraFace: CameraFace.front,
                );
            if(res!=null){
   _scanedticketnum = res;
                update();
                // updateticketassold();
            }
               
  }

}