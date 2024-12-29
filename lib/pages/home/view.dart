import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'index.dart';
import '../../routes/app_pages.dart';
import '../../extensions/index.dart';
import '../../servie/index.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../common/index.dart';
import 'dart:typed_data';
import 'dart:io';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:carousel_slider/carousel_slider.dart';

class MyPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    // double percentage = shrinkOffset / (maxExtent - minExtent);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      // color: Colors.blueAccent.withOpacity(1 - percentage),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  textH1('精選活動'),
                  textH1Tip('建立美好精彩人生'),
                ],
              ),
              SvgPicture.asset('assets/svg/smile.svg',
                  width: 40, height: 40, fit: BoxFit.cover)
            ],
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    // TODO: implement shouldRebuild
    return true;
  }

  @override
  double get minExtent => 100;

  @override
  double get maxExtent => 150; // Adjust based on your content
}

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  Widget list() {
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
    return Column(children: [...widgetList]);
    // return widgetList;
  }

  Widget ss() {
    final List<String> items =
        List.generate(30, (index) => 'Item ${index + 1}');
    SliverPersistentHeaderDelegate mydelegate = MyPersistentHeaderDelegate();

    return CustomScrollView(
      slivers: <Widget>[
        SliverPersistentHeader(
          pinned: true,
          delegate: mydelegate,
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return ListTile(
                title: Text(items[index]),
              );
            },
            childCount: items.length,
          ),
        ),
      ],
    );
  }

  Widget itemBody({
    String? imageUrl,
    String title = '',
    String time = '',
    String date = '',
    dynamic post,
  }) {
    ImageProvider imageProvider = const AssetImage('assets/images/logo.jpg');
    if (imageUrl != null) {
      Uint8List bytes = base64Decode(imageUrl);
      imageProvider = MemoryImage(bytes);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image(
          image: imageProvider,
          fit: BoxFit.fitHeight,
        ).container(
            width: double.infinity,
            // padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: Border.all(color: const Color(0xFFf5f5f5), width: 1),
            )),
        const SizedBox(
          height: 8,
        ),
        tex(
          title,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(
          height: 8,
        ),
        tex(
          time,
          fontSize: 12,
          color: const Color(0xFF808080),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            tex(
              date,
              fontSize: 12,
            ),
            tex('了解詳情', fontSize: 12, color: Colors.white)
                .container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 16),
                    decoration: const BoxDecoration(
                      color: Color(0xFF58C5E6),
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ))
                .onTap(() {
              Get.toNamed(Routes.REMARK, arguments: {'post': post});
            }),
          ],
        )
      ],
    );
  }

  Widget list2() {
    List<Widget> widgetList = [];
    Widget hr = const SizedBox(
      height: 12,
    );

    List<String> months = [];

    for (var item in controller.state.list2) {
      DateTime endDateTime = DateTime.parse(item['endDate']);
      endDateTime = endDateTime.add(const Duration(hours: 8));

      DateTime startDateTime = DateTime.parse(item['startDate']);
      startDateTime = startDateTime.add(const Duration(hours: 8));

      String month = DateFormat('MM月份活動').format(startDateTime);
      bool showMonth = false;
      if (!months.contains(month)) {
        months.add(month);
        showMonth = true;
      }

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
    return Column(children: [...widgetList]);
    // return widgetList;
  }

  Widget list2_bak() {
    List<Widget> widgetList = [];
    List<Widget> widgetList2 = [];
    int index = 0;

    Widget hr = const SizedBox(
      height: 32,
    );
    for (var item in controller.state.list2) {
      DateTime endDateTime = DateTime.parse(item['endDate']);
      endDateTime = endDateTime.add(const Duration(hours: 8));

      DateTime startDateTime = DateTime.parse(item['startDate']);
      startDateTime = startDateTime.add(const Duration(hours: 8));

      String time =
          '${DateFormat('HH:mm').format(startDateTime)} - ${DateFormat('HH:mm').format(endDateTime)}';

      String startDate = DateFormat('MM月dd日').format(startDateTime);

      String? imageData = item['imageData'];
      String name = item['name'];

      String address = item['venue'];
      bool hasBookmark = item['hasBookmark'] ?? false;

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

      if (index % 2 == 0) {
        widgetList.add(itemBody(
          imageUrl: imageData,
          title: name,
          time: time,
          date: startDate,
          post: post,
        ));
        widgetList.add(hr);
      } else {
        widgetList2.add(itemBody(
          imageUrl: imageData,
          title: name,
          time: time,
          date: startDate,
          post: post,
        ));
        widgetList2.add(hr);
      }
      index += 1;
    }

    return Row(
      children: [
        Column(
          children: [...widgetList],
        ).expand(),
        const SizedBox(
          width: 16,
        ),
        Column(
          children: [...widgetList2],
        ).expand(),
      ],
    );

    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [...widgetList],
    );
    // return widgetList;
  }

  Widget bodyContent() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  textH1('精選活動'),
                  textH1Tip('建立美好精彩人生'),
                ],
              ),
              SvgPicture.asset('assets/svg/smile.svg',
                  width: 40, height: 40, fit: BoxFit.cover)
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          if (controller.state.isLoading)
            const CircularProgressIndicator(
              color: Color(0xFF55BDB9),
              strokeWidth: 1,
            ).container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: 16),
              width: 30,
              height: 30,
            ),
          if (controller.state.isLoading)
            const SizedBox(
              height: 500,
            ),
          list(),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  textH1('即將舉辦的活動'),
                  textH1Tip('活動即將開始，敬請期待!'),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          list2(),
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
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  textH1('精選活動'),
                  textH1Tip('建立美好精彩人生'),
                ],
              ),
              SvgPicture.asset('assets/svg/smile.svg',
                  width: 40, height: 40, fit: BoxFit.cover)
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          eventContent('「藝 · 金齡」長者藝術分享坊',
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
                  overDate: '5月23日')
              .onTap(() {
            Get.toNamed(Routes.REMARK);
          }),
          const SizedBox(
            height: 10,
          ),
          eventContent('銀齡戲劇匯演 2024',
              imageUrl: 'img2.png',
              typeText: r'$60',
              collect: true,
              payStatus: 1,
              typeTextFontColors: Colors.white,
              typeTextColors: const Color(0xFFF9B300),
              tag: '#戲劇',
              address: '牛池灣文娛中心3樓',
              time: '',
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
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  textH1('即將舉辦的活動'),
                  textH1Tip('活動即將開始，敬請期待!'),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: <Widget>[
              itemBody(
                imageUrl: 'item01.png',
                title: '「 陶泥到家」長者陶藝作品展覽',
                time: '9:00-12:00',
                date: '1月13日',
              ).flexible(),
              const SizedBox(
                width: 16,
              ),
              itemBody(
                imageUrl: 'item02.png',
                title: '社區劇場《銀齡戲劇匯演》',
                time: '9:00-12:00',
                date: '1月13日',
              ).flexible(),
            ],
          ),
          const SizedBox(
            height: 32,
          ),
          Row(
            children: <Widget>[
              itemBody(
                imageUrl: 'item03.png',
                title: '照顧照顧者社區喘息站2022',
                time: '9:00-12:00',
                date: '1月13日',
              ).flexible(),
              const SizedBox(
                width: 16,
              ),
              itemBody(
                imageUrl: 'item04.png',
                title: '玩得喜同樂日',
                time: '9:00-12:00',
                date: '1月13日',
              ).flexible(),
            ],
          ),
        ],
      ),
    );
  }

  Widget body() {
    // int len = controller.state.banners.length;
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(height: 120.0),
          items: controller.state.banners.map((item) {
            Uint8List img = const Base64Decoder().convert(item['content']);
            return Builder(
              builder: (BuildContext context) {
                return Container(
                    width: Get.width,
                    margin: const EdgeInsets.symmetric(horizontal: 3.0),
                    // decoration: const BoxDecoration(color: Colors.amber),
                    child: controller.state.banner
                        ? Image.memory(img, fit: BoxFit.fitHeight)
                        : const SizedBox());
              },
            );
          }).toList(),
        ).container(
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(width: 0.5, color: Color(0xFF707070))))),

        // if (controller.state.banner)
        //   Container(
        //       width: Get.context!.width,
        //       decoration: const BoxDecoration(
        //         border: Border(
        //             bottom: BorderSide(width: 0.5, color: Color(0xFF707070))),
        //       ), // 屏幕宽度
        //       child: Image.memory(img, fit: BoxFit.fill)),
        const SizedBox(
          height: 16,
        ),
        // ss().expand(),
        bodyContent().scrollable().expand(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // final state = controller.state;
    return GetBuilder<HomeController>(
      init: HomeController(),
      id: 'home',
      builder: (controller) {
        return Scaffold(
            key: controller.scaffoldKey,
            endDrawer: menuEndDrawer(),
            drawerScrimColor: Colors.transparent,
            endDrawerEnableOpenDragGesture: false,
            drawerEnableOpenDragGesture: false,
            onEndDrawerChanged: (isOpened) => closeMenu(isOpened),
            body: body());
      },
    );
  }
}
