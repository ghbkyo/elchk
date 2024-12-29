import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'index.dart';
import '../../routes/index.dart';
import '../../extensions/index.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../common/index.dart';
import 'package:intl/intl.dart';

class EventPage extends GetView<EventController> {
  const EventPage({super.key});

  Widget sortBody(String txt, int index) {
    bool selected = index == controller.state.currentIndex;
    return Row(
      children: [
        tex(
          txt,
          fontSize: 12,
          color: selected ? Colors.white : Colors.black,
        ),
        Icon(
          Icons.keyboard_arrow_down,
          color: selected ? Colors.white : Colors.black,
        ),
      ],
    )
        .container(
            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 12),
            decoration: BoxDecoration(
              color:
                  selected ? const Color(0xFF55BDB9) : const Color(0xFFE8E8E8),
              borderRadius: const BorderRadius.all(Radius.circular(30)),
            ))
        .onTap(() => controller.changeIndex(index));
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
      bool hasBookmark = item['hasBookmark'] ?? false;

      int enrollmentQuota = item['programOnlineEnrollmentSetting'] == null
          ? 0
          : item['programOnlineEnrollmentSetting']['enrollmentQuota'];

      bool betweenDate = DateFormat('yyyy-MM-dd').format(startDateTime) !=
          DateFormat('yyyy-MM-dd').format(endDateTime);

      bool isFree = item['isFree'] ?? false;
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

      String postTag;
      if (tag == null) {
        postTag = item['center']['nameZH'];
      } else {
        postTag = '$tag ${item['center']['nameZH']}';
      }

      String? imageData = item['imageData'];

      int itemId = item['id'];

      var post = {
        'id': itemId,
        'name': item['name'],
        'imageUrl': imageData,
        'tag': postTag,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextField(
                controller: controller.keywordController,
                style: const TextStyle(
                  fontSize: 12.0, // 设置字体大小
                ),
                // onTap: (() {
                //   Get.toNamed(Routes.FILTER);
                // }),
                // onEditingComplete: () => controller.search(),
                onSubmitted: (value) => controller.search(),
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  // label: Text('冠軍子'),
                  hintText: '尋找活動',
                  hintStyle: const TextStyle(
                      fontFamily: 'NotoSansHK',
                      fontSize: 12,
                      fontWeight: FontWeight.normal),
                  fillColor: Colors.white,
                  focusColor: null,

                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    borderSide: BorderSide(
                      color: Color(0xFFEAEBEC),
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    borderSide: BorderSide(
                      color: Color(0xFFEAEBEC),
                    ),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide:
                          const BorderSide(width: 1, color: Color(0xFFEAEBEC))),
                  suffixIcon: const Icon(
                    Icons.tune,
                    color: Color(0xFF55BDB9),
                  ).onTap(() {
                    Get.toNamed(Routes.FILTER);
                  }),
                  prefixIcon: const Icon(Icons.search),
                ),
              ).expand(),
              const SizedBox(
                width: 16,
              ),
              SvgPicture.asset('assets/svg/smile.svg',
                  width: 40, height: 40, fit: BoxFit.cover)
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              tex(
                '排序',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF55BDB9),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  sortBody('費用', 0),
                  const SizedBox(
                    width: 10,
                  ),
                  sortBody('活動日期', 1),
                  const SizedBox(
                    width: 10,
                  ),
                  sortBody('截止日期', 2),
                ],
              ).expand(),
            ],
          ),
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextField(
                controller: controller.keywordController,
                style: const TextStyle(
                  fontSize: 12.0, // 设置字体大小
                ),
                // onTap: (() {
                //   Get.toNamed(Routes.FILTER);
                // }),
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  // label: Text('冠軍子'),
                  hintText: '尋找活動',
                  hintStyle: const TextStyle(
                      fontFamily: 'NotoSansHK',
                      fontSize: 12,
                      fontWeight: FontWeight.normal),
                  fillColor: Colors.white,
                  focusColor: null,

                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    borderSide: BorderSide(
                      color: Color(0xFFEAEBEC),
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    borderSide: BorderSide(
                      color: Color(0xFFEAEBEC),
                    ),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide:
                          const BorderSide(width: 1, color: Color(0xFFEAEBEC))),
                  suffixIcon: const Icon(
                    Icons.tune,
                    color: Color(0xFF55BDB9),
                  ).onTap(() {
                    Get.toNamed(Routes.FILTER);
                  }),
                  prefixIcon: const Icon(Icons.search),
                ),
              ).expand(),
              const SizedBox(
                width: 16,
              ),
              SvgPicture.asset('assets/svg/smile.svg',
                  width: 40, height: 40, fit: BoxFit.cover)
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              tex(
                '排序',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF55BDB9),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  sortBody('費用', 0),
                  const SizedBox(
                    width: 10,
                  ),
                  sortBody('日期', 1),
                  const SizedBox(
                    width: 10,
                  ),
                  sortBody('截止日期', 2),
                ],
              ).expand(),
            ],
          ),
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
            address: 'address',
            time: '12:00-19:00',
            memberNums: '60',
            betweenDate: true,
            startDate: '10',
            startMonth: '5月',
            endDate: '18',
            endMonth: '5月',
          ).onTap(() {
            Get.toNamed(Routes.REMARK);
          }),
          const SizedBox(
            height: 10,
          ),
          eventContent('銀齡戲劇匯演 2024',
              imageUrl: 'img2.png',
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
              endMonth: '5月',
              overDate: '5月23日'),
          const SizedBox(
            height: 10,
          ),
          eventContent('恩頤居長者護老院開放日',
              imageUrl: 'img1.png',
              tip: '名額已滿',
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
              startMonth: '5月',
              endDate: '18',
              endMonth: '5月',
              overDate: '5月23日'),
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
    return GetBuilder<EventController>(
      init: EventController(),
      id: 'event',
      builder: (controller) {
        return Scaffold(
            key: controller.scaffoldKey,
            endDrawer: menuEndDrawer(),
            onEndDrawerChanged: (isOpened) => closeMenu(isOpened),
            drawerScrimColor: Colors.transparent,
            endDrawerEnableOpenDragGesture: false,
            drawerEnableOpenDragGesture: false,
            body: body());
      },
    );
  }
}
