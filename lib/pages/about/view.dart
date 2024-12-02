import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'index.dart';
import '../../routes/app_pages.dart';
import '../../extensions/index.dart';
import '../../servie/index.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../common/index.dart';

class AboutPage extends GetView<AboutController> {
  const AboutPage({super.key});

  Widget bodyContent() {
    String content =
        '基督教香港信義會社會服務部自1976年成立，是香港大型的综合性社會服務機構，以創新的方式、關愛及以人為本的精神為基層及弱勢社群提供多元化的服務·本機構現時共有超通50個服務單位及50個特别計劃，服務範圍遍饰全港，由幼兒到長者，從家庭、學校以至場，每年服務接近二百萬人次。\n\n近年，本機構以創新手法關懐弱勢社群為服務目標，推出多项特別项目及創新计劃，其中包括：\n\n特别项目\n葯天中醫服務一由機構註冊中醫師為市民提供中醫至科、針灸診治服務。屯門地區康健中心 -本機構營運的大型地區基層醫療项目，以科技結合服務，為香港市民提供多項基層醫療健康服務，包括健康推廣、健康评估、慢性疾病管理和社區復康服務等。新田部屋通渡性房屋計劃 -為基層提供短期住宿，並配合全面的社會服务，包括照顧者支援、健康護理、職業技能培訓等，幫助住戶建立新生活及规劃未來。';

    return Text(
      content,
      style: const TextStyle(
        fontSize: 16,
        color: Colors.black,
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
        Positioned(
            top: 16,
            left: 16,
            right: 16,
            bottom: 16,
            child: bodyContent().container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFF58C4E6), width: 2),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ))),
      ],
    );
  }

  AppBar appBar() {
    return AppBar(
      centerTitle: true,
      title: const Text('關於我們'),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final state = controller.state;
    return GetBuilder<AboutController>(
      init: AboutController(),
      id: 'about',
      builder: (controller) {
        return Scaffold(
            key: controller.scaffoldKey,
            // endDrawer: menuEndDrawer(),
            appBar: appBar(),
            // onEndDrawerChanged: (isOpened) => closeMenu(isOpened),
            // drawerScrimColor: Colors.transparent,
            // endDrawerEnableOpenDragGesture: false,
            // drawerEnableOpenDragGesture: false,
            body: body());
      },
    );
  }
}
