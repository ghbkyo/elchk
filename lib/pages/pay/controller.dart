import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_elchk/pages/membership/controller.dart';
import 'package:get/get.dart' hide Response;
import '../../extensions/ex_widget.dart';
import '../../servie/index.dart';
import 'state.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import '../../routes/app_pages.dart';
import '../../utils/index.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:typed_data';
import '../myevent/index.dart';
import '../payment/index.dart';

class PayController extends GetxController {
  PayController();

  String uiKey = 'pay';

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GetPayState state = GetPayState();

  late WebViewController webController;

  /// 隱藏 HTML 中的特定元素
  Future<void> _hideHtmlElement() async {
    const jsCode = '''
      document.querySelector('.cancel_area').style.display = 'none';
    ''';
    await webController.runJavaScript(jsCode); // 執行 JavaScript
  }

  String target = '';
  @override
  void onInit() {
    target = Get.arguments["target"];
    String orderNo = Get.arguments["order_no"];
    double amount = Get.arguments["amount"] ?? 0;
    int id = Get.arguments["id"];

    var member = AuthService.memberData[AuthService.memberIndex];

    String notifyUrl = 'https://4s-member-sit.elchk.org.hk/program/detail/$id';
    if (target == 'membership') {
      notifyUrl = 'https://4s-member-sit.elchk.org.hk/other/account/upgrade';
    }

    final postData = {
      "username": member['nameZH']['fullName'],
      'sandbox': 1,
      'order_nubmer': orderNo,
      'currency': 'HKD',
      'language': 'zh_HK',
      'first_name': member['nameZH']['firstName'],
      'last_name': member['nameZH']['lastName'],
      'email': member['email'],
      'phone': member['telMobile'],
      'address_1': member['addressRemarks'],
      'address_2': '',
      'city': '',
      'state': '',
      'country': '',
      'postcode': '',
      'amount': amount,
      'merchant_id': '2',
      'notify_url': notifyUrl
    };

    print(postData);

    // 將 POST 數據轉換為 application/x-www-form-urlencoded 格式
    final encodedData = postData.entries
        .map((e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value.toString())}')
        .join('&');

    webController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            _hideHtmlElement();
          },
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            // back https://4s-member-sit.elchk.org.hk
            // back https://testsecureacceptance.cybersource.com/billing
            if (request.url.startsWith('https://4s-member-sit.elchk.org.hk')) {
              if (target == 'myevent') {
                final event = Get.find<MyeventController>();
                event.state.payStatus = true;
                event.state.dialogStatus = false;
                event.state.dialogType = 0;
                event.update(['myevent']);
              }

              if (target == 'membership') {
                final event = Get.find<MembershipController>();
                event.showPaySuccess();
              }

              if (target == 'payment') {
                final event = Get.find<PaymentController>();
                // event.state.payStatus = true;
                event.state.dialogStatus = false;
                event.state.dialogType = 2;
                event.update(['payment']);
              }
              Get.back();
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(
        Uri.parse('https://sf.gogo2hk.com/cybersource2.php?act=payment'),
        method: LoadRequestMethod.post,
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: Uint8List.fromList(encodedData.codeUnits),
      );

    // /// 隱藏 HTML 中的 `.submit` 按鈕
    // Future<void> hideSubmitButton() async {
    //   await webController.runJavaScript(jsCode); // 執行 JavaScript
    // }

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
