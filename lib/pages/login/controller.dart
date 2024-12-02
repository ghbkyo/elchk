import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_elchk/pages/index.dart';
import 'package:get/get.dart' hide Response;
import '../../extensions/ex_widget.dart';
import '../../servie/index.dart';
import 'state.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import '../../routes/app_pages.dart';
import '../../utils/index.dart';
import '../initial/controller.dart';

class LoginController extends GetxController {
  LoginController();

  String uiKey = 'login';

  final formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GetLoginState state = GetLoginState();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  void onInit() {
    // if (AuthService.isLogin) {
    //   Get.offAll(const InitialPage());
    //   return;
    // }
    usernameController.text = 'petertse';
    usernameController.text = 'TTT003';
    passwordController.text = 'Password123';
    bool remember = AuthService.remember;
    if (remember) {
      state.remember = AuthService.remember;
      usernameController.text = DB.getString('login_account');
      passwordController.text = DB.getString('login_password');
    }
    super.onInit();
  }

  void submit() {
    if (formKey.currentState!.validate()) {
      // controller.provide();
      //log('validate');
      final username = usernameController.text.trim();
      final password = passwordController.text.trim();
      login(username, password);
    }
  }

  void accountChange(String? val) {
    bool flag = AuthService.remember;
    if (flag && val != null) {
      DB.set('login_account', val);
    }
  }

  void passwordChange(String? val) {
    bool flag = AuthService.remember;
    if (flag && val != null) {
      DB.set('login_password', val);
    }
  }

  void toggleRemember() {
    bool flag = !AuthService.remember;
    state.remember = flag;
    AuthService.setRemember(flag);
    if (flag) {
      DB.set('login_account', usernameController.text.trim());
      DB.set('login_password', passwordController.text.trim());
    } else {
      DB.remove('login_account');
      DB.remove('login_password');
    }
    update([uiKey]);
  }

  void changeRemember(bool flag) {
    state.remember = flag;
    update([uiKey]);
  }

  // 登录逻辑
  Future<void> login(String username, String password) async {
    state.isLoading = true; // 显示加载状态
    update([uiKey]);
    try {
      dynamic data = await ApiService.login(username, password);
      state.isLoading = false; // 显示加载状态
      update([uiKey]);
      if (data != null) {
        String token = data['access_token'];
        AuthService.login(token);
        // print(token);
        // 获取会员信息
        dynamic member = await ApiService.get('MemberInfo');
        // print('member:');
        // print(member);

        if (member != null) {
          // 更新 registrationId
          String registrationId = 'test_id';
          dynamic registration = await ApiService.post(
              'MemberInfo/UpdateRegistrationId',
              data: {'registrationId': registrationId});
          print(registrationId);
          print(registration);

          AuthService.setMember(member, 0);
          Get.offAll(const InitialPage());
          return;
        }
        final home = Get.find<InitialController>();
        home.update(['initial']);
      } else {
        Get.snackbar('輸入錯誤', '賬號或密碼錯誤');
      }
    } catch (error) {
      // 捕获其他异常，例如网络错误等
      // print('异常捕获: $error');
      Get.snackbar('服务器错误', '未知错误');
    } finally {
      // 隐藏加载状态
    }
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
