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

class MyPage extends GetView<MyController> {
  const MyPage({super.key});

  Widget myButtonBody(String txt) {
    BoxDecoration decoration = const BoxDecoration(
      color: Color(0xFF0080CE),
      borderRadius: BorderRadius.all(Radius.circular(30)),
    );
    return tex(txt,
            fontSize: 16, textAlign: TextAlign.center, color: Colors.white)
        .container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            decoration: decoration);
  }

  Widget tagBody(
    String txt, {
    bool selected = false,
  }) {
    BoxDecoration decoration = BoxDecoration(
      color: selected ? const Color(0xFF55BDB9) : Colors.transparent,
      border: Border.all(
          color: selected ? const Color(0xFF55BDB9) : const Color(0xFFD8D8D8)),
      borderRadius: const BorderRadius.all(Radius.circular(20)),
    );
    if (selected) {
      return tex(txt, fontSize: 12, color: Colors.white).container(
          padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
          decoration: decoration);
    } else {
      return tex(txt, fontSize: 12, color: const Color(0xFFD0D0D0)).container(
          padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
          decoration: decoration);
    }
  }

  Widget bodyMemberInfo() {
    DateTime endDateTime = DateTime.now();
    List<Widget> memberCenter = [];

    endDateTime = DateTime.parse(controller.state.memberInfo['expiryDate']);
    endDateTime = endDateTime.add(const Duration(hours: 8));

    Widget hr = const SizedBox(
      width: 8,
    );
    int index = 0;
    for (var item in controller.state.memberCenter) {
      memberCenter.add(
        tagBody(item['center']['nameZH'],
                selected: controller.state.memberIndex == index)
            .onTap(() => controller.changeMember(item['id'])),
      );

      memberCenter.add(hr);
      index += 1;
    }

    bool isVolunteer = controller.state.memberInfo['isVolunteer'];

    var memberType = controller.state.memberInfo['memberType'];

    // 非会员
    int mtype = 0;
    String memberText = '非会员';
    if (memberType != null) {
      memberText = memberType['nameZH'];
    }
    // 金牌会员
    if (memberType != null && memberType['colour'] == 'gold') mtype = 2;
    // 银牌会员
    if (memberType != null && memberType['colour'] == 'xxx') mtype = 1;

    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(
                Icons.person,
                size: 20,
                color: Color(0xFF565D59),
              ),
              // SvgPicture.asset(
              //   'assets/svg/user.svg',
              //   width: 20,
              //   height: 20,
              //   color: const Color(0xFF565D59),
              // ),
              const SizedBox(
                width: 10,
              ),
              textH1('用戶資料')
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SvgPicture.asset(
                'assets/svg/smile.svg',
                width: 80,
                height: 80,
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  tex('${controller.state.memberInfo['nameZH']['lastName']} ${controller.state.memberInfo['nameZH']['firstName']} (${controller.state.memberInfo['age']}歲)',
                      fontSize: 16),
                  tex(controller.state.memberInfo['telMobile'], fontSize: 16),
                  // tex(
                  //     controller.state.memberInfo['gender'] == 'F'
                  //         ? '女性'
                  //         : '男性',
                  //     fontSize: 16),
                  if (isVolunteer)
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/svg/card-green.svg',
                          width: 14,
                          height: 14,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        tex('義工', fontSize: 16),
                      ],
                    ),
                  if (mtype == 0 && !isVolunteer)
                    Row(
                      children: [
                        tex('非會員', fontSize: 16),
                      ],
                    ),
                  if (mtype == 2 && !isVolunteer)
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/svg/card-gold.svg',
                          width: 14,
                          height: 14,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        tex('金卡會員', fontSize: 16),
                      ],
                    ),
                  if (mtype == 1)
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/svg/card-silver.svg',
                          width: 14,
                          height: 14,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        tex('銀卡會員', fontSize: 16),
                      ],
                    )
                ],
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(children: [
            tex('中心會員會籍', fontSize: 12, color: const Color(0xFF818181))
          ]),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              ...memberCenter
              // if (controller.state.loadInfo)
              //   tagBody('${controller.state.memberInfo['center']['nameZH']}',
              //       selected: true),
              // const SizedBox(
              //   width: 3,
              // ),
              // tagBody('愉翠', selected: true),
              // const SizedBox(
              //   width: 3,
              // ),
              // tagBody('葵涌'),
              // const SizedBox(
              //   width: 3,
              // ),
              // tagBody('頌安'),
              // const SizedBox(
              //   width: 3,
              // ),
              // tagBody('馬鞍山'),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              myButtonBody('更新資料').onTap(() {
                controller.changeTypeShow(1);
              }).flexible(),
              const SizedBox(
                width: 10,
              ),
              myButtonBody('設定同行者').onTap(() {
                controller.changeTypeShow(2);
              }).flexible(),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              myButtonBody('交易記錄').onTap(() {
                controller.changeTypeShow(3);
              }).flexible(),
              const SizedBox(
                width: 10,
              ),
              myButtonBody('會員續會').onTap(() {
                if (memberType == null) {
                  Get.toNamed(Routes.SHIP);
                } else {
                  controller.changeTypeShow(4);
                }
                //Get.toNamed(Routes.SHIP);
              }).flexible(),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          tex('現有積分: ${controller.state.memberInfo['loyaltyPoint']}',
              fontSize: 14,
              color: const Color(0xFFEB6685),
              fontWeight: FontWeight.bold),
          tex('(於${DateFormat('MM月dd日').format(endDateTime)}到期)',
              fontSize: 12, color: const Color(0xFF818181)),
          const SizedBox(
            height: 10,
          ),
          QrImageView(
            data: controller.state.memberInfo['memberNo'],
            version: QrVersions.auto,
            size: 140.0,
          )
              .container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border:
                        Border.all(color: const Color(0xFF0080CE), width: 3),
                    borderRadius: const BorderRadius.all(Radius.circular(30)),
                  ))
              .onTap(() => controller.dialogShow(1)),
          const SizedBox(
            height: 10,
          ),
          tex(controller.state.memberInfo['memberNo'],
              fontSize: 14, color: const Color(0xFF363D4E)),
          const SizedBox(
            height: 10,
          ),
          BarcodeWidget(
            barcode: Barcode.code128(), // Barcode type and settings
            data: controller.state.memberInfo['memberNo'], // Content
            width: 140,
            height: 30,
            drawText: false,
          ),
        ],
      ),
    ).scrollable();
  }

  Widget upadateIcon() {
    return Stack(
      alignment: Alignment.center, // Aligns the widgets to the center
      children: [
        // Background widget
        SizedBox(
          width: 80,
          height: 80,
          child: SvgPicture.asset(
            'assets/svg/smile.svg',
            width: 80,
            height: 80,
          ),
        ),

        // Another overlapping widget
        Positioned(
          top: 50,
          left: 50,
          child: SvgPicture.asset(
            'assets/svg/edit.svg',
            width: 30,
            height: 30,
          ),
        ),
      ],
    );
  }

  Widget upadateInput(
      String svg, String hintText, TextEditingController textEditingController,
      {int maxLines = 1}) {
    return Row(
      children: [
        SizedBox(
          width: 20,
          child: SvgPicture.asset(
            'assets/svg/profile-$svg.svg',
            width: 20,
            height: 20,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        TextFormField(
          // initialValue: value,
          // maxLines: maxLines,
          controller: textEditingController,
          style: const TextStyle(
            fontSize: 14.0, // 设置字体大小
          ),
          decoration: InputDecoration(
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
            isDense: true,
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
        ).expand(),
      ],
    );
  }

  Widget upadateInput2(String svg) {
    return Row(
      children: [
        SizedBox(
          width: 20,
          child: SvgPicture.asset(
            'assets/svg/profile-$svg.svg',
            width: 20,
            height: 20,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        TextFormField(
          // initialValue: value,
          // maxLines: maxLines,
          controller: controller.firstNameController,
          style: const TextStyle(
            fontSize: 14.0, // 设置字体大小
          ),
          decoration: const InputDecoration(
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 16),
            isDense: true,
            // label: Text(
            //   '電話號碼',
            // ),
            hintText: '姓',
            hintStyle: TextStyle(color: Color(0xFFC1C1C1)),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              borderSide: BorderSide(color: Color(0xFF58C5E6)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              borderSide: BorderSide(color: Color(0xFF58C5E6)),
            ),

            border: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF58C5E6)),
                borderRadius: BorderRadius.all(Radius.circular(30))),
            filled: true,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '请输入姓';
            }
            return null;
          },
        ).expand(),
        const SizedBox(
          width: 10,
        ),
        TextFormField(
          // initialValue: value,
          // maxLines: maxLines,
          controller: controller.lastNameController,
          style: const TextStyle(
            fontSize: 14.0, // 设置字体大小
          ),
          decoration: const InputDecoration(
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 16),
            isDense: true,
            // label: Text(
            //   '電話號碼',
            // ),
            hintText: '名',
            hintStyle: TextStyle(color: Color(0xFFC1C1C1)),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              borderSide: BorderSide(color: Color(0xFF58C5E6)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              borderSide: BorderSide(color: Color(0xFF58C5E6)),
            ),

            border: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF58C5E6)),
                borderRadius: BorderRadius.all(Radius.circular(30))),
            filled: true,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '请输入名';
            }
            return null;
          },
        ).expand(),
      ],
    );
  }

  Widget txInput(String hintText, TextEditingController textEditingController,
      {int maxLines = 1}) {
    return TextFormField(
      // initialValue: value,
      // maxLines: maxLines,
      controller: textEditingController,
      style: const TextStyle(
        fontSize: 14.0, // 设置字体大小
      ),
      decoration: InputDecoration(
        fillColor: Colors.white,
        isDense: true,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
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

  Widget txText(
    int id,
    String txt,
  ) {
    BoxDecoration decoration = const BoxDecoration(
      color: Color(0xFF55BDB9),
      borderRadius: BorderRadius.all(Radius.circular(30)),
    );
    return Row(
      children: [
        tex(txt,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                textAlign: TextAlign.center)
            .container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                decoration: decoration)
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

  Widget txText2(String txt) {
    BoxDecoration decoration = const BoxDecoration(
      color: Color(0xFF58C5E6),
      borderRadius: BorderRadius.all(Radius.circular(30)),
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        tex(txt,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            textAlign: TextAlign.center),
        SvgPicture.asset(
          'assets/svg/tx-remove.svg',
          width: 20,
          height: 20,
        ),
      ],
    ).container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
        decoration: decoration);
  }

  Widget backBody(String txt) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: 30,
          child: SvgPicture.asset('assets/svg/code-back.svg',
                  width: 40, height: 40)
              .onTap(() {
            controller.changeTypeShow(0);
          }),
        ),
        tex(txt,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF55BDB9),
                textAlign: TextAlign.center)
            .expand(),
        const SizedBox(
          width: 30,
        )
      ],
    );
  }

  Widget bodyMemberUpdate() {
    Widget hr = const SizedBox(
      height: 12,
    );
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      child: Column(
        children: [
          backBody('更新資料'),

          hr,
          hr,
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [upadateIcon()],
          ),
          // Column(
          //   children: [
          //     upadateInput('account', '會員名稱', controller.accountController),
          //   ],
          // ).container(padding: const EdgeInsets.all(16)),
          hr, hr,
          Form(
            key: controller.formKey,
            child: Column(
              children: [
                upadateInput2('account'),
                // upadateInput('account', '會員名稱', controller.accountController),
                hr,
                upadateInput('phone', '電話號碼', controller.phoneController),
                hr,
                upadateInput('email', '電子郵件', controller.emailController),
                hr,
                upadateInput(
                  'address',
                  '地址',
                  controller.addressController,
                  maxLines: 2,
                ),
                hr,
                // hr,
                // tex('緊急聯絡人資料',
                //     fontSize: 14,
                //     fontWeight: FontWeight.bold,
                //     color: const Color(0xFF9A9A9A),
                //     textAlign: TextAlign.center),
                // hr,
                // upadateInput(
                //     'account', '緊急聯絡人名稱', controller.contactNameController),
                // hr,
                // upadateInput(
                //     'phone', '緊急聯絡人電話號碼', controller.contactPhoneController),
                // hr,
                controller.state.isLoading
                    ? const CircularProgressIndicator(
                        color: Color(0xFF0080CE),
                        strokeWidth: 2,
                      ).center()
                    : commonSubmit('保存', onTap: controller.submit),
                hr,
                hr,
                tex('若希望更改其他資料，請聯絡中心職員',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF9A9A9A),
                    textAlign: TextAlign.center),
              ],
            ),
          ).container(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 32)),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    ).scrollable();
  }

  Widget bodyMemberTx() {
    List<Widget> widgetList = [];

    Widget hr = const SizedBox(
      height: 12,
    );

    for (var item in controller.state.txList) {
      widgetList.add(txText(item['id'], item['name']));
      widgetList.add(
        hr,
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      child: Column(
        children: [
          backBody('設定同行者'),
          const SizedBox(
            height: 16,
          ),
          Form(
            key: controller.txFormKey,
            child: Column(
              children: [
                tex('現有同行者',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF9A9A9A),
                    textAlign: TextAlign.center),
                const SizedBox(
                  height: 12,
                ),
                ...widgetList,
                // txText('呀女'),
                // const SizedBox(
                //   height: 5,
                // ),
                // txText('老婆'),
                // const SizedBox(
                //   height: 5,
                // ),
                // txText('呀大仔'),
                // const SizedBox(
                //   height: 5,
                // ),
                // txText2('陳小文'),
                const SizedBox(
                  height: 12,
                ),

                if (controller.state.txAdd)
                  txInput('會員姓名', controller.txNameController),
                if (controller.state.txAdd)
                  const SizedBox(
                    height: 12,
                  ),
                if (controller.state.txAdd)
                  txInput('電話號碼', controller.txPhoneController),
                if (controller.state.txAdd)
                  const SizedBox(
                    height: 12,
                  ),
                if (controller.state.txAdd)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      commonSubmit('取消', onTap: controller.cancelTx),
                      const SizedBox(
                        width: 16,
                      ),
                      controller.state.isLoading
                          ? const CircularProgressIndicator(
                              color: Color(0xFF55BDB9),
                              strokeWidth: 1,
                            ).center()
                          : commonSubmit('保存', onTap: controller.submitTx),
                    ],
                  ),

                if (controller.state.txAdd)
                  const SizedBox(
                    height: 16,
                  ),
                // if (!controller.state.txAdd)
                //   controller.state.isLoading
                //       ? const CircularProgressIndicator(
                //           color: Color(0xFF55BDB9),
                //           strokeWidth: 1,
                //         ).center()
                //       : commonSubmit('新增同行者', onTap: controller.createTxShow),
                if (!controller.state.txAdd)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      tex('新增同行者',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF9A9A9A),
                          textAlign: TextAlign.center),
                      const SizedBox(
                        width: 10,
                      ),
                      SvgPicture.asset(
                        'assets/svg/tx-add.svg',
                        width: 30,
                        height: 30,
                      ).onTap(() => controller.createTxShow()),
                    ],
                  ),
              ],
            ),
          ).container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 32)),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    ).scrollable();
  }

  Widget bodyMemberType() {
    List<Widget> widgetList = [];

    Widget hr = const SizedBox(
      height: 12,
    );

    DateTime endDateTime =
        DateTime.parse(controller.state.memberInfo['expiryDate']);
    endDateTime = endDateTime.add(const Duration(hours: 8));

    String expiryDate = DateFormat('dd/MM/yyyy').format(endDateTime);

    var memberType = controller.state.memberInfo['memberType'];
    // 非会员
    String memberText = '非会员';
    if (memberType != null) {
      memberText = memberType['nameZH'];
    }

    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      child: Column(
        children: [
          backBody('會員續會'),
          const SizedBox(
            height: 32,
          ),
          tex(memberText,
              fontSize: 16, color: Colors.amber, fontWeight: FontWeight.bold),
          const SizedBox(
            height: 16,
          ),
          tex('會籍到期日：$expiryDate',
              fontSize: 14, color: const Color(0xFFc73a88)),
        ],
      ),
    ).scrollable();
  }

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

  Widget paymentItemBody(
    String txt,
    String date,
    String cost, {
    int status = 1,
  }) {
    Color color = const Color(0xFFF9B300);
    String statusText = '賺取積分';
    if (status == 2) {
      color = const Color(0xFFEB6685);
      statusText = '';
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // if (statusText != '')
            //   tex(statusText, fontSize: 12, color: const Color(0xFFAFAFAF)),
            tex(r'$' + cost,
                fontSize: 16, color: color, fontWeight: FontWeight.bold)
          ],
        )
      ],
    ).container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFF58C4E6), width: 2),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ));
  }

  Widget paymentBody() {
    List<Widget> widgetList = [];

    Widget hr = const SizedBox(
      height: 12,
    );

    for (var item in controller.state.list) {
      DateTime paymentDate = DateTime.parse(item['paymentDate']);
      paymentDate = paymentDate.add(const Duration(hours: 8));

      String time = DateFormat('yyyy-MM-dd HH:mm').format(paymentDate);

      widgetList.add(paymentItemBody(
          item['paymentName'], time, item['amount'].toString()));
      widgetList.add(hr);
    }
    return SingleChildScrollView(
      controller: controller.goldScrollController,
      child: Column(children: [...widgetList]),
    );
  }

  Widget paymentBody_bak() {
    Widget hr = const SizedBox(
      height: 10,
    );
    return Column(
      children: [
        paymentItemBody('參加活動', '18/06/2024 | 16:00', '+30'),
        hr,
        paymentItemBody('參加活動', '18/06/2024 | 16:00', '-30', status: 2),
        hr,
        paymentItemBody('參加活動', '18/06/2024 | 16:00', '+30'),
        hr,
        paymentItemBody('參加活動', '18/06/2024 | 16:00', '+30'),
        hr,
        paymentItemBody('參加活動', '18/06/2024 | 16:00', '+30'),
        hr,
      ],
    );
  }

  Widget paymentItemBody2(
    String txt,
    String date,
    String cost, {
    int status = 1,
  }) {
    Color color = const Color(0xFF58C4E6);
    // color = Colors.blue;
    // String statusText = '賺取積分';
    // if (status == 2) {
    //   color = const Color(0xFFEB6685);
    //   statusText = '';
    // }
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
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
        tex(cost, fontSize: 16, color: color, fontWeight: FontWeight.bold)
      ],
    ).container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFF58C4E6), width: 2),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ));
  }

  Widget paymentBody2() {
    List<Widget> widgetList = [];

    Widget hr = const SizedBox(
      height: 12,
    );

    for (var item in controller.state.paymentList) {
      DateTime paymentDate = DateTime.parse(item['paymentDate']);
      paymentDate = paymentDate.add(const Duration(hours: 8));

      String time = DateFormat('yyyy-MM-dd HH:mm').format(paymentDate);

      widgetList.add(paymentItemBody2(
          item['paymentName'], time, r'$' + item['amount'].toString()));
      widgetList.add(hr);
    }
    return SingleChildScrollView(
      controller: controller.tradeScrollController,
      child: Column(children: [...widgetList]),
    );
  }

  Widget paymentBody2_bak() {
    Widget hr = const SizedBox(
      height: 10,
    );
    return Column(
      children: [
        paymentItemBody2('「藝 · 金齡」長者藝術分享坊', '18/06/2024 | 16:00', r'$200'),
        hr,
        paymentItemBody2('銀齡戲劇匯演 2024', '18/06/2024 | 16:00', r'$150'),
        hr,
        paymentItemBody2('「 陶泥到家」長者陶藝作品展覽', '18/06/2024 | 16:00', r'$150'),
        hr,
        paymentItemBody2('玩得喜同樂日', '18/06/2024 | 16:00', r'$150'),
        hr,
        paymentItemBody2('玩得喜同樂日2', '18/06/2024 | 16:00', r'$150'),
        hr,
      ],
    );
  }

  Widget bodyMemberPayment() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      width: double.infinity,
      child: Column(
        children: [
          backBody('交易記錄'),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              sortBody('積分記錄', 0).flexible(),
              const SizedBox(
                width: 10,
              ),
              sortBody('付款記錄', 1).flexible()
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          // tex('最後更新：23/07/2024  16:15',
          //     fontSize: 12,
          //     color: const Color(0xFFB9B9B9),
          //     textAlign: TextAlign.center),
          // const SizedBox(
          //   height: 10,
          // ),
          if (controller.state.currentIndex == 0) paymentBody().expand(),
          if (controller.state.currentIndex == 1) paymentBody2().expand(),
        ],
      ),
    );
  }

  Widget body() {
    Widget wg = bodyMemberInfo();
    if (controller.state.showType == 1) {
      wg = bodyMemberUpdate();
    } else if (controller.state.showType == 2) {
      wg = bodyMemberTx();
    } else if (controller.state.showType == 3) {
      wg = bodyMemberPayment();
    } else if (controller.state.showType == 4) {
      wg = bodyMemberType();
    }

    return wg.container(
      height: Get.context!.height,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bg.png'), // 替换为你的图片路径
          fit: BoxFit.cover, // 背景图片铺设模式
        ),
      ),
    );
  }

  Widget itemButton2(String txt) {
    return tex(txt,
            textAlign: TextAlign.center,
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold)
        .container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
            decoration: const BoxDecoration(
              color: Color(0xFF0080CE),
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ));
  }

  Widget qrcodeDialog() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            QrImageView(
              data: controller.state.memberInfo['memberNo'],
              version: QrVersions.auto,
              size: 200.0,
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
            tex(controller.state.memberInfo['memberNo'],
                fontSize: 14, color: const Color(0xFF363D4E)),
            const SizedBox(
              height: 10,
            ),
            BarcodeWidget(
              barcode: Barcode.code128(), // Barcode type and settings
              data: controller.state.memberInfo['memberNo'], // Content
              width: 200,
              height: 30,
              drawText: false,
            ),
            const SizedBox(
              height: 30,
            ),
            itemButton2('返回').onTap(() => controller.dialogShow(0)),
          ],
        )
      ],
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
        body(),
        // BackdropFilter with blur effect
        if (controller.state.dialogType >= 1)
          Center(
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  color: Colors.white.withAlpha(128),
                  width: double.infinity,
                  child: qrcodeDialog(),
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // final state = controller.state;
    return GetBuilder<MyController>(
      init: MyController(),
      id: 'my',
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
