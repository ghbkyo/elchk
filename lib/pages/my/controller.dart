import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_elchk/main.dart';
import 'package:get/get.dart' hide Response;
import '../../extensions/ex_widget.dart';
import '../../servie/index.dart';
import 'state.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import '../../routes/app_pages.dart';
import '../../utils/index.dart';

class MyController extends GetxController {
  MyController();

  String uiKey = 'my';

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GetMyState state = GetMyState();
  final formKey = GlobalKey<FormState>();
  final txFormKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  final TextEditingController accountController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController contactNameController = TextEditingController();
  final TextEditingController contactPhoneController = TextEditingController();
  final TextEditingController accounNoController = TextEditingController();
  final TextEditingController accounPhoneController = TextEditingController();

  final TextEditingController txNameController = TextEditingController();
  final TextEditingController txPhoneController = TextEditingController();

  final ScrollController goldScrollController = ScrollController();
  final ScrollController tradeScrollController = ScrollController();

  int page = 1;
  int totalRows = 0;
  int totalPage = 0;
  int pageSize = 10;

  void scrollListener() {
    if (goldScrollController.position.pixels ==
        goldScrollController.position.maxScrollExtent) {
      getMore();
    }
  }

  Future loadList() async {
    // if (page >= 2 && page > totalPage) {
    //   Get.snackbar('友情提示', "沒有更多數據");
    //   return;
    // }

    // if (state.isLoading) return;
    // state.isLoading = true;
    // update([uiKey]);
    page = 1;
    var params = {
      "CenterId": state.memberInfo['center']['id'],
      "MemberInfoId": state.memberInfo['id'],
      "pageNumber": page,
      "pageSize": 999,
      "OrderBy": 'id',
      "PaymentType": 'Point',
      "IsOrderByAsc": false,
    };

    final paramsStr = params.entries
        .map((entry) =>
            '${Uri.encodeComponent(entry.key)}=${Uri.encodeComponent(entry.value.toString())}')
        .join('&');

    String apiUrl = 'MemberInfo/GetMemberPaymentRecordQuery?$paramsStr';

    dynamic res = await ApiService.get(apiUrl);
    state.list.clear();
    if (res != null) {
      // print(res);
      totalRows = res['totalCount'];
      totalPage = res['totalPages'];
      var items = res['items'];
      state.list.addAll(items);
      page += 1;
      state.isLoading = false;
      update([uiKey]);
    }
  }

  Future loadPaymentList() async {
    page = 1;
    var params = {
      "CenterId": state.memberInfo['center']['id'],
      "MemberInfoId": state.memberInfo['id'],
      "pageNumber": page,
      "pageSize": 999,
      "OrderBy": 'id',
      "PaymentType": 'Cash',
      "IsOrderByAsc": false,
    };

    final paramsStr = params.entries
        .map((entry) =>
            '${Uri.encodeComponent(entry.key)}=${Uri.encodeComponent(entry.value.toString())}')
        .join('&');

    String apiUrl = 'MemberInfo/GetMemberPaymentRecordQuery?$paramsStr';

    dynamic res = await ApiService.get(apiUrl);
    state.paymentList.clear();
    if (res != null) {
      // print(res);
      totalRows = res['totalCount'];
      totalPage = res['totalPages'];
      var items = res['items'];
      state.paymentList.addAll(items);
    }
  }

  void getMore() {
    // isLoading = true;
    // update();
    loadList();
  }

  void loadInfo() {
    // dynamic member = await ApiService.get('MemberInfo');
    dynamic member = AuthService.memberData;
    int memberIndex = AuthService.memberIndex;
    if (member != null) {
      state.memberCenter = member;
      state.memberIndex = memberIndex;
      var memberInfo = member[memberIndex];
      state.isLoading = false; // 显示加载状态
      state.memberInfo = memberInfo;
      accountController.text = memberInfo['nameZH']['fullName'];
      firstNameController.text = memberInfo['nameZH']['firstName'];
      lastNameController.text = memberInfo['nameZH']['lastName'];
      phoneController.text = memberInfo['telMobile'];
      emailController.text = memberInfo['email'];
      addressController.text = memberInfo['addressRemarks'] ?? '';
      update([uiKey]);
    }
  }

  void changeMember(int id) {
    int index = 0;
    for (var item in state.memberCenter) {
      if (id == item['id']) {
        break;
      }
      index += 1;
    }
    print(index);

    state.memberIndex = index;
    AuthService.setMemberIndex(index);
    var memberInfo = state.memberCenter[index];
    state.memberInfo = memberInfo;
    accountController.text = memberInfo['nameZH']['fullName'] ?? '';
    firstNameController.text = memberInfo['nameZH']['firstName'] ?? '';
    lastNameController.text = memberInfo['nameZH']['lastName'] ?? '';
    phoneController.text = memberInfo['telMobile'] ?? '';
    emailController.text = memberInfo['email'] ?? '';
    addressController.text = memberInfo['addressRemarks'] ?? '';
    update([uiKey]);
  }

  @override
  void onInit() async {
    loadInfo();
    // loadPaymentList();
    // loadList();
    goldScrollController.addListener(scrollListener);

    // txNameController.text = "abc";
    // txPhoneController.text = "18023";

    super.onInit();
  }

  void submit() async {
    if (formKey.currentState!.validate()) {
      // controller.provide();
      //log('validate');
      // final username = usernameController.text.trim();
      // final password = passwordController.text.trim();
      // login(username, password);

      var body = {
        "memberInfoId": state.memberInfo['id'],
        "firstNameZH": firstNameController.text,
        "lastNameZH": lastNameController.text,
        "email": emailController.text,
        "telMobile": phoneController.text,
        "address": addressController.text,
      };
      state.isLoading = true;
      update([uiKey]);
      String apiUrl = 'MemberInfo/Update';

      dynamic res = await ApiService.post(apiUrl, data: body);
      state.isLoading = false;
      update([uiKey]);
      if (res != null) {
        dynamic member = await ApiService.get('MemberInfo');
        if (member != null) {
          state.memberCenter = member;
          var memberInfo = member[state.memberIndex];
          state.memberInfo = memberInfo;
          AuthService.setMemberData(member);
          changeTypeShow(0);
        }
        //print(res);
      }
    }
  }

  void changeIndex(int index) {
    state.currentIndex = index;
    update([uiKey]);
  }

  void dialogShow(int type) {
    state.dialogType = type;
    update([uiKey]);
  }

  @override
  void dispose() {
    goldScrollController.removeListener(scrollListener);
    goldScrollController.dispose();
    tradeScrollController.removeListener(scrollListener);
    tradeScrollController.dispose();
    accountController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    contactNameController.dispose();
    contactPhoneController.dispose();
    accounNoController.dispose();
    accounPhoneController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    txNameController.dispose();
    txPhoneController.dispose();
    super.dispose();
  }

  void submitTx() {
    if (txFormKey.currentState!.validate()) {
      createTx();
    }
  }

  void cancelTx() {
    state.txAdd = false;
    update([uiKey]);
  }

  void createTxShow() {
    print('createTxShow');
    state.txAdd = true;
    update([uiKey]);
  }

  void createTx() async {
    var body = {
      "memberInfoId": state.memberInfo['id'],
      "gender": 'F',
      "name": txNameController.text,
      "telMobile": txPhoneController.text,
    };
    state.isLoading = true;
    update([uiKey]);
    String apiUrl = 'MemberCompanion/Create';

    dynamic res = await ApiService.post(apiUrl, data: body);

    if (res != null) {
      await loadTx();
      txNameController.text = '';
      txPhoneController.text = '';
      state.isLoading = false;
      state.txAdd = false;
      update([uiKey]);
    }
  }

  Future loadTx() async {
    var params = {
      "MemberInfoId": state.memberInfo['id'],
    };

    String apiUrl = 'MemberCompanion/GetMemberCompanions';
    dynamic res = await ApiService.post(apiUrl, data: params);
    state.txList.clear();
    if (res != null) {
      state.txList.addAll(res);
    }
  }

  Future loadLog() async {
    await loadPaymentList();
    await loadList();
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

  void changeTypeShow(int type) async {
    state.showType = type;
    if (type == 2) {
      await loadTx();
    }
    if (type == 3) {
      await loadLog();
    }
    update([uiKey]);
  }

  // @override
  // void onInit() async {
  //   // animationCcontroller =
  //   // AnimationC
  //   //ontroller(duration: const Duration(seconds: 2), vsync: this);
  //   accountController.text = "會員名稱01";
  //   // print("onInit 加载完成");
  //   super.onInit();
  // }

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
