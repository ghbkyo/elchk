import 'dart:ui';
import 'dart:io';
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

class MyeventPage extends GetView<MyeventController> {
  const MyeventPage({super.key});

  Widget sortBody(String txt, int index) {
    bool selected = index == controller.state.currentIndex;
    Color color = selected ? Colors.white : Colors.black;
    Color bgColor =
        selected ? const Color(0xFF55BDB9) : const Color(0xFFE8E8E8);
    return itemButton(txt, color, bgColor)
        .onTap(() => controller.changeIndex(index));
  }

  Widget itemButton(String txt, Color? color, Color? bgColor) {
    return tex(txt,
            textAlign: TextAlign.center,
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.bold)
        .container(
            width: double.infinity,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: const BorderRadius.all(Radius.circular(30)),
            ));
  }

  List<Widget> list() {
    List<Widget> widgetList = [];

    Widget hr = const SizedBox(
      height: 12,
    );

    List<String> months = [];

    for (var item in controller.state.list) {
      var programEnrollmentId = item['id'];
      var program = item['programEnrollmentSessions'][0]['programSession'];
      var type = item['programInfo']['type'];
      var accountReceivable = item['accountReceivable'];
      DateTime endDateTime = DateTime.parse(program['endDate']);
      endDateTime = endDateTime.add(const Duration(hours: 8));

      DateTime startDateTime = DateTime.parse(program['startDate']);
      startDateTime = startDateTime.add(const Duration(hours: 8));

      String time =
          '${DateFormat('HH:mm').format(startDateTime)} - ${DateFormat('HH:mm').format(endDateTime)}';

      String startDate = DateFormat('dd').format(startDateTime);
      String startMonth = DateFormat('MM月').format(startDateTime);

      String month = DateFormat('MM月份活動').format(startDateTime);
      bool showMonth = false;
      if (!months.contains(month)) {
        months.add(month);
        showMonth = true;
      }

      String endDate = DateFormat('dd').format(endDateTime);
      String endMonth = DateFormat('MM月').format(endDateTime);
      String address = program['venue'];
      bool hasBookmark = type['hasBookmark'] ?? false;

      int enrollmentQuota = item['programOnlineEnrollmentSetting'] == null
          ? 0
          : item['programOnlineEnrollmentSetting']['enrollmentQuota'];

      bool betweenDate = DateFormat('yyyy-MM-dd').format(startDateTime) !=
          DateFormat('yyyy-MM-dd').format(endDateTime);

      String orderNo = '';
      double totalAmount = 0;

      if (accountReceivable != null) {
        orderNo =
            '${accountReceivable['id']}A${accountReceivable['externalId']}';
        totalAmount = accountReceivable['totalAmount'] ?? 0;
      }

      bool isFree = totalAmount == 0; //item['isFree'];
      String typeText = '免費';
      Color typeTextFontColors = Colors.white;
      Color typeTextColors = const Color(0xFF7C7C7C);
      if (!isFree) {
        typeText = '收費'; //r'$' + totalAmount.toString();
        typeTextFontColors = Colors.white;
        typeTextColors = const Color(0xFFF9B300);
      }

      String status = item['paymentStatus'];
      int payStatus = 0;
      if (status == 'Unpaid') {
        payStatus = 1;
      } else if (status == 'Paid') {
        payStatus = 2;
      } else if (status == 'NoCharge') {
        payStatus = 0;
      }

      if (isFree) payStatus = 0;

      bool isOnline = item['isOnline'];

      String? tip;
      Color tipColors = const Color(0xFFEB6685);
      if (isOnline) {
        tip = '綫上報名';
        tipColors = const Color(0xFFEB6685);
      }

      List<String>? hashtags; // item['hashtags'];
      String? tag;

      String? imageData = item['imageData'];

      int itemId = item['programInfo']['id'];

      var post = {
        'id': itemId,
        'name': item['programInfo']['name'],
        'imageUrl': imageData,
        'tag': tag,
        'isOnline': isOnline,
        'isFree': isFree,
        'hasBookmark': hasBookmark,
        'date':
            '${DateFormat('MM月dd日').format(startDateTime)} - ${DateFormat('MM月dd日').format(endDateTime)}',
        'time': time,
        'address': address,
        'betweenDate': betweenDate,
        'startDate': startDate,
        'startMonth': startMonth,
        'endDate': endDate,
        'endMonth': endMonth,
        'memberNums': enrollmentQuota.toString(),
      };

      //var accountReceivable = item['accountReceivable'];

      if (showMonth) {
        widgetList.add(Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [dateTip(month)],
        ));
        widgetList.add(const SizedBox(
          height: 10,
        ));
      }

      widgetList.add(
        eventContent(item['programInfo']['name'],
            imageUrl: imageData,
            tip: tip,
            tipColors: tipColors,
            typeText: typeText,
            typeTextFontColors: typeTextFontColors,
            typeTextColors: typeTextColors,
            tag: tag,
            address: address,
            time: time,
            memberNums: enrollmentQuota.toString(),
            collect: hasBookmark,
            betweenDate: betweenDate,
            startDate: startDate,
            startMonth: startMonth,
            endDate: endDate,
            endMonth: endMonth,
            postId: itemId,
            payStatus: payStatus,
            collectTap: () => controller.collectTap(itemId)),
      );
      widgetList.add(
        hr,
      );
      if (isFree) {
        // widgetList.add(itemButton('取消報名', Colors.white, const Color(0xFFACACAC))
        //     .onTap(() => controller.eventDialogShow(type: 1)));

        widgetList.add(Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            itemButton('取消報名', Colors.white, const Color(0xFFACACAC))
                .onTap(() => controller.cancelEvent(programEnrollmentId))
                .flexible(),
            const SizedBox(
              width: 10,
            ),
            itemButton('我的二維碼', Colors.white, const Color(0xFFFA9600))
                .onTap(() => controller.showQrcode(post))
                .flexible(),
          ],
        ));
      } else if (payStatus == 2) {
        widgetList.add(Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            itemButton('取消報名', Colors.white, const Color(0xFFACACAC))
                .onTap(() => controller.eventDialogShow(type: 3))
                .flexible(),
            const SizedBox(
              width: 10,
            ),
            itemButton('我的二維碼', Colors.white, const Color(0xFFFA9600))
                .onTap(() => controller.showQrcode(post))
                .flexible(),
          ],
        ));
      } else {
        widgetList.add(Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            itemButton('取消報名', Colors.white, const Color(0xFFACACAC))
                .onTap(() => controller.eventDialogShow(type: 3))
                .flexible(),
            const SizedBox(
              width: 10,
            ),
            itemButton('前往付款', Colors.white, const Color(0xFF0080CE)).onTap(() {
              Get.toNamed(Routes.PAY, arguments: {
                'target': 'myevent',
                'order_no': orderNo,
                'amount': totalAmount,
                'id': itemId
              });
            }).flexible(),
          ],
        ));
      }
      widgetList.add(
        hr,
      );
    }
    return widgetList;
  }

  Widget listBody() {
    return SingleChildScrollView(
      controller: controller.scrollController,
      child: Column(children: [...list()]),
    );
  }

  Widget bodyContent() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        children: [
          commonPageTopTips('我的活動', Icons.calendar_month),
          const SizedBox(
            height: 16,
          ),
          Expanded(child: listBody()),
          if (controller.state.isLoading)
            const CircularProgressIndicator(
              color: Color(0xFF55BDB9),
              strokeWidth: 1,
            ).container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(5),
              width: 30,
              height: 30,
            ),
        ],
      ),
    );
  }

  Widget bodyContent2() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          commonPageTopTips('我的活動', Icons.calendar_month),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   children: [
          //     SvgPicture.asset(
          //       'assets/svg/date.svg',
          //       width: 20,
          //       height: 20,
          //       color: const Color(0xFF565D59),
          //     ),
          //     const SizedBox(
          //       width: 10,
          //     ),
          //     textH1('我的活動').expand(),
          //     const SizedBox(
          //       width: 10,
          //     ),
          //     SvgPicture.asset('assets/svg/smile.svg',
          //         width: 40, height: 40, fit: BoxFit.cover)
          //   ],
          // ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              sortBody('已報名活動', 0).flexible(),
              const SizedBox(
                width: 10,
              ),
              sortBody('過往活動', 1).flexible()
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          textH1Tip('十月份活動'),
          const SizedBox(
            height: 10,
          ),
          eventContent(
            '「藝 · 金齡」長者藝術分享坊',
            imageUrl: 'img3.png',
            tip: '少量名額',
            tipColors: const Color(0xFFEB6685),
            typeText: '免費',
            typeTextFontColors: Colors.white,
            typeTextColors: const Color(0xFF7C7C7C),
            tag: '#藝術 #分享坊 ',
            collect: true,
            address: 'address',
            time: '12:00-19:00',
            memberNums: '60',
            betweenDate: true,
            startDate: '10',
            startMonth: '5月',
            endDate: '18',
            endMonth: '5月',
            // payStatus: 1,
          ).onTap(() {
            Get.toNamed(Routes.REMARK);
          }),
          const SizedBox(
            height: 10,
          ),
          itemButton('取消報名', Colors.white, const Color(0xFFACACAC))
              .onTap(() => controller.eventDialogShow(type: 1)),
          const SizedBox(
            height: 10,
          ),
          const SizedBox(
            height: 10,
          ),
          eventContent('銀齡戲劇匯演 2024',
              imageUrl: 'img2.png',
              collect: true,
              typeText: r'$60',
              typeTextFontColors: Colors.white,
              typeTextColors: const Color(0xFFF9B300),
              tag: '#戲劇',
              address: '牛池灣文娛中心3樓',
              time: '12:00-19:00',
              memberNums: '60',
              betweenDate: false,
              startDate: '10',
              startMonth: '5月',
              endDate: '18',
              payStatus: 2,
              endMonth: '5月',
              overDate: '5月23日'),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              itemButton('取消報名', Colors.white, const Color(0xFFACACAC))
                  .onTap(() => controller.eventDialogShow(type: 3))
                  .flexible(),
              const SizedBox(
                width: 10,
              ),
              itemButton('我的二維碼', Colors.white, const Color(0xFFFA9600))
                  .onTap(() => controller.eventDialogShow(type: 4))
                  .flexible(),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          eventContent('恩頤居長者護老院開放日',
              imageUrl: 'img1.png',
              tip: '名額已滿',
              collect: true,
              tipColors: const Color(0xFFC73A88),
              typeText: r'$60',
              typeTextFontColors: Colors.white,
              typeTextColors: const Color(0xFFF9B300),
              tag: '#護老院 #開放日',
              address: '恩頤居',
              time: '12:00-19:00',
              memberNums: '60',
              betweenDate: false,
              startDate: '10',
              payStatus: 3,
              startMonth: '5月',
              endDate: '18',
              endMonth: '5月',
              overDate: '5月23日'),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              itemButton('取消報名', Colors.white, const Color(0xFFACACAC))
                  .onTap(() => controller.eventDialogShow(type: 1))
                  .flexible(),
              const SizedBox(
                width: 10,
              ),
              itemButton('前往付款', Colors.white, const Color(0xFF0080CE))
                  .onTap(() {
                Get.toNamed(Routes.PAYMENT);
              }).flexible(),
            ],
          ),
        ],
      ),
    );
  }

  Widget body() {
    return bodyContent();
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

  Widget eventDialog() {
    Widget wg = eventCancelDialog();
    if (controller.state.dialogType == 2) {
      wg = eventCancelConfirmDialog();
    } else if (controller.state.dialogType == 3) {
      wg = eventRejectDialog();
    } else if (controller.state.dialogType == 4) {
      // wg = paySuccessDialog();
      return qrCodeDialog().scrollable();
    }
    return wg.container(
        padding: const EdgeInsets.all(32),
        margin: const EdgeInsets.all(32),
        decoration: const BoxDecoration(
          color: Color(0xFF0080CE),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ));
  }

  Widget payButton(String txt) {
    return tex(txt,
            textAlign: TextAlign.center,
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold)
        .container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0xFFFA9600),
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ));
  }

  Widget paySuccessDialog() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          children: [
            const SizedBox(
              height: 120,
            ),
            SvgPicture.asset(
              'assets/svg/ship-success.svg',
              width: 180,
              height: 180,
            ),
            const SizedBox(
              height: 20,
            ),
            tex('付款成功，謝謝你的參與。',
                fontSize: 14,
                color: const Color(0xFF909090),
                textAlign: TextAlign.center),
            const SizedBox(
              height: 30,
            ),
            payButton('返回').onTap(() {
              controller.closePaySuccess();
            }).container(padding: const EdgeInsets.symmetric(horizontal: 50)),
            // itemButton('返回',)
            //     .onTap(() => Get.back())
            //     .container(padding: const EdgeInsets.symmetric(horizontal: 50)),
          ],
        )
      ],
    );
  }

  Widget qrCodeDialog() {
    var post = controller.state.post;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset('assets/svg/code-back.svg',
                width: 30, height: 30, fit: BoxFit.cover)
            .onTap(() {
          controller.eventDialogClose();
        }),
        const SizedBox(
          height: 8,
        ),
        Column(
          children: [
            eventCodeContent(
              post['name'],
              imageUrl: post['imageUrl'],
              tag: post['tag'],
              collect: post['hasBookmark'],
              address: post['address'],
              time: post['time'],
              memberNums: post['memberNums'],
              betweenDate: post['betweenDate'],
              startDate: post['startDate'],
              startMonth: post['startMonth'],
              endDate: post['endDate'],
              endMonth: post['endMonth'],
              payStatus: 1,
            ),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              height: 10,
            ),
            QrImageView(
              data: controller.state.memberNo,
              version: QrVersions.auto,
              size: 160.0,
            ).container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFF0080CE), width: 3),
                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                )),
            const SizedBox(
              height: 10,
            ),
            tex(controller.state.memberNo,
                fontSize: 14, color: const Color(0xFF919191)),
            const SizedBox(
              height: 10,
            ),
            BarcodeWidget(
              barcode: Barcode.code128(), // Barcode type and settings
              data: controller.state.memberNo, // Content
              width: 160,
              height: 30,
              drawText: false,
            ),
            const SizedBox(
              height: 10,
            ),
            tex('請向職員展示二維碼', fontSize: 14, color: const Color(0xFF919191))
          ],
        ).container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ))
      ],
    ).container(
        margin: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ));
  }

  Widget eventCancelConfirmDialog() {
    return Column(
      children: [
        SvgPicture.asset('assets/svg/success.svg',
            width: 50, height: 50, fit: BoxFit.cover),
        const SizedBox(
          height: 32,
        ),
        tex('你已成功取消報名',
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            textAlign: TextAlign.center),
        const SizedBox(
          height: 20,
        ),
        dialogBtn('我明白').onTap(() {
          controller.eventDialogClose();
        }),
      ],
    );
  }

  Widget eventCancelDialog() {
    return Column(
      children: [
        SvgPicture.asset('assets/svg/info.svg',
            width: 50, height: 50, fit: BoxFit.cover),
        const SizedBox(
          height: 32,
        ),
        tex('你是否決定取消報名?',
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            textAlign: TextAlign.center),
        const SizedBox(
          height: 20,
        ),
        dialogBtn('是').onTap(() {
          controller.eventDialogType(2);
        }),
        const SizedBox(
          height: 10,
        ),
        dialogBtn('否', close: true).onTap(() {
          controller.eventDialogClose();
        }),
      ],
    );
  }

  Widget eventRejectDialog() {
    return Column(
      children: [
        SvgPicture.asset('assets/svg/info.svg',
            width: 50, height: 50, fit: BoxFit.cover),
        const SizedBox(
          height: 32,
        ),
        tex('會員必須親身到中心手動取消報名及退款',
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            textAlign: TextAlign.center),
        const SizedBox(
          height: 20,
        ),
        // tex('是否繼續報名?',
        //     fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        // const SizedBox(
        //   height: 30,
        // ),
        dialogBtn('我明白').onTap(() {
          controller.eventDialogClose();
        }),
        // const SizedBox(
        //   height: 5,
        // ),
        // tex('否',
        //         fontSize: 20,
        //         fontWeight: FontWeight.bold,
        //         color: Colors.white,
        //         textAlign: TextAlign.center)
        //     .container(
        //         width: 80,
        //         padding: const EdgeInsets.all(8),
        //         decoration: const BoxDecoration(
        //           color: Color(0xFF55BDB9),
        //           borderRadius: BorderRadius.all(Radius.circular(30)),
        //         ))
        //     .onTap(() => controller.payforClose()),
      ],
    );
  }

  Widget pay() {
    return Column(
      children: [eventDialog()],
    );
  }

  Widget tbody() {
    return Stack(
      children: [
        // Background image or content
        if (!controller.state.payStatus) bodyContent(),
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
                  child: pay().scrollable(),
                ),
              ),
            ),
          ),

        if (controller.state.payStatus)
          Center(child: paySuccessDialog()).container(
            height: Get.context!.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg.png'), // 替换为你的图片路径
                fit: BoxFit.cover, // 背景图片铺设模式
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // final state = controller.state;
    return GetBuilder<MyeventController>(
      init: MyeventController(),
      id: 'myevent',
      builder: (controller) {
        return Scaffold(
            key: controller.scaffoldKey,
            endDrawer: menuEndDrawer(),
            onEndDrawerChanged: (isOpened) => closeMenu(isOpened),
            drawerScrimColor: Colors.transparent,
            endDrawerEnableOpenDragGesture: false,
            drawerEnableOpenDragGesture: false,
            body: tbody());
      },
    );
  }
}
