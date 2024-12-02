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
import 'package:intl/intl.dart';

class NoticePage extends GetView<NoticeController> {
  const NoticePage({super.key});

// status 1 狀態更新 2 活動更新 3  會籍到期提示
  Widget noticeItemBody(
    String txt,
    String date, {
    String? noticeType,
    bool dot = false,
  }) {
    Color color = const Color(0xFFCDD311);
    String statusText = '狀態更新';
    if (noticeType == '001') {
      color = const Color(0xFFEB6685);
      statusText = '活動更新';
    } else if (noticeType == '003') {
      color = const Color(0xFFF9B300);
      statusText = '會籍到期提示';
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(top: 4),
          width: 20,
          child: dot
              ? const Icon(
                  Icons.pending,
                  color: Colors.red,
                  size: 16,
                )
              : const SizedBox(),
          // ? SvgPicture.asset(
          //     'assets/svg/dot.svg',
          //     width: 12,
          //     height: 12,
          //   )
        ),
        const SizedBox(
          width: 5,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            tex(txt, fontSize: 14, fontWeight: FontWeight.bold),
            tex(date, fontSize: 12, color: const Color(0xFF6C6C6C))
          ],
        ).expand(),
        const SizedBox(
          width: 5,
        ),
        tex(statusText, fontSize: 12, color: color),
      ],
    ).container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFF58C4E6), width: 2),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ));
  }

  List<Widget> list() {
    List<Widget> widgetList = [];

    Widget hr = const SizedBox(
      height: 12,
    );

    for (var item in controller.state.list) {
      DateTime parsedTime = DateTime.parse(item['created']);
      String formattedTime =
          DateFormat('yyyy-MM-dd HH:mm:ss').format(parsedTime);
      bool dot = !item['isMarkRead'];

      widgetList.add(
        noticeItemBody(item['title'], formattedTime,
            noticeType: item['noticeType'], dot: dot),
      );
      widgetList.add(
        hr,
      );
    }
    return widgetList;
  }

  Widget bodyContent() {
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (controller.state.list.isEmpty)
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                controller.state.isLoading ? '加载中' : '没有数据',
                style: const TextStyle(color: Colors.grey),
              ),
            ),
          // Expanded(child: list()),
          ...list(),
          if (controller.state.isLoading)
            const CircularProgressIndicator().container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              width: 40,
              height: 40,
            ),
        ],
      ),
    );
  }

  Widget body() {
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

  AppBar appBar() {
    return AppBar(
      centerTitle: true,
      title: const Text('我的通知'),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final state = controller.state;
    return GetBuilder<NoticeController>(
      init: NoticeController(),
      id: 'notice',
      builder: (controller) {
        return Scaffold(
            key: controller.scaffoldKey,
            appBar: appBar(),
            floatingActionButton: controller.state.isBackTop
                ? FloatingActionButton(
                    onPressed: () => controller.backTop(),
                    child: const Icon(Icons.arrow_upward))
                : null,
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
