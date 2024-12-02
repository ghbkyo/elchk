import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import '../../extensions/ex_widget.dart';
import '../../servie/index.dart';
import 'state.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import '../../routes/app_pages.dart';
import '../../utils/index.dart';

class PaymentController extends GetxController {
  PaymentController();

  String uiKey = 'payment';

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GetPaymentState state = GetPaymentState();
  final TextEditingController accountController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  void createTx() async {
    var body = {
      "memberInfoId": currentMemberId,
      "gender": 'F',
      "name": accountController.text,
      "telMobile": phoneController.text,
    };
    state.isLoading = true;
    update([uiKey]);
    String apiUrl = 'MemberCompanion/Create';

    dynamic res = await ApiService.post(apiUrl, data: body);
    state.isLoading = false;
    update([uiKey]);
    if (res != null) {
      await loadTx();
      accountController.text = '';
      phoneController.text = '';
    }
  }

  Future loadTx() async {
    var params = {
      "MemberInfoId": currentMemberId,
    };

    String apiUrl = 'MemberCompanion/GetMemberCompanions';
    dynamic res = await ApiService.post(apiUrl, data: params);
    state.txList.clear();
    // print(res);
    if (res != null) {
      state.txList.addAll(res);
      update([uiKey]);
    }
  }

  void deleteTx(int id) {
    showDialog<void>(
      context: Get.context!,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          // title: const Text('確定刪除嘛？'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('是否確定刪除同行者?'),
                // Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('取消'),
              onPressed: () {
                Get.back();
                // Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('删除'),
              onPressed: () {
                removeTx(id);
                // Get.back();
                // Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void removeTx(int id) async {
    if (state.txIds.contains(id)) {
      state.txIds.remove(id);
    }
    update([uiKey]);

    var body = {
      "memberCompanionId": id,
    };
    String apiUrl = 'MemberCompanion/Delete';

    dynamic res = await ApiService.post(apiUrl, data: body);

    if (res != null) {
      int index = 0;
      for (var item in state.txList) {
        int itemId = item['id'];
        if (id == itemId) {
          break;
        }
        index += 1;
      }
      state.txList.removeAt(index);
      update([uiKey]);
      Get.back();
    }
  }

  void msgDialogClose() {
    state.dialogStatus = false;
    state.dialogType = 0;
    update([uiKey]);
  }

  void msgDialogShow(String title) {
    state.dialogText = title;
    state.dialogStatus = true;
    update([uiKey]);
  }

  @override
  void dispose() {
    accountController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Future join() async {
    var params = {
      "memberInfoId": currentMemberId,
      "programInfoId": state.post['id'],
      "remarks": '',
      "allowPhotography": true,
      "programSessionIds": state.payType,
      "memberCompanionIds": state.txIds,
      "nonMemberCompanions": [],
    };

    state.isLoading = true;
    update([uiKey]);

    String apiUrl = 'ProgramEnrollment/Create';
    dynamic res = await ApiService.post(apiUrl, data: params);
    // eg:  {programEnrollmentId: 191474, accountReceivableId: 1965, accountReceivablePaymentItems: [{accountReceivableItemId: 2248, amount: 0.0}], result: OK, errors: null, status: 200}
    state.isLoading = false;
    update([uiKey]);
    if (res != null) {
      state.joinRes = res;
      String orderNo =
          '${res['accountReceivableId']}A${res['accountReceivablePaymentItems'][0]['accountReceivableItemId']}';
      Get.toNamed(Routes.PAY, arguments: {
        'target': 'payment',
        'order_no': orderNo,
        'amount': state.fee,
        'id': state.post['id']
      });
      // state.dialogType = 2;
      // update([uiKey]);
    } else {
      msgDialogShow('報名失敗\n請檢查活動時間\n');
      return;
    }
  }

  void changeStepIndex(int index) {
    if (index == 1) {
      if (state.payType.isEmpty) {
        msgDialogShow('[場次]不能留空');
        return;
      }
      int maximunNumberOfCompanions = state.post['maximunNumberOfCompanions'];
      if (state.txIds.length > maximunNumberOfCompanions) {
        msgDialogShow('[同行人]最多可選擇 $maximunNumberOfCompanions 人');
        return;
      }

      // 计算费用
      var programSessions = state.post['programSessions'];
      state.fee = 0;
      for (var item in programSessions) {
        int id = item['id'];

        bool checked = state.payType.contains(id);
        if (checked) {
          state.fee += item['amount'];
        }
      }
      int memberNum = state.txIds.length + 1;
      state.fee = state.fee * memberNum;
    } else if (index == 2 && state.payModeId == 0) {
      msgDialogShow('請選擇付款方式');
      return;
    }

    state.shipStep = index;
    update([uiKey]);
  }

  void changePayType(int index) {
    if (state.payType.contains(index)) {
      state.payType.remove(index);
    } else {
      state.payType.add(index);
    }

    update([uiKey]);
  }

  void changeIds(int index) {
    if (state.txIds.contains(index)) {
      state.txIds.remove(index);
    } else {
      state.txIds.add(index);
    }
    update([uiKey]);
  }

  // void changePayMode(String index) {
  //   state.payMode = index;
  //   update([uiKey]);
  // }

  void changePayMode(int payModeId, String payModeName) {
    state.payModeId = payModeId;
    state.payModeName = payModeName;
    update([uiKey]);
  }

  void dialogShow(int type) {
    state.dialogType = type;
    update([uiKey]);
  }

  Future loadPaymentMethod() async {
    // var params = {"MemberInfoId": currentMemberId, 'CenterId': centerId};
    String data = 'ComCenterId=$centerId&BoundType=InBound&IsEnabled=true';
    String apiUrl = 'PaymentMethod';
    // print(apiUrl);
    dynamic res = await ApiService.get(apiUrl, data: data);
    if (res != null) {
      state.paymentMethods = res;
      update([uiKey]);
    }
  }

  int centerId = 0;
  int currentMemberId = 0;
  @override
  void onInit() async {
    state.post = Get.arguments["post"];
    currentMemberId = AuthService.memberData[AuthService.memberIndex]['id'];
    centerId = AuthService.memberData[AuthService.memberIndex]['center']['id'];
    await loadTx();
    await loadPaymentMethod();
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
