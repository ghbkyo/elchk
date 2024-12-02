import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_elchk/pages/login/view.dart';
import 'package:flutter_elchk/pages/myevent/controller.dart';
import 'package:get/get.dart' hide Response;
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../servie/index.dart';
import '../extensions/index.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../pages/initial/index.dart';
import '../../routes/index.dart';
import 'package:share_plus/share_plus.dart';

Widget tex(String txt,
    {double fontSize = 14,
    TextAlign? textAlign,
    Color? color = const Color(0xFF000000),
    FontWeight? fontWeight = FontWeight.normal}) {
  return Text(txt,
      textAlign: textAlign,
      // maxLines: 1,
      style: TextStyle(
        fontFamily: 'NotoSansHK',
        color: color,
        fontSize: fontSize + AppService.fontSize,
        fontWeight: fontWeight,
        // overflow: TextOverflow.ellipsis,
      ));
}

void share(String text, String? subject) {
  Share.share(text, subject: subject);
}

void loginOut() {
  AuthService.loginOut();
  Get.offAll(const LoginPage());
}

void paySuccess() {
  Get.lazyPut(() => MyeventController());
  Get.lazyPut(() => InitialController());
  final home = Get.find<InitialController>();
  home.state.currentIndex = 2;
  home.update(['initial']);

  final event = Get.find<MyeventController>();
  event.state.payStatus = true;
  event.state.dialogStatus = false;
  event.state.dialogType = 0;
  event.update(['event']);
  Get.offAll(const InitialPage());
}
