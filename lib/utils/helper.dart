import 'package:get/get.dart' hide Response;
import 'package:flutter/material.dart';
import '../utils/storage.dart';

class Helper {
  Helper._();

  static loadingShow() {
    Get.dialog(
      Container(
        color: Colors.black54,
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  static loadingHide() {
    Get.back();
  }
}

class LoadingDialog {
  static show() {
    Get.dialog(
      GestureDetector(
        child: Container(
          color: Colors.black54,
          child: const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ),
        onTap: () {
          // 点击是否退出模态框
          Get.back();
        },
      ),
      barrierDismissible: false,
    );
  }

  static hide() {
    Get.back();
  }
}
