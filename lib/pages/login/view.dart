import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'index.dart';
import '../../routes/app_pages.dart';
import '../../extensions/index.dart';
import '../../servie/index.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../common/index.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:barcode_widget/barcode_widget.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  Widget formBody2() {
    return Form(
      key: controller.formKey,
      child: formBody(),
    );
  }

  Widget formBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextFormField(
          controller: controller.usernameController,
          onChanged: (value) => controller.accountChange(value),
          style: const TextStyle(
            fontSize: 14.0, // 设置字体大小
          ),
          decoration: const InputDecoration(
            fillColor: Colors.white,
            contentPadding: EdgeInsets.all(10.0),
            // label: Text(
            //   '電話號碼',
            // ),
            hintText: '用戶名稱',
            hintStyle: TextStyle(color: Color(0xFFC1C1C1)),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),

            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.all(Radius.circular(30))),
            filled: true,
            prefixIcon: Icon(
              Icons.phone_in_talk,
              color: Color(0xFF58C5E6),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '请输入用戶名稱';
            }
            return null;
          },
        ),
        const SizedBox(
          height: 16,
        ),
        TextFormField(
          controller: controller.passwordController,
          onChanged: (value) => controller.passwordChange(value),
          obscureText: true,
          style: const TextStyle(
            fontSize: 14.0, // 设置字体大小
          ),
          decoration: const InputDecoration(
            fillColor: Colors.white,
            contentPadding: EdgeInsets.all(10.0),
            hintText: '密碼',
            hintStyle: TextStyle(color: Color(0xFFC1C1C1)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
            border: OutlineInputBorder(
                gapPadding: 2,
                borderSide: BorderSide(
                  color: Colors.white,
                ),
                borderRadius: BorderRadius.all(Radius.circular(30))),
            filled: true,
            prefixIcon: Icon(
              Icons.lock,
              color: Color(0xFF58C5E6),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '请输入密碼';
            }
            return null;
          },
        ),
        const SizedBox(
          height: 16,
        ),
        Row(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              controller.state.remember
                  ? Icons.check_box
                  : Icons.check_box_outline_blank,
              size: 20,
              color: Colors.white,
            ).onTap(() => controller.toggleRemember()),
            // SvgPicture.asset(
            //   'assets/svg/boxcheck.svg',
            //   width: 16,
            //   height: 16,
            // ),

            tex('記住帳號', fontSize: 14)
                .onTap(() => controller.toggleRemember())
                .expand(),
            tex('忘記密碼?', color: Colors.white)
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        controller.state.isLoading
            ? const CircularProgressIndicator(
                color: Color(0xFF0080CE),
                strokeWidth: 2,
              ).center()
            : commonSubmit('登入', onTap: controller.submit),
      ],
    ).container(
        padding: const EdgeInsets.all(32),
        margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: const BoxDecoration(
          color: Color(0xFF58C5E6),
          // border: Border.all(color: const Color(0xFF58C5E6), width: 2),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ));
  }

  Widget bodyContent() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 120, 16, 0),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          tex('會員登入',
              fontSize: 28,
              color: const Color(0xFF55BDB9),
              fontWeight: FontWeight.bold),
          formBody().form(
            key: controller.formKey,
          ),
        ],
      ),
    );
  }

  Widget body2() {
    return bodyContent().scrollable().container(
          height: Get.context!.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bg.png'), // 替换为你的图片路径
              fit: BoxFit.cover, // 背景图片铺设模式
            ),
          ),
        );
  }

  Widget body() {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/bg.png',
            fit: BoxFit.cover,
          ),
        ),
        Positioned(child: bodyContent()),
      ],
    );
  }

  AppBar appBar() {
    return AppBar(
      centerTitle: true,
      title: const Text('會員登入'),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final state = controller.state;
    return GetBuilder<LoginController>(
      init: LoginController(),
      id: 'login',
      builder: (controller) {
        return Scaffold(
            key: controller.scaffoldKey,
            appBar: appBar(),
            // endDrawer: menuEndDrawer(),
            // onEndDrawerChanged: (isOpened) => closeMenu(isOpened),
            // drawerScrimColor: Colors.transparent,
            // endDrawerEnableOpenDragGesture: false,
            // drawerEnableOpenDragGesture: false,
            body: body());
      },
    );
  }
}
