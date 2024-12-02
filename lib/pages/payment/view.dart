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

class PaymentPage extends GetView<PaymentController> {
  const PaymentPage({super.key});

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
    DateTime endDateTime = DateTime.parse(controller.state.post['endDate']);
    endDateTime = endDateTime.add(const Duration(hours: 8));

    DateTime startDateTime = DateTime.parse(controller.state.post['startDate']);
    startDateTime = startDateTime.add(const Duration(hours: 8));

    String time =
        '${DateFormat('yyyy-MM-dd HH:mm').format(startDateTime)} - ${DateFormat('yyyy-MM-dd HH:mm').format(endDateTime)}';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            tex(controller.state.post['name'],
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            tex('時間：$time', fontSize: 12, color: Colors.white),
          ],
        ),
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
        tex('填寫資料',
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

  Widget payTypeBody(String txt, int type) {
    bool checked = controller.state.payType.contains(type);

    return Row(
      children: [
        Icon(
          checked ? Icons.check_box : Icons.check_box_outline_blank,
          size: 24,
          color: const Color(0xFF58C5E6),
        ),
        const SizedBox(
          width: 5,
        ),
        tex(txt, fontSize: 14).expand(),
      ],
    ).onTap(() => controller.changePayType(type));
  }

  Widget txText_bak(String txt) {
    BoxDecoration decoration = const BoxDecoration(
      color: Color(0xFF58C5E6),
      borderRadius: BorderRadius.all(Radius.circular(30)),
    );
    return tex(txt,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            textAlign: TextAlign.center)
        .container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
            decoration: decoration);
  }

  Widget txText(
    int id,
    String txt,
  ) {
    bool checked = controller.state.txIds.contains(id);

    BoxDecoration decoration = BoxDecoration(
      color: checked ? const Color(0xFF58C5E6) : const Color(0xFFFFFFFF),
      border: Border.all(color: const Color(0xFF58C5E6), width: 1),
      borderRadius: const BorderRadius.all(Radius.circular(30)),
    );

    return Row(
      children: [
        // Icon(
        //   checked ? Icons.check_box : Icons.check_box_outline_blank,
        //   size: 24,
        //   color: const Color(0xFF58C5E6),
        // ),
        // const SizedBox(
        //   width: 5,
        // ),
        tex(txt,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: checked ? Colors.white : Colors.black,
                textAlign: TextAlign.center)
            .container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                decoration: decoration)
            .onTap(() => controller.changeIds(id))
            .expand(),
        const SizedBox(
          width: 10,
        ),
        const Icon(
          Icons.cancel,
          size: 30,
          color: Color(0xFF58C5E6),
        ).onTap(() {
          controller.deleteTx(id);
        })
      ],
    );
  }

  Widget txText2() {
    BoxDecoration decoration = BoxDecoration(
      color: Colors.white,
      border: Border.all(color: const Color(0xFF58C5E6), width: 1),
      borderRadius: const BorderRadius.all(Radius.circular(30)),
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        tex('選擇預設同行人',
            fontSize: 14,
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.center),
        const Icon(Icons.arrow_downward),
      ],
    ).container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: decoration);
  }

  Widget txInput(String hintText, TextEditingController textEditingController,
      {int maxLines = 1}) {
    return TextFormField(
      // initialValue: value,
      // maxLines: maxLines,
      controller: textEditingController,
      style: const TextStyle(
        fontSize: 12.0, // 设置字体大小
      ),
      decoration: InputDecoration(
        fillColor: Colors.white,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        // label: Text(
        //   '電話號碼',
        // ),
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xFFC1C1C1)),

        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          borderSide: BorderSide(color: Color(0xFF58C5E6)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          borderSide: BorderSide(color: Color(0xFF58C5E6)),
        ),

        border: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF58C5E6)),
            borderRadius: BorderRadius.all(Radius.circular(30))),
        filled: true,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '请输入$hintText';
        }
        return null;
      },
    );
  }

  Widget txText3() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            txInput('新增同行人姓名', controller.accountController),
            const SizedBox(
              height: 5,
            ),
            txInput('聯絡電話', controller.phoneController),
          ],
        ).expand(),
        const SizedBox(
          width: 10,
        ),
        const Icon(
          Icons.add_circle,
          color: Color(0xFF58C5E6),
          size: 60,
        ).onTap(() => controller.createTx()),
      ],
    ).container(
      width: double.infinity,
    );
  }

  Widget shipBody01() {
    Widget hr = const SizedBox(
      height: 10,
    );

    var programSessions = controller.state.post['programSessions'];
    List<Widget> widgetList = [];

    for (var item in programSessions) {
      DateTime endDateTime = DateTime.parse(item['endDate']);
      endDateTime = endDateTime.add(const Duration(hours: 8));

      DateTime startDateTime = DateTime.parse(item['startDate']);
      startDateTime = startDateTime.add(const Duration(hours: 8));
      String time =
          '${DateFormat('yyyy-MM-dd HH:mm').format(startDateTime)}-${DateFormat('yyyy-MM-dd HH:mm').format(endDateTime)}';
      widgetList.add(payTypeBody(item['venue'] + '：' + time, item['id']));
      widgetList.add(hr);
    }

    List<Widget> widgetList2 = [];

    bool isCompanionAllowed = controller.state.post['isCompanionAllowed'];
    if (isCompanionAllowed) {
      for (var tx in controller.state.txList) {
        widgetList2.add(txText(tx['id'], tx['name']));
        widgetList2.add(
          hr,
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        tex('請選擇報名的節數',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFB9B9B9)),
        hr,
        ...widgetList,
        // payTypeBody('中心： 2024-05-22  17:00', 0),
        // hr,
        // payTypeBody('中心： 2024-05-22  17:00', 1),
        // hr,
        // payTypeBody('中心： 2024-05-22  17:00', 2),
        // hr,
        if (isCompanionAllowed)
          SvgPicture.asset(
            'assets/svg/ship-xx.svg',
            width: double.infinity,
            height: 2,
          ),
        if (isCompanionAllowed) hr,
        if (isCompanionAllowed)
          tex('同行人',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFB9B9B9)),
        if (isCompanionAllowed) hr,
        ...widgetList2,
        // txText('陳大文'),
        // hr,
        // txText2(),
        if (isCompanionAllowed) hr,
        if (isCompanionAllowed) txText3(),
      ],
    ).container(
        padding: const EdgeInsets.all(16),
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
      height: 10,
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
        // hr,
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

    bool isCompanionAllowed = controller.state.post['isCompanionAllowed'];

    var programSessions = controller.state.post['programSessions'];
    List<Widget> widgetList = [];

    for (var item in programSessions) {
      int id = item['id'];
      bool checked = controller.state.payType.contains(id);
      if (checked) {
        DateTime endDateTime = DateTime.parse(item['endDate']);
        endDateTime = endDateTime.add(const Duration(hours: 8));

        DateTime startDateTime = DateTime.parse(item['startDate']);
        startDateTime = startDateTime.add(const Duration(hours: 8));
        String time =
            '${DateFormat('yyyy-MM-dd HH:mm').format(startDateTime)}-${DateFormat('yyyy-MM-dd HH:mm').format(endDateTime)}';
        widgetList.add(
          tex(item['venue'] + '：' + time, fontSize: 14),
        );
        widgetList.add(hr);
      }
    }

    List<Widget> widgetList2 = [];
    int len = controller.state.txIds.length;
    if (isCompanionAllowed && len >= 1) {
      List<String> names = [];
      for (var tx in controller.state.txList) {
        int id = tx['id'];

        bool checked = controller.state.txIds.contains(id);
        if (checked) {
          names.add(tx['name']);
        }
      }
      widgetList2.add(
        tex(names.join(','), fontSize: 14),
      );
      widgetList2.add(
        hr,
      );
    }

    if (len == 0) isCompanionAllowed = false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        tex('報名的節數',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFB9B9B9)),
        hr,
        ...widgetList,
        //tex('中心： 2024-05-22  17:00', fontSize: 14),
        if (isCompanionAllowed) hr,
        if (isCompanionAllowed)
          SvgPicture.asset(
            'assets/svg/ship-xx.svg',
            width: double.infinity,
            height: 2,
          ),
        if (isCompanionAllowed) hr,
        if (isCompanionAllowed)
          tex('同行人',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFB9B9B9)),
        if (isCompanionAllowed) hr,
        if (isCompanionAllowed) ...widgetList2,
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
              //itemButton('確認').onTap(() => controller.join()).expand(),
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
        if (controller.state.dialogType >= 1)
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
                .onTap(() => controller.join())
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
      title: const Text('付款報名'),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final state = controller.state;
    return GetBuilder<PaymentController>(
      init: PaymentController(),
      id: 'payment',
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
