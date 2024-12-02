import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'index.dart';
import '../../routes/app_pages.dart';
import '../../extensions/index.dart';
import '../../servie/index.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../common/index.dart';
import 'state.dart';

class FilterPage extends GetView<FilterController> {
  const FilterPage({super.key});

  Widget typeTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget typeSpan(String text,
      {bool selected = false, String key = 'type', String value = '01'}) {
    selected = controller.spanSelected(key, value);
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        color: selected ? Colors.white : Colors.black,
      ),
    )
        .container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
            decoration: BoxDecoration(
                color: selected ? const Color(0xFF55BDB9) : Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(20))))
        .onTap(() => controller.spanClick(key, value));
  }

  Widget typeBody(FliterItem? item) {
    Widget hr = const SizedBox(
      height: 16,
    );
    if (item == null) return hr;
    FliterItem type01 = item; //controller.state.type01!;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      typeTitle(type01.text),
      hr,
      if (type01.list != null)
        Wrap(
          spacing: 5,
          runSpacing: 8,
          children: type01.list!
              .map((item) =>
                  typeSpan(item.text, key: type01.key, value: item.value))
              .toList(),
        ),
      hr,
    ]);
  }

  Widget bodyContent() {
    Widget hr = const SizedBox(
      height: 16,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (controller.state.type01 != null) typeBody(controller.state.type01),
        if (controller.state.type01 != null) typeBody(controller.state.type02),
        typeBody(controller.state.type03),
        typeBody(controller.state.type04),
        // typeTitle('活動中心'),
        // hr,
        // Wrap(
        //   spacing: 5,
        //   runSpacing: 8,
        //   children: [
        //     typeSpan('馬鞍山長者地區中心'),
        //     typeSpan('沙田多元化金齡服務中心', selected: true),
        //     typeSpan('頌安長者鄰舍中心'),
        //     typeSpan('葵涌長者鄰舍中心'),
        //     typeSpan('善學慈善基金關宣卿愉翠長者鄰舍中心')
        //   ],
        // ),
        // hr,
        // typeTitle('活動類別'),
        // hr,
        // Wrap(
        //   spacing: 10,
        //   runSpacing: 16,
        //   children: [
        //     typeSpan('工作坊'),
        //     typeSpan('旅游', selected: true),
        //     typeSpan('義工服務'),
        //     typeSpan('戲劇表演', selected: true),
        //     typeSpan('開放日'),
        //     typeSpan('參觀', selected: true),
        //     typeSpan('治療性小組'),
        //     typeSpan('班組'),
        //     typeSpan('護老者活動', selected: true)
        //   ],
        // ),
        // hr,
        // typeTitle('費用'),
        // hr,
        // Wrap(
        //   spacing: 10,
        //   runSpacing: 16,
        //   children: [
        //     typeSpan('免費'),
        //     typeSpan('收費', selected: true),
        //   ],
        // ),
        // hr,
        // typeTitle('參加資格'),
        // hr,
        // Wrap(
        //   spacing: 10,
        //   runSpacing: 16,
        //   children: [
        //     typeSpan('只限會員'),
        //     typeSpan('公開', selected: true),
        //     typeSpan('只限網上報名'),
        //   ],
        // ),
      ],
    );
  }

  Widget body() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        bodyContent().container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16)),
        tex(
          '套用篩選',
          fontSize: 18,
          fontWeight: FontWeight.bold,
          textAlign: TextAlign.center,
          color: Colors.white,
        )
            .container(
                decoration: const BoxDecoration(
                    color: Color(0xFFEB6685),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16))
            .onTap(() => Get.back())
            .container(
                width: double.infinity,
                color: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 16))
      ],
    ).container(
        height: Get.context!.height,
        width: double.infinity,
        color: const Color(0xFFEB6685));
  }

  AppBar appBar() {
    return AppBar(
      centerTitle: true,
      title: const Text('篩選'),
      actions: [
        // Icon(Icons.clear)
        tex('清除所有')
            .container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: const BoxDecoration(
                    color: Color(0xFFE8E8E8),
                    borderRadius: BorderRadius.all(Radius.circular(20))))
            .onTap(() => controller.fliterClear()),
        const SizedBox(
          width: 16,
        )
      ],
    );
  }

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

  Widget tbody() {
    return Stack(
      children: [
        // Background image or content
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/item02.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        // BackdropFilter with blur effect
        Center(
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                alignment: Alignment.center,
                color: Colors.black.withAlpha(128),
                width: double.infinity,
                height: double.infinity,
                child: const Text(
                  'Blurred Background',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
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
    return GetBuilder<FilterController>(
      init: FilterController(),
      id: 'filter',
      builder: (controller) {
        return Scaffold(
            key: controller.scaffoldKey,
            // endDrawer: menuEndDrawer(),
            appBar: appBar(),
            // onEndDrawerChanged: (isOpened) => closeMenu(isOpened),
            // drawerScrimColor: Colors.transparent,
            // endDrawerEnableOpenDragGesture: false,
            // drawerEnableOpenDragGesture: false,
            body: body());
      },
    );
  }
}
