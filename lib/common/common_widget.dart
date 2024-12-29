import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../servie/index.dart';
import '../extensions/index.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../pages/initial/index.dart';
import '../../routes/index.dart';
import './helper.dart';
import 'dart:convert';
import 'dart:typed_data';

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

// 通用頁頭部提示
Widget commonPageTopTips(String text, IconData icon) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      // SvgPicture.asset(
      //   'assets/svg/$svg.svg',
      //   width: 20,
      //   height: 20,
      //   color: const Color(0xFF565D59),
      // ),
      Icon(
        icon,
        size: 20,
        color: const Color(0xFF565D59),
      ),
      const SizedBox(
        width: 10,
      ),
      textH1(text).expand(),
      const SizedBox(
        width: 10,
      ),
      SvgPicture.asset('assets/svg/smile.svg',
          width: 40, height: 40, fit: BoxFit.cover)
    ],
  );
}

// 通用菜單
void closeMenu(bool isOpened) {
  final cont = Get.find<InitialController>();
  cont.state.showDrawer = isOpened;
  cont.update(['initial']);
}

// 通用
Widget textH1(String txt) {
  return tex(
    txt,
    fontSize: 22,
    color: const Color(0xFF55BDB9),
    fontWeight: FontWeight.bold,
  );
}

Widget textH1Tip(String txt) {
  return tex(
    txt,
    fontSize: 14,
    color: const Color(0xFF9A9A9A),
    fontWeight: FontWeight.bold,
  );
}

Widget dateTip(String txt) {
  return tex(
    txt,
    fontSize: 16,
    color: const Color(0xFF9A9A9A),
    fontWeight: FontWeight.bold,
    textAlign: TextAlign.left,
  );
}

Widget itemBottomLeft({
  String? tag = '',
  String address = '',
  String time = '',
  String memberNums = '0',
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      // if (tag != null)
      //   tex(
      //     tag,
      //     fontSize: 12,
      //     color: Colors.white,
      //   ),
      // const SizedBox(
      //   height: 5,
      // ),
      // Row(
      //   mainAxisAlignment: MainAxisAlignment.start,
      //   children: [
      //     const SizedBox(
      //       width: 20,
      //       child: Icon(
      //         Icons.pin_drop,
      //         size: 20,
      //         color: Color(0xFF55BDB9),
      //       ),
      //     ),
      //     const SizedBox(
      //       width: 5,
      //     ),
      //     tex(
      //       '地點：$address',
      //       fontSize: 12,
      //       color: Colors.white,
      //     ),
      //   ],
      // ),
      if (time != '')
        const SizedBox(
          height: 5,
        ),
      if (time != '')
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // SvgPicture.asset('assets/svg/time.svg', width: 16, height: 16),
            const SizedBox(
              width: 20,
              child: Icon(
                Icons.schedule,
                size: 20,
                color: Color(0xFF55BDB9),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            tex(
              '時間：$time',
              fontSize: 12,
              color: Colors.white,
            ),
          ],
        ),
      const SizedBox(
        height: 5,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            width: 20,
            child: Icon(
              Icons.group,
              size: 20,
              color: Color(0xFF55BDB9),
            ),
          ),

          // SvgPicture.asset('assets/svg/member.svg', width: 16, height: 16),
          const SizedBox(
            width: 5,
          ),
          tex(
            '名額：$memberNums人',
            fontSize: 12,
            color: Colors.white,
          ),
        ],
      )
    ],
  );
}

Widget itemBottomRightDate(String day, String month) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        tex(day, fontSize: 12, fontWeight: FontWeight.bold),
        tex(month, fontSize: 12, fontWeight: FontWeight.bold),
      ],
    ),
  );
}

Widget itemBottomRight({
  bool betweenDate = false,
  String startDate = '',
  String startMonth = '',
  String endDate = '',
  String endMonth = '',
  String? overDate = '',
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.end,
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (betweenDate) itemBottomRightDate(startDate, startMonth),
          if (betweenDate)
            const SizedBox(
              width: 5,
            ),
          if (betweenDate)
            SvgPicture.asset('assets/svg/hr.svg', width: 5, height: 2),
          const SizedBox(
            width: 5,
          ),
          itemBottomRightDate(endDate, endMonth),
        ],
      ),
      if (overDate != null)
        const SizedBox(
          height: 5,
        ),
      if (overDate != null)
        Text('截止日期：$overDate',
            style: const TextStyle(
              fontFamily: 'NotoSansHK',
              color: Colors.white,
              fontSize: 12,
            )),
      const SizedBox(
        height: 8,
      ),
    ],
  );
}

Widget eventCodeContent(
  String title, {
  String? imageUrl,
  String? tag = '',
  String address = '',
  String time = '',
  String memberNums = '',
  bool betweenDate = false,
  String startDate = '',
  String startMonth = '',
  String endDate = '',
  String endMonth = '',
  String? overDate,
  bool collect = false,
  Function()? collectTap,
  int payStatus = 0, // 0 不显示 1 待付款 2 已付款 3 待通知
}) {
  ImageProvider imageProvider = const AssetImage('assets/images/logo.jpg');
  if (imageUrl != null) {
    Uint8List bytes = base64Decode(imageUrl);
    imageProvider = MemoryImage(bytes);
  }

  return Container(
    width: double.infinity, // 指定图片的宽度
    height: 230,
    decoration: BoxDecoration(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      image: DecorationImage(
        image: imageProvider, //动态
        fit: BoxFit.cover,
      ),
    ),
    child: Column(
      children: [
        const Expanded(child: SizedBox()),
        Container(
          // padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
          decoration: BoxDecoration(
            // borderRadius: const BorderRadius.all(Radius.circular(10)),
            // borderRadius: const BorderRadius.only(
            //     bottomLeft: Radius.circular(10),
            //     bottomRight: Radius.circular(10)),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.3),
                Colors.black.withOpacity(0.6),
              ],
            ),
          ),
          width: double.infinity,
          height: 130,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              tex(title,
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              const SizedBox(
                height: 5,
              ),
              if (tag != null)
                tex(
                  tag,
                  fontSize: 12,
                  color: Colors.white,
                ),
              if (tag != null)
                const SizedBox(
                  height: 5,
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // SvgPicture.asset('assets/svg/address.svg', width: 16, height: 16),
                  const SizedBox(
                    width: 20,
                    child: Icon(
                      Icons.pin_drop,
                      size: 20,
                      color: Color(0xFF55BDB9),
                    ),
                  ),

                  const SizedBox(
                    width: 5,
                  ),
                  tex(
                    '地點：$address',
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  itemBottomLeft(
                      tag: tag,
                      address: address.length >= 10
                          ? address.substring(0, 10)
                          : address,
                      time: time,
                      memberNums: memberNums),
                  itemBottomRight(
                      betweenDate: betweenDate,
                      startDate: startDate,
                      startMonth: startMonth,
                      endDate: endDate,
                      endMonth: endMonth,
                      overDate: overDate)
                ],
              ).expand()
            ],
          ),
        )
            .backdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            )
            .clipRRect(bottomLeft: 10, bottomRight: 10),
      ],
    ),
  );
}

Widget eventContent(
  String title, {
  String? imageUrl,
  String? tip,
  Color? tipColors,
  String? typeText,
  Color? typeTextFontColors,
  Color? typeTextColors,
  String? tag = '',
  String address = '',
  String time = '',
  String memberNums = '',
  bool betweenDate = false,
  String startDate = '',
  String startMonth = '',
  String endDate = '',
  String endMonth = '',
  String? overDate,
  bool collect = false,
  int postId = 0,
  void Function()? collectTap,
  int payStatus = 0, // 0 不显示 1 待付款 2 已付款 3 待通知
}) {
  Color payColor = const Color(0xFF55BDB9);
  String payText = '';
  if (payStatus == 1) {
    payText = '待付款';
    payColor = const Color(0xFF0080CE);
  } else if (payStatus == 2) {
    payText = '已付款';
    payColor = const Color(0xFF55BDB9);
  } else if (payStatus == 3) {
    payText = '待通知';
    payColor = const Color(0xFFC73A88);
  }

  ImageProvider imageProvider = const AssetImage('assets/images/logo.jpg');
  if (imageUrl != null) {
    Uint8List bytes = base64Decode(imageUrl);
    imageProvider = MemoryImage(bytes);
  }
  return Container(
    width: double.infinity, // 指定图片的宽度
    height: 300,
    decoration: BoxDecoration(
      border: Border.all(color: const Color(0xFFf2f2f2), width: 0.5),
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      image: DecorationImage(
        image: imageProvider, //动态
        fit: BoxFit.fitHeight,
      ),
    ),
    child: Column(
      children: [
        Row(
          children: [
            if (tip != null)
              tex(tip, color: Colors.white).container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 3, horizontal: 15),
                  decoration: BoxDecoration(
                    color: tipColors,
                    borderRadius: const BorderRadius.all(Radius.circular(30)),
                  )),
            const Spacer(),
            SvgPicture.asset(
                    collect
                        ? 'assets/svg/collected-item.svg'
                        : 'assets/svg/collect-item.svg',
                    width: 40,
                    height: 40)
                .onTap(collectTap),
            // const SizedBox(
            //   width: 16,
            // ),
            // SvgPicture.asset('assets/svg/share-item.svg', width: 40, height: 40)
            //     .onTap(() {
            //   share('https://4s-member-sit.elchk.org.hk/program/detail/$postId',
            //       title);
            // })
          ],
        ).container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8)),
        const Expanded(child: SizedBox()),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              children: [
                if (payStatus >= 1)
                  tex('報名狀況', fontSize: 8, textAlign: TextAlign.center)
                      .container(
                          width: 80,
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          color: Colors.white),
                if (payStatus >= 1)
                  tex(payText,
                          fontSize: 8,
                          textAlign: TextAlign.center,
                          color: Colors.white)
                      .container(
                          width: 80,
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          color: payColor),
              ],
            ),
            if (typeText != null)
              tex(typeText, fontSize: 12, color: typeTextFontColors).container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                  decoration: BoxDecoration(
                    color: typeTextColors,
                    borderRadius: const BorderRadius.all(Radius.circular(30)),
                  )),
          ],
        ).container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16)),
        Container(
          // padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
          decoration: BoxDecoration(
            // borderRadius: const BorderRadius.all(Radius.circular(10)),
            // borderRadius: const BorderRadius.only(
            //     bottomLeft: Radius.circular(10),
            //     bottomRight: Radius.circular(10)),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.3),
                Colors.black.withOpacity(0.6),
              ],
            ),
          ),
          width: double.infinity,
          height: 130,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              tex(title,
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              const SizedBox(
                height: 5,
              ),
              if (tag != null)
                tex(
                  tag,
                  fontSize: 12,
                  color: Colors.white,
                ),
              if (tag != null)
                const SizedBox(
                  height: 5,
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // SvgPicture.asset('assets/svg/address.svg', width: 16, height: 16),
                  const SizedBox(
                    width: 20,
                    child: Icon(
                      Icons.pin_drop,
                      size: 20,
                      color: Color(0xFF55BDB9),
                    ),
                  ),

                  const SizedBox(
                    width: 5,
                  ),
                  tex(
                    '地點：$address',
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  itemBottomLeft(
                      tag: tag,
                      address: address,
                      time: time,
                      memberNums: memberNums),
                  itemBottomRight(
                      betweenDate: betweenDate,
                      startDate: startDate,
                      startMonth: startMonth,
                      endDate: endDate,
                      endMonth: endMonth,
                      overDate: overDate)
                ],
              ).expand()
            ],
          ),
        )
            .backdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            )
            .clipRRect(bottomLeft: 10, bottomRight: 10),
      ],
    ),
  );
}

Widget menuItem(String txt) {
  return tex(txt, fontSize: 18, fontWeight: FontWeight.bold);
}

Widget menuFontSize(String txt, double size, FontWeight? weight) {
  return Text(txt,
          style: TextStyle(
              fontFamily: 'NotoSansHK',
              color: Colors.white,
              fontSize: size,
              fontWeight: weight))
      .container(
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
    decoration: BoxDecoration(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      border: Border.all(color: Colors.white, width: 3.0),
    ),
  );
}

Widget menuEndDrawer() {
  return Container(
      width: Get.context!.width / 2, // 设置 Drawer 的宽度
      color: const Color(0xFFFFB700),
      padding: const EdgeInsets.all(16),
      // backgroundColor: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(
                height: 10,
              ),
              menuItem('關於我們').onTap(() {
                Get.toNamed(Routes.ABOUT);
              }),
              const SizedBox(
                height: 10,
              ),
              menuItem('用戶資料').onTap(() {
                final home = Get.find<InitialController>();
                home.changePage(4);
                // Get.toNamed(Routes.LOGIN);
              }),
              const SizedBox(
                height: 10,
              ),
              menuItem('我的收藏').onTap(() {
                final home = Get.find<InitialController>();
                home.changePage(3);
              }),
              const SizedBox(
                height: 10,
              ),
              menuItem('我的活動').onTap(() {
                final home = Get.find<InitialController>();
                home.changePage(2);
              }),
              const SizedBox(
                height: 10,
              ),
              menuItem('我的通知').onTap(() {
                Get.toNamed(Routes.NOTICE);
              }),
              const SizedBox(
                height: 10,
              ),
              menuItem('條款及細節').onTap(() {
                Get.toNamed(Routes.CLAUSE);
              }),
              const SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  menuItem('登出'),
                  const SizedBox(
                    width: 5,
                  ),
                  const Icon(
                    Icons.login,
                    size: 30,
                  )
                ],
              ).onTap(() => loginOut())
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              menuFontSize('小', 12, FontWeight.normal).onTap(() {
                AppService.addFontSize(-2);
              }),
              const SizedBox(
                width: 5,
              ),
              menuFontSize('中', 18, FontWeight.w400).onTap(() {
                AppService.addFontSize(2);
              }),
              const SizedBox(
                width: 5,
              ),
              menuFontSize('大', 24, FontWeight.bold).onTap(() {
                AppService.addFontSize(4);
              }),
            ],
          )
        ],
      ));
}

// 通用底部弹出
Future<dynamic> commonModalBottom(
  String txt, {
  String? html,
  double? height,
}) =>
    showModalBottomSheet(
        context: Get.context!,
        // isScrollControlled: true,
        backgroundColor: Colors.grey[200],
        elevation: 10.0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
        ),
        builder: (BuildContext context) {
          return SizedBox(
            // padding: const EdgeInsets.all(AppService.padding),
            height: height,
            child: Column(
              children: [
                ListTile(
                  // tileColor:
                  // Theme.of(Get.context!).colorScheme.primaryContainer,
                  title: Text(
                    txt,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const Divider(
                  thickness: 0.3,
                  color: Colors.black38,
                  height: 1,
                ),
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      vertical: AppService.padding,
                      horizontal: AppService.padding * 2),
                  child: HtmlWidget(
                    html ?? '',
                    textStyle:
                        const TextStyle(fontSize: 16, color: Colors.black),
                  ).scrollable(),
                ).expand(),
                // Container(
                //     color: Colors.white,
                //     padding: const EdgeInsets.symmetric(
                //         vertical: AppService.padding,
                //         horizontal: AppService.padding * 2),
                //     child: HtmlWidget(
                //       html ?? '',
                //       textStyle:
                //           const TextStyle(fontSize: 16, color: Colors.black54),
                //     )).scrollable().expand()
              ],
            ),
          );
        });

// 通提交按钮
Widget commonSubmit(
  String txt, {
  Function()? onTap,
}) =>
    ElevatedButton(
      // style: ElevatedButton.styleFrom(
      //     padding: const EdgeInsets.symmetric(vertical: 15),
      //     shape: const BeveledRectangleBorder(
      //         borderRadius: BorderRadius.all(Radius.circular(30.0)))),
      style: ButtonStyle(
        // backgroundColor: WidgetStateProperty.all(Colors.blue),
        backgroundColor: WidgetStateProperty.all(const Color(0xFF0080CE)),
        padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(vertical: 0, horizontal: 16)),
        // foregroundColor: WidgetStateProperty.all(Colors.white),
        elevation: WidgetStateProperty.all(5),
        shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
      ),
      onPressed: onTap,
      child: tex(txt,
              fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)
          .container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16)),
    );

// 通提交按钮
Widget commonModalSubmit(
  String txt, {
  Function()? onTap,
}) =>
    ElevatedButton(
      // style: ElevatedButton.styleFrom(
      //     padding: const EdgeInsets.symmetric(vertical: 15),
      //     shape: const BeveledRectangleBorder(
      //         borderRadius:
      //             BorderRadius.all(Radius.circular(10.0))
      //             )
      //             ),
      style: ButtonStyle(
        // backgroundColor: WidgetStateProperty.all(Colors.blue),
        // foregroundColor: WidgetStateProperty.all(Colors.white),
        elevation: WidgetStateProperty.all(1),
        shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      ),
      onPressed: onTap,
      child: Text(
        txt,
        style: const TextStyle(
          fontSize: 16,
        ),
      ).container(padding: const EdgeInsets.symmetric(vertical: 6)),
    );

Widget commonTextFormField(String label,
        {String? hintText,
        Icon? icon,
        bool obscureText = false,
        TextEditingController? controller,
        FormFieldValidator<String>? validator}) =>
    TextFormField(
      controller: controller,
      style: const TextStyle(
        fontSize: 14.0, // 设置字体大小
      ),
      obscureText: obscureText,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(10.0),
        label: Text(label),
        hintText: hintText,
        border: const OutlineInputBorder(),
        filled: true,
        prefixIcon: icon,
      ),
      validator: validator,
    );

extension ExWidget on Widget {}
