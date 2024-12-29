import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:get/get_connect/sockets/src/socket_notifier.dart';
import 'index.dart';
import '../../routes/app_pages.dart';
import '../../extensions/index.dart';
import '../../servie/index.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../common/index.dart';
import 'dart:convert';
import 'dart:typed_data';

class RemarkPage extends GetView<RemarkController> {
  const RemarkPage({super.key});

  Widget topContent(
    int postId,
    String title, {
    String? imageUrl,
    bool collect = false,
  }) {
    ImageProvider imageProvider = const AssetImage('assets/images/logo.jpg');
    if (imageUrl != null) {
      Uint8List bytes = base64Decode(imageUrl);
      imageProvider = MemoryImage(bytes);
    }

    return Container(
      width: double.infinity, // 指定图片的宽度
      height: 200,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: imageProvider, //动态
          fit: BoxFit.fitHeight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(child: SizedBox()),
              SvgPicture.asset(
                      collect
                          ? 'assets/svg/collected-item.svg'
                          : 'assets/svg/collect-item.svg',
                      width: 40,
                      height: 40)
                  .onTap(() {
                controller.collectTap();
              }),
              const SizedBox(
                width: 10,
              ),
              SvgPicture.asset('assets/svg/share-item.svg',
                      width: 40, height: 40)
                  .onTap(() {
                share(
                    'https://4s-member-sit.elchk.org.hk/program/detail/$postId',
                    title);
              })
            ],
          ).container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
          const Expanded(child: SizedBox()),
          tex(
            title,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ).container(
              color: const Color(0xFF55BDB9),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16)),
        ],
      ),
    );
  }

  Widget remarkItem(String txt, String svg) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 20,
          child: SvgPicture.asset(
            'assets/svg/remark-$svg.svg',
            width: 20,
            height: 20,
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        tex(txt, fontSize: 14),
      ],
    );
  }

  Widget content() {
    return tex(controller.state.post['introduction'] ?? '');
  }

  Widget itemButton({bool close = false}) {
    Color color = const Color(0xFFFA9600);
    String txt = '報名';
    if (close) {
      color = const Color(0xFF848484);
      txt = '不接受網上報名';
    }
    return tex(txt,
            textAlign: TextAlign.center,
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold)
        .container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.symmetric(horizontal: 32),
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.all(Radius.circular(30)),
            ));
  }

  Widget bodyContent() {
    Widget hr = const SizedBox(
      height: 10,
    );

    return Column(
      children: [
        topContent(controller.state.post['id'], controller.state.post['name'],
            imageUrl: controller.state.post['imageUrl'],
            collect: controller.state.post['hasBookmark']),
        Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (controller.state.post['tag'] != null)
                tex(
                  controller.state.post['tag'],
                  fontSize: 14,
                  // fontWeight: FontWeight.bold,
                  // color: Colors.white,
                ),
              hr,
              remarkItem('活動日期：${controller.state.post['date']}', 'date'),
              hr,
              remarkItem('活動時間：${controller.state.post['time']}', 'time'),
              hr,
              remarkItem('活動對象：', 'user'),
              hr,
              remarkItem(
                  '活動人數：${controller.state.post['memberNums']}人', 'user'),
              hr,
              remarkItem('活動場地：${controller.state.post['address']}', 'address'),
              hr,
              remarkItem('費用：${controller.state.post['isFree'] ? '免费' : '收费'}',
                  'money'),
              hr,
              remarkItem('報名時段：', 'time'),
              hr,
              tex(
                '活動內容',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ).container(
                  color: const Color(0xFF58C5E6),
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 16)),
              content().container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFF58C5E6),
                    ),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 16)),
              hr,
              tex('成功報名後，不會發放收據。',
                      fontSize: 12,
                      color: const Color(0xFF909090),
                      textAlign: TextAlign.center)
                  .center(),
              tex(
                '如需收據，請親自到中心向職員索取。',
                fontSize: 12,
                color: const Color(0xFF909090),
              ).center(),
              hr,
              if (controller.state.post['isOnline'])
                itemButton().onTap(() => controller.join()),
              if (!controller.state.post['isOnline']) itemButton(close: true),
            ],
          ),
        )
      ],
    );
  }

  Widget body() {
    return bodyContent().scrollable();
  }

  Widget dialog() {
    return Column(
      children: [eventDialog()],
    );
  }

  Widget dialogBtn(
    String txt, {
    bool close = false,
  }) {
    return tex(txt,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            textAlign: TextAlign.center)
        .container(
            width: 100,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            decoration: BoxDecoration(
              color: close ? const Color(0xFF55BDB9) : const Color(0xFFFA9600),
              borderRadius: const BorderRadius.all(Radius.circular(30)),
            ));
  }

  Widget eventCancelDialog() {
    return Column(
      children: [
        SvgPicture.asset('assets/svg/info.svg',
            width: 50, height: 50, fit: BoxFit.cover),
        const SizedBox(
          height: 32,
        ),
        tex(controller.state.dialogText,
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            textAlign: TextAlign.center),
        const SizedBox(
          height: 20,
        ),
        dialogBtn('確認').onTap(() => controller.dialogClose()),
        // const SizedBox(
        //   height: 10,
        // ),
        // dialogBtn('否', close: true).onTap(() {
        //   // controller.eventDialogClose();
        // }),
      ],
    );
  }

  Widget eventCancelConfirmDialog() {
    return Column(
      children: [
        SvgPicture.asset('assets/svg/info.svg',
            width: 50, height: 50, fit: BoxFit.cover),
        const SizedBox(
          height: 32,
        ),
        tex(controller.state.dialogText,
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            textAlign: TextAlign.center),
        const SizedBox(
          height: 20,
        ),
        dialogBtn('是').onTap(() => controller.joinNext()),
        const SizedBox(
          height: 10,
        ),
        dialogBtn('否', close: true).onTap(() => controller.dialogClose()),
      ],
    );
  }

  Widget eventDialog() {
    Widget wg = eventCancelDialog();
    if (controller.state.dialogType == 2) {
      wg = eventCancelConfirmDialog();
    }
    // if (controller.state.dialogType == 2) {
    //   wg = eventCancelConfirmDialog();
    // } else if (controller.state.dialogType == 3) {
    //   wg = eventRejectDialog();
    // } else if (controller.state.dialogType == 4) {
    //   return qrCodeDialog().scrollable();
    // }
    return wg.container(
        padding: const EdgeInsets.all(32),
        margin: const EdgeInsets.all(32),
        decoration: const BoxDecoration(
          color: Color(0xFF0080CE),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ));
  }

  Widget tbody() {
    return Stack(
      children: [
        // Background image or content
        bodyContent().scrollable(),
        // BackdropFilter with blur effect
        if (controller.state.dialogStatus)
          Center(
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.black.withAlpha(64),
                  width: double.infinity,
                  child: dialog().scrollable(),
                ),
              ),
            ),
          ),
      ],
    );
  }

  AppBar appBar() {
    return AppBar(
      centerTitle: true,
      title: const Text('活動內容'),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final state = controller.state;
    return GetBuilder<RemarkController>(
      init: RemarkController(),
      id: 'remark',
      builder: (controller) {
        return Scaffold(
            key: controller.scaffoldKey,
            // endDrawer: menuEndDrawer(),
            appBar: appBar(),
            // onEndDrawerChanged: (isOpened) => closeMenu(isOpened),
            // drawerScrimColor: Colors.transparent,
            // endDrawerEnableOpenDragGesture: false,
            // drawerEnableOpenDragGesture: false,
            body: tbody());
      },
    );
  }
}
