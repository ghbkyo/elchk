import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import '../../extensions/ex_widget.dart';
import '../../servie/index.dart';
import 'state.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import '../../routes/app_pages.dart';
import '../../utils/index.dart';
import 'package:intl/intl.dart';

class MembershipController extends GetxController {
  MembershipController();

  String uiKey = 'membership';

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GetMembershipState state = GetMembershipState();

  void changeStepIndex(int index) {
    if (index == 1 && state.payTypeId == 0) {
      msgDialogShow('請選擇會籍');
      return;
    } else if (index == 2 && state.payModeId == 0) {
      msgDialogShow('請選擇付款方式');
      return;
    }
    state.shipStep = index;
    update([uiKey]);
  }

  void changePayType(int id, double fee, String payTypeName) {
    state.payTypeId = id;
    state.fee = fee;
    state.payTypeName = payTypeName;
    update([uiKey]);
  }

  void changePayMode(int payModeId, String payModeName) {
    state.payModeId = payModeId;
    state.payModeName = payModeName;
    update([uiKey]);
  }

  void dialogShow(int type) async {
    if (type == 2) {
      var body = {
        "memberInfoId": currentMemberId,
        "memberTypeId": state.payTypeId,
        "expiryDate": state.memberRenewInfoQuery['expiryDate'],
        "startChargeDate": state.memberRenewInfoQuery['startChargeDate'],
        "startDate": state.memberRenewInfoQuery['startDate'],
      };
      String apiUrl = 'Membership';

      dynamic res = await ApiService.post(apiUrl, data: body);

      if (res == null) {
        msgDialogShow('會員續會失敗');
        return;
      } else {
        // showPaySuccess();
        int accountReceivableId = res['accountReceivableId'];
        int accountReceivableItemId =
            res['accountReceivablePaymentItems'][0]['accountReceivableItemId'];
        double totalAmount = res['accountReceivablePaymentItems'][0]['amount'];
        String orderNo = '${accountReceivableId}A$accountReceivableItemId';
        Get.toNamed(Routes.PAY, arguments: {
          'target': 'membership',
          'order_no': orderNo,
          'amount': totalAmount,
          'id': accountReceivableId
        });
      }
    }

    state.dialogType = type;
    update([uiKey]);
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

  void closePaySuccess() {
    // state.payStatus = false;
    state.dialogType = 0;
    update([uiKey]);
  }

  void showPaySuccess() {
    // state.payStatus = true;
    state.dialogType = 2;
    update([uiKey]);
  }

  int currentMemberId = 0;
  int centerId = 0;
  Future load() async {
    // var params = {"MemberInfoId": currentMemberId, 'CenterId': centerId};
    String data = 'memberInfoId=$currentMemberId&CenterId=$centerId';
    String apiUrl = 'MemberInfo/GetMemberRenewInfoQuery';
    // print(apiUrl);
    dynamic res = await ApiService.get(apiUrl, data: data);
    if (res != null) {
      state.memberRenewInfoQuery = res;
      update([uiKey]);
    }
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

  @override
  void onInit() async {
    currentMemberId = AuthService.memberData[AuthService.memberIndex]['id'];
    centerId = AuthService.memberData[AuthService.memberIndex]['center']['id'];

    state.centerName =
        AuthService.memberData[AuthService.memberIndex]['center']['nameZH'];

    String expiryDate =
        AuthService.memberData[AuthService.memberIndex]['expiryDate'];

    DateTime endDateTime = DateTime.parse(expiryDate);
    endDateTime = endDateTime.add(const Duration(hours: 8));

    state.expiryDate = DateFormat('dd/MM/yyyy').format(endDateTime);
    await load();
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
