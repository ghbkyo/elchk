import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'index.dart';
import '../../routes/app_pages.dart';
import '../../extensions/index.dart';
import '../../servie/index.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../common/index.dart';

class ClausePage extends GetView<ClauseController> {
  const ClausePage({super.key});

  Widget bodyContent() {
    return const Text(
      '除註明外，基督教香港信義會社會服務部（下稱「本機構」）是本網站所有內容（包括但不限於所有文本、圖像、圖畫、圖片、照片以及數據或其他材料的匯編）的版權擁有人。\n\n所有載於本網站內由本機構擁有版權的內容及資訊，可供自由瀏覽、列示、下載、列印、發佈或複製作非商業用途，但必須保留網站內容原來的格式，及須註明有關內容原屬本機構所有，並複印此版權告示於所有複製本內。本機構保留所有本版權告示沒有明確授予的權利。任何人士需要使用前述的內容作任何其他並非上述所批准的用途，須事先得到本機構的書面同意。有關申請可電郵至 ccd@elchk.org.hk 處理。以上所給予的批准並不引伸至任何其他與本網站連結的網站，或在本網站內標明由第三者擁有版權的內容。如你需要使用該等內容，必須取得有關版權擁有人的授權或批准。',
      style: TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
    );
  }

  Widget body() {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/bg.png',
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
            top: 16,
            left: 16,
            right: 16,
            bottom: 16,
            child: bodyContent().container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFF58C4E6), width: 2),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ))),
      ],
    );
  }

  AppBar appBar() {
    return AppBar(
      centerTitle: true,
      title: const Text('條款及細節'),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final state = controller.state;
    return GetBuilder<ClauseController>(
      init: ClauseController(),
      id: 'clause',
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
