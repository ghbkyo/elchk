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

class MembershipPage extends GetView<MembershipController> {
  const MembershipPage({super.key});

// status 1 狀態更新 2 活動更新 3  會籍到期提示
  Widget noticeItemBody(
    String txt,
    String date, {
    int status = 1,
    bool dot = false,
  }) {
    Color color = const Color(0xFFCDD311);
    String statusText = '狀態更新';
    if (status == 2) {
      color = const Color(0xFFEB6685);
      statusText = '活動更新';
    } else if (status == 3) {
      color = const Color(0xFFF9B300);
      statusText = '會籍到期提示';
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(top: 8),
          width: 20,
          child: dot
              ? SvgPicture.asset(
                  'assets/svg/dot.svg',
                  width: 16,
                  height: 16,
                )
              : const SizedBox(),
        ),
        const SizedBox(
          width: 5,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            tex(txt, fontSize: 18, fontWeight: FontWeight.bold),
            tex(date, fontSize: 14, color: const Color(0xFF6C6C6C))
          ],
        ).expand(),
        const SizedBox(
          width: 5,
        ),
        tex(statusText, fontSize: 14, color: color),
      ],
    ).container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFF58C4E6), width: 2),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ));
  }

  Widget shipTop() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        tex('會員續會',
            fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        SvgPicture.asset(
          'assets/svg/ship-close.svg',
          width: 30,
          height: 30,
        ).onTap(() {
          Get.back();
        })
      ],
    ).container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Color(0xFF55BDB9),
          // border: Border.all(color: const Color(0xFF55BDB9), width: 2),
        ));
  }

  Widget shipStep() {
    Widget hr = const SizedBox(
      width: 5,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        tex('續會資料',
            fontSize: controller.state.shipStep == 0 ? 24 : 18,
            fontWeight: FontWeight.bold,
            color: controller.state.shipStep == 0
                ? const Color(0xFF55BDB9)
                : const Color(0xFFC4C4C4)),
        hr,
        SvgPicture.asset(
          'assets/svg/ship-hr.svg',
          width: double.infinity,
          height: 1,
        ),
        hr,
        tex('付款方式',
            fontSize: controller.state.shipStep == 1 ? 24 : 18,
            fontWeight: FontWeight.bold,
            color: controller.state.shipStep == 1
                ? const Color(0xFF55BDB9)
                : const Color(0xFFC4C4C4)),
        hr,
        SvgPicture.asset(
          'assets/svg/ship-hr.svg',
          width: double.infinity,
          height: 1,
        ),
        hr,
        tex('確認資料',
            fontSize: controller.state.shipStep == 2 ? 24 : 18,
            fontWeight: FontWeight.bold,
            color: controller.state.shipStep == 2
                ? const Color(0xFF55BDB9)
                : const Color(0xFFC4C4C4)),
      ],
    ).container(padding: const EdgeInsets.fromLTRB(16, 16, 16, 0));
  }

  Widget payTypeBody(String title, int id, double fee, String typeName) {
    String txt = title;
    String svg = 'check';
    Color color = const Color(0xFFC4C4C4);
    if (id == controller.state.payTypeId) {
      svg = 'checked';
      color = Colors.black;
    }
    return Row(
      children: [
        SvgPicture.asset(
          'assets/svg/ship-$svg.svg',
          width: 20,
          height: 20,
        ),
        const SizedBox(
          width: 5,
        ),
        tex(txt, fontSize: 14, color: color),
      ],
    ).onTap(() => controller.changePayType(id, fee, typeName));
  }

  Widget shipBody01() {
    Widget hr = const SizedBox(
      height: 10,
    );
    var renewInfo = controller.state.memberRenewInfoQuery;
    var memberTypes = renewInfo['memberTypes'] ?? [];
    String? expiryDate = renewInfo['expiryDate'];
    String date = '';
    if (expiryDate != null) {
      DateTime endDateTime = DateTime.parse(expiryDate);
      endDateTime = endDateTime.add(const Duration(hours: 8));

      date = DateFormat('dd/MM/yyyy').format(endDateTime);
    }
    List<Widget> widgetList = [];

    List<String> names = [];

    for (var item in memberTypes) {
      int id = item['memberType']['id'];
      double fee = item['fee'];
      String typeName = item['memberType']['nameZH'];

      names.add('$typeName(每年 \$$fee)');
      String title = '$typeName會籍：更新至 $date';
      widgetList.add(payTypeBody(title, id, fee, typeName));
      widgetList.add(hr);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        tex(
          controller.state.centerName,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        hr,
        tex('會籍到期日：${controller.state.expiryDate}',
            fontSize: 14, color: const Color(0xFFEB6685)),
        hr,
        tex(names.join(' | '), fontSize: 14, color: const Color(0xFFC4C4C4)),
        hr,
        ...widgetList,
        // payTypeBody(0),
        // hr,
        // payTypeBody(1),
        // hr,
        // SvgPicture.asset(
        //   'assets/svg/ship-xx.svg',
        //   width: double.infinity,
        //   height: 2,
        // ),
        // hr,
        // tex(
        //   '善學慈善基金關宣卿愉翠長者鄰舍中心',
        //   fontSize: 24,
        //   fontWeight: FontWeight.bold,
        // ),
        // hr,
        // tex('會籍到期日：22/05/2024', fontSize: 14, color: const Color(0xFFEB6685)),
        // hr,
        // tex(r'銀卡(每年 $100)  |  金卡(每年$200)',
        //     fontSize: 14, color: const Color(0xFFC4C4C4)),
        // hr,
        // payTypeBody(2),
        // hr,
        // payTypeBody(3),
      ],
    ).container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFF58C4E6), width: 2),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ));
  }

  Widget itemButton(String txt) {
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

  Widget shipBodyContent01() {
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          shipBody01(),
          const SizedBox(
            height: 20,
          ),
          itemButton('下一步').onTap(() => controller.changeStepIndex(1)),
        ],
      ),
    );
  }

  Widget shipPaymentItem(int payModeId, String txt, String? svg) {
    String icon = 'check';
    bool checked = payModeId == controller.state.payModeId;
    if (checked) {
      icon = 'checked';
    }

    // String icon = checked ? "ship-checked" : "ship-check";
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SvgPicture.asset(
          'assets/svg/ship-$icon.svg',
          width: 20,
          height: 20,
        ),
        const SizedBox(
          width: 5,
        ),
        tex(txt, fontSize: 14),
        const SizedBox(
          width: 5,
        ),
        if (svg != null)
          SvgPicture.asset(
            'assets/svg/$svg.svg',
            width: 20,
            height: 20,
          ),
        if (checked) Container().expand(),
        if (checked)
          const Icon(Icons.arrow_right, size: 20, color: Color(0xFF4A4A4A)),
      ],
    )
        .container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFF58C4E6), width: 1),
              borderRadius: const BorderRadius.all(Radius.circular(30)),
            ))
        .onTap(() => controller.changePayMode(payModeId, txt));
  }

  Widget shipBody02() {
    Widget hr = const SizedBox(
      height: 12,
    );

    List<Widget> widgetList = [];

    for (var item in controller.state.paymentMethods) {
      int id = item['id'];
      String typeName = item['nameZN'] ?? '';
      widgetList.add(shipPaymentItem(id, typeName, null));
      widgetList.add(hr);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        tex('總數',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFB9B9B9)),
        hr,
        tex(
          '\$${controller.state.fee}',
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        hr,
        hr,
        hr,
        ...widgetList,
        // shipPaymentItem('Payme', 'payme'),
        // hr,
        // shipPaymentItem(
        //   'Master / Visa',
        //   'visa',
        // ),
        // hr,
        // shipPaymentItem(
        //   '現金',
        //   'cost',
        // ),
        // hr,
        // shipPaymentItem(
        //   'Global payment',
        //   'global-payment',
        // ),
        hr,
      ],
    ).container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFF58C4E6), width: 2),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ));
  }

  Widget shipBodyContent02() {
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          shipBody02(),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              SvgPicture.asset('assets/svg/code-back.svg',
                      width: 40, height: 40)
                  .onTap(() {
                controller.changeStepIndex(0);
              }),
              const SizedBox(
                width: 10,
              ),
              itemButton('確認')
                  .onTap(() => controller.changeStepIndex(2))
                  .expand(),
            ],
          )
        ],
      ),
    );
  }

  Widget shipBody03() {
    Widget hr = const SizedBox(
      height: 10,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        tex(
          controller.state.centerName,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        hr,
        tex('會籍到期日：${controller.state.expiryDate}', fontSize: 14),
        hr,
        SvgPicture.asset(
          'assets/svg/ship-xx.svg',
          width: double.infinity,
          height: 2,
        ),
        hr,
        tex('總數',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFB9B9B9)),
        hr,
        tex(
          '\$${controller.state.fee}',
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        hr,
        SvgPicture.asset(
          'assets/svg/ship-xx.svg',
          width: double.infinity,
          height: 2,
        ),
        hr,
        tex('付款方式',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFB9B9B9)),
        hr,
        Row(
          children: [
            tex(controller.state.payModeName, fontSize: 14),
            // const SizedBox(
            //   width: 5,
            // ),
            // SvgPicture.asset(
            //   'assets/svg/payme.svg',
            //   width: 20,
            //   height: 20,
            // ),
          ],
        )
      ],
    ).container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFF58C4E6), width: 2),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ));
  }

  Widget shipBodyContent03() {
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          shipBody03(),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              SvgPicture.asset('assets/svg/code-back.svg',
                      width: 40, height: 40)
                  .onTap(() {
                controller.changeStepIndex(1);
              }),
              const SizedBox(
                width: 10,
              ),
              itemButton('確認').onTap(() => controller.dialogShow(1)).expand(),
            ],
          )
        ],
      ),
    );
  }

  Widget bodyContent() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          shipTop(),
          shipStep(),
          if (controller.state.shipStep == 0) shipBodyContent01(),
          if (controller.state.shipStep == 1) shipBodyContent02(),
          if (controller.state.shipStep == 2) shipBodyContent03(),
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

  Widget tbody() {
    return Stack(
      children: [
        Container(
          height: Get.context!.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bg.png'), // 替换为你的图片路径
              fit: BoxFit.cover, // 背景图片铺设模式
            ),
          ),
        ),
        // Background image or content
        bodyContent().scrollable(),
        // BackdropFilter with blur effect
        if (controller.state.dialogType >= 1 && !controller.state.payStatus)
          Center(
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  color: Colors.white.withAlpha(64),
                  width: double.infinity,
                  child: shipDialog(),
                ),
              ),
            ),
          ),

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

  Widget dialog() {
    return Column(
      children: [msgDialog()],
    );
  }

  Widget msgDialog() {
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
        dialogBtn('確認').onTap(() => controller.msgDialogClose()),
        // const SizedBox(
        //   height: 10,
        // ),
        // dialogBtn('否', close: true).onTap(() {
        //   // controller.eventDialogClose();
        // }),
      ],
    ).container(
        padding: const EdgeInsets.all(32),
        margin: const EdgeInsets.all(32),
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFF0080CE),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ));
  }

  Widget confirmDialog() {
    return Column(
      children: [
        SvgPicture.asset('assets/svg/success.svg',
            width: 50, height: 50, fit: BoxFit.cover),
        const SizedBox(
          height: 32,
        ),
        tex('你已選擇',
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            textAlign: TextAlign.center),
        tex(controller.state.payModeName,
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            textAlign: TextAlign.center),
        tex('支付',
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            textAlign: TextAlign.center),
        const SizedBox(
          height: 20,
        ),
        tex('\$${controller.state.fee}',
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            textAlign: TextAlign.center),
        // const SizedBox(
        //   height: 20,
        // ),
        // tex('付款編號',
        //     fontSize: 14, color: Colors.white, textAlign: TextAlign.center),
        // tex('RGYC20210002001',
        //     fontSize: 14, color: Colors.white, textAlign: TextAlign.center),
      ],
    );
  }

  Widget membershipDialog() {
    Widget wg = confirmDialog();

    return wg.container(
        padding: const EdgeInsets.all(32),
        width: double.infinity,
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

  Widget shipDialog() {
    if (controller.state.dialogType == 2) {
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
              itemButton('返回').onTap(() => Get.back()).container(
                  padding: const EdgeInsets.symmetric(horizontal: 50)),
            ],
          )
        ],
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          children: [
            membershipDialog(),
            const SizedBox(
              height: 20,
            ),
            itemButton('確認及前往付款')
                .onTap(() => controller.dialogShow(2))
                .container(padding: const EdgeInsets.symmetric(horizontal: 50)),
            const SizedBox(
              height: 20,
            ),
            tex('成功報名後，不會發放收據。',
                fontSize: 14,
                color: const Color(0xFF909090),
                textAlign: TextAlign.center),
            tex('如需收據，請親自到中心向職員索取。',
                fontSize: 14,
                color: const Color(0xFF909090),
                textAlign: TextAlign.center),
          ],
        )
      ],
    );
  }

  AppBar appBar() {
    return AppBar(
      centerTitle: true,
      title: const Text('會員續會'),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final state = controller.state;
    return GetBuilder<MembershipController>(
      init: MembershipController(),
      id: 'membership',
      builder: (controller) {
        return Scaffold(
            key: controller.scaffoldKey,
            appBar: appBar(),
            // endDrawer: menuEndDrawer(),
            // onEndDrawerChanged: (isOpened) => closeMenu(isOpened),
            // drawerScrimColor: Colors.transparent,
            // endDrawerEnableOpenDragGesture: false,
            // drawerEnableOpenDragGesture: false,
            body: tbody());
      },
    );
  }
}
