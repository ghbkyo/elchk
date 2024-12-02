import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import '../../extensions/ex_widget.dart';
import '../../servie/index.dart';
import 'state.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import '../../routes/app_pages.dart';
import '../../utils/index.dart';

class RemarkController extends GetxController {
  RemarkController();

  String uiKey = 'remark';

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GetRemarkState state = GetRemarkState();

  void collectTap() async {
    bool collect = state.post['hasBookmark'];
    var body = {
      "programInfoId": state.post['id'],
      "isEnabled": !collect,
    };
    String apiUrl = 'ProgramBookmark/Set';

    dynamic res = await ApiService.post(apiUrl, data: body);

    if (res != null) {
      state.post['hasBookmark'] = !collect;
      update([uiKey]);
    }
  }

  void dialogClose() {
    state.dialogStatus = false;
    update([uiKey]);
  }

  void join() {
    bool hasCenter = false;
    state.dialogType = 1;

    for (var member in AuthService.memberData) {
      if (member['center']['id'] == state.post['center']['id']) {
        hasCenter = true;
      }
    }

    if (!hasCenter) {
      state.dialogText = '只供本中心會員報名';
      state.dialogStatus = true;
      update([uiKey]);
      return;
    }

    bool registered = false;

    for (var item in state.post['programSessions']) {
      if (item['registered'] == true) {
        registered = true;
      }
    }

    if (registered) {
      if (state.post['canDuplicateEnrollment']) {
        state.dialogType = 2;
        state.dialogText = '你已報名活動 (${state.post['name']})日期/時間衝突\n\n是否繼續報名?';
        state.dialogStatus = true;
        update([uiKey]);
        return;
      } else {
        state.dialogText = '你已報名活動 (${state.post['name']})\n\n不允許重複報名！';
        state.dialogStatus = true;
        // setAlertContent("不允許重複報名！")
        // setAlertTitle(`你已報名活動 (${program?.name})`)
        update([uiKey]);
        return;
      }
    }

    if (state.post['isFree']) {
      Get.toNamed(Routes.FREE, arguments: {'post': state.post});
    } else {
      Get.toNamed(Routes.PAYMENT, arguments: {'post': state.post});
    }
  }

  void joinNext() {
    dialogClose();
    if (state.post['isFree']) {
      Get.toNamed(Routes.FREE, arguments: {'post': state.post});
    } else {
      Get.toNamed(Routes.PAYMENT, arguments: {'post': state.post});
    }
  }

  @override
  void onInit() {
    state.post = Get.arguments["post"];
    super.onInit();
  }

  @override
  void onReady() async {
    // update();
    // print("加载完成");
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    print("控制器被释放");
    super.onClose();
  }
}
