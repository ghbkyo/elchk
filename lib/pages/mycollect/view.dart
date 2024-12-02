import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'index.dart';
import '../../routes/app_pages.dart';
import '../../extensions/index.dart';
import '../../servie/index.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../common/index.dart';
import 'package:intl/intl.dart';

class MycollectPage extends GetView<MycollectController> {
  const MycollectPage({super.key});

  Widget listBody_bak() {
    return ListView.builder(
      itemCount: controller.state.list.length,
      controller: controller.scrollController,
      itemBuilder: (context, index) {
        Widget body = Column(
          children: [...list()],
        );
        return body;
      },
    );
  }

  List<Widget> list() {
    List<Widget> widgetList = [];

    Widget hr = const SizedBox(
      height: 12,
    );

    for (var item in controller.state.list) {
      DateTime endDateTime = DateTime.parse(item['endDate']);
      endDateTime = endDateTime.add(const Duration(hours: 8));

      DateTime startDateTime = DateTime.parse(item['startDate']);
      startDateTime = startDateTime.add(const Duration(hours: 8));

      String time =
          '${DateFormat('HH:mm').format(startDateTime)} - ${DateFormat('HH:mm').format(endDateTime)}';

      String startDate = DateFormat('dd').format(startDateTime);
      String startMonth = DateFormat('MM月').format(startDateTime);

      String endDate = DateFormat('dd').format(endDateTime);
      String endMonth = DateFormat('MM月').format(endDateTime);
      String address = item['venue'];
      bool hasBookmark = item['hasBookmark'];

      int enrollmentQuota = item['programOnlineEnrollmentSetting'] == null
          ? 0
          : item['programOnlineEnrollmentSetting']['enrollmentQuota'];

      bool betweenDate = DateFormat('yyyy-MM-dd').format(startDateTime) !=
          DateFormat('yyyy-MM-dd').format(endDateTime);

      bool isFree = item['isFree'];
      String typeText = '免費';
      Color typeTextFontColors = Colors.white;
      Color typeTextColors = const Color(0xFF7C7C7C);
      if (!isFree) {
        typeText = '收費';
        typeTextFontColors = Colors.white;
        typeTextColors = const Color(0xFFF9B300);
      }

      bool isOnline = item['isOnline'];

      String? tip;
      Color tipColors = const Color(0xFFEB6685);
      if (isOnline) {
        tip = '綫上報名';
        tipColors = const Color(0xFFEB6685);
      }

      List<dynamic>? hashtags = item['hashtags'];
      String? tag;

      if (hashtags != null) {
        for (var tags in hashtags) {
          if (tag == null) {
            tag = '#${tags['name']}';
          } else {
            tag = '$tag #${tags['name']}';
          }
        }
      }

      String? imageData = item['imageData'];

      int itemId = item['id'];

      var post = {
        'id': itemId,
        'name': item['name'],
        'imageUrl': imageData,
        'tag': tag,
        'isOnline': isOnline,
        'isFree': isFree,
        'hasBookmark': hasBookmark,
        'date':
            '${DateFormat('MM月dd日').format(startDateTime)} - ${DateFormat('MM月dd日').format(endDateTime)}',
        'time': time,
        'address': address,
        'memberNums': enrollmentQuota.toString(),
        'introduction': item['introduction'],
        'canDuplicateEnrollment': item['canDuplicateEnrollment'],
        'isCompanionAllowed': item['isCompanionAllowed'],
        'programSessions': item['programSessions'],
        'enrollmentEndDate': item['enrollmentEndDate'],
        'enrollmentStartDate': item['enrollmentStartDate'],
        'endDate': item['endDate'],
        'startDate': item['startDate'],
        'center': item['center'],
        'maximunNumberOfCompanions': item['maximunNumberOfCompanions'],
      };

      widgetList.add(
        eventContent(
          item['name'],
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
          collectTap: () => controller.collectTap(itemId),
          postId: itemId,
        ).onTap(() {
          Get.toNamed(Routes.REMARK, arguments: {'post': post});
        }),
      );
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
          commonPageTopTips('我的收藏', Icons.favorite),
          const SizedBox(
            height: 16,
          ),

          // if (controller.state.list.isEmpty)
          //   Padding(
          //     padding: const EdgeInsets.all(20),
          //     child: Text(
          //       controller.state.isLoading ? '加载中' : '没有数据',
          //       style: const TextStyle(color: Colors.grey),
          //     ),
          //   ),

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

          // eventContent('「藝 · 金齡」長者藝術分享坊',
          //     imageUrl: 'img3.png',
          //     tip: '少量名額',
          //     collect: true,
          //     tipColors: const Color(0xFFEB6685),
          //     typeText: '免費',
          //     typeTextFontColors: Colors.white,
          //     typeTextColors: const Color(0xFF7C7C7C),
          //     tag: '#藝術 #分享坊 ',
          //     address: 'address',
          //     time: '12:00-19:00',
          //     memberNums: '60',
          //     betweenDate: true,
          //     startDate: '10',
          //     startMonth: '5月',
          //     endDate: '18',
          //     endMonth: '5月',
          //     overDate: '5月23日'),
          // const SizedBox(
          //   height: 10,
          // ),
          // eventContent('銀齡戲劇匯演 2024',
          //     imageUrl: 'img2.png',
          //     typeText: r'$60',
          //     collect: true,
          //     typeTextFontColors: Colors.white,
          //     typeTextColors: const Color(0xFFF9B300),
          //     tag: '#戲劇',
          //     address: '牛池灣文娛中心3樓',
          //     time: '12:00-19:00',
          //     memberNums: '60',
          //     betweenDate: false,
          //     startDate: '10',
          //     startMonth: '5月',
          //     endDate: '18',
          //     endMonth: '5月',
          //     overDate: '5月23日'),
          // const SizedBox(
          //   height: 10,
          // ),
          // eventContent('恩頤居長者護老院開放日',
          //     imageUrl: 'img1.png',
          //     tip: '名額已滿',
          //     collect: true,
          //     tipColors: const Color(0xFFC73A88),
          //     typeText: r'$60',
          //     typeTextFontColors: Colors.white,
          //     typeTextColors: const Color(0xFFF9B300),
          //     tag: '#護老院 #開放日',
          //     address: '恩頤居',
          //     time: '12:00-19:00',
          //     memberNums: '60',
          //     betweenDate: false,
          //     startDate: '10',
          //     startMonth: '5月',
          //     endDate: '18',
          //     endMonth: '5月',
          //     overDate: '5月23日'),
        ],
      ),
    );
  }

  Widget body() {
    return bodyContent();
  }

  @override
  Widget build(BuildContext context) {
    // final state = controller.state;
    return GetBuilder<MycollectController>(
      init: MycollectController(),
      id: 'mycollect',
      builder: (controller) {
        return Scaffold(
            key: controller.scaffoldKey,
            endDrawer: menuEndDrawer(),
            onEndDrawerChanged: (isOpened) => closeMenu(isOpened),
            drawerScrimColor: Colors.transparent,
            endDrawerEnableOpenDragGesture: false,
            drawerEnableOpenDragGesture: false,
            // floatingActionButton: controller.state.isBackTop
            //     ? FloatingActionButton(
            //         onPressed: () => controller.backTop(),
            //         child: const Icon(Icons.arrow_upward))
            //     : null,

            body: body());
      },
    );
  }
}
