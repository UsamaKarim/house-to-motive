import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
class Utils {

  static void fieldFocusChange(BuildContext context , FocusNode current , FocusNode  nextFocus ){
    current.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
  static toastMessage(String message){
    Fluttertoast.showToast(
      msg: message ,
      backgroundColor: Colors.black ,
      textColor: Colors.white,
      gravity: ToastGravity.BOTTOM,
      toastLength: Toast.LENGTH_LONG,


    );
  }


  static toastMessageCenter(String message){
    Fluttertoast.showToast(
      msg: message ,
      backgroundColor: Colors.black  ,
      gravity: ToastGravity.CENTER,
      toastLength: Toast.LENGTH_LONG,
      textColor:  Colors.white ,
    );
  }

  static snackBar(String title, String message){
    Get.snackbar(
        title,
        message ,
        backgroundColor: Colors.green ,
        colorText: Colors.white
    );
  }
  static Future<void> startLoading({required String loadingStatus}) async {
    await EasyLoading.show(
      status: loadingStatus,
      maskType: EasyLoadingMaskType.black,
    );

    await Future.delayed(const Duration(seconds: 2));

    await EasyLoading.dismiss();
  }
}