import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart' hide Response;
import 'package:get/get_navigation/src/routes/default_transitions.dart';
import 'index.dart';
import '../../routes/app_pages.dart';
import '../../extensions/index.dart';
import '../../servie/index.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../home/index.dart';
import '../event/index.dart';
import '../myevent/index.dart';
import '../mycollect/index.dart';
import '../my/index.dart';

class InitialPage extends GetView<InitialController> {
  const InitialPage({super.key});
  // final HomeController controller = Get.put(HomeController());

  // Widget view() {}

  PreferredSize appBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(200.0), // 自定义高度
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset('assets/images/logo.png', width: 215, height: 50),
          Icon(
            controller.state.showDrawer ? Icons.close : Icons.menu,
            size: 40,
          ).onTap(() {
            controller.showEndDrawer();
            //controller.scaffoldKey.currentState!.openEndDrawer();
            // Scaffold.of(Get.context!).openEndDrawer();
          })
        ],
      ).container(
          padding: const EdgeInsets.fromLTRB(8, 32, 16, 5),
          decoration: const BoxDecoration(
              border: Border(
                  bottom: BorderSide(width: 0.5, color: Color(0xFF707070))))),
      // child: AppBar(
      //   title: Image.asset('assets/images/logo.png', fit: BoxFit.fitHeight),
      //   // centerTitle: true,
      // ),
    );
    // return AppBar(
    //   // title: Text('News Search'),
    //   // centerTitle: true,
    //   preferredSize: const Size.fromHeight(100.0),
    //   title: Image.asset('assets/images/logo.png', fit: BoxFit.fitHeight),
    // );
  }

  AppBar appBar2() {
    return AppBar(
      // title: Text('News Search'),
      // centerTitle: true,
      centerTitle: false,
      title: Image.asset('assets/images/logo.png', width: 215, height: 50),
      actions: [
        Icon(
          controller.state.showDrawer ? Icons.close : Icons.menu,
          size: 40,
        ).onTap(() {
          controller.showEndDrawer();
          //controller.scaffoldKey.currentState!.openEndDrawer();
          // Scaffold.of(Get.context!).openEndDrawer();
        })
      ],
    );
  }

  Widget bottomIcon(String svg, int index) {
    if (controller.state.currentIndex == index) {
      return SvgPicture.asset('assets/svg/$svg.svg',
              width: 30, height: 30, fit: BoxFit.cover)
          .container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                  color: Color(0xFF2C6C69), shape: BoxShape.circle))
          .onTap(() {
        controller.changePage(index);
      });
    }
    return SvgPicture.asset('assets/svg/$svg.svg',
            width: 30, height: 30, fit: BoxFit.cover)
        .onTap(() {
      controller.changePage(index);
    });
  }

  Widget bottomBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        bottomIcon('home', 0),
        bottomIcon('search', 1),
        bottomIcon('date', 2),
        bottomIcon('collect', 3),
        bottomIcon('user', 4),
      ],
    ).container(
        decoration: const BoxDecoration(
          color: Color(0xFF55BDB9),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8.0));
  }

  List<BottomNavigationBarItem> bottomNavigationBars() {
    return [
      const BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.house), label: ''),
      const BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.magnifyingGlass), label: ''),
      const BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.calendarDays), label: ''),
      const BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.heart), label: ''),
      BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/svg/h.svg', // 替换为你的 SVG 文件路径
          ),
          label: '')
    ];
  }

  Widget drawer() {
    return Drawer(
      child: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.language,
                color: Theme.of(Get.context!).colorScheme.primaryContainer),
            title: Text('language'.tr),
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.color_lens,
                color: Theme.of(Get.context!).colorScheme.primaryContainer),
            title: Text('theme'.tr),
          ),
          const Divider(),
          AuthService.isLogin
              ? ListTile(
                  leading: Icon(Icons.logout,
                      color:
                          Theme.of(Get.context!).colorScheme.primaryContainer),
                  title: Text('login_out'.tr),
                  onTap: () => controller
                      .openModalBottomSheetLogout()) // controller.loginOut())
              : ListTile(
                  leading: const Icon(Icons.login),
                  title: Text('login'.tr),
                  onTap: () => Get.toNamed(Routes.LOGIN)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final state = controller.state;
    return GetBuilder<InitialController>(
      init: InitialController(),
      id: 'initial',
      builder: (controller) {
        return Scaffold(
            key: controller.scaffoldKey,
            appBar: appBar(),
            endDrawer: drawer(),
            bottomNavigationBar: bottomBar(),
            body: [
              const HomePage(),
              const EventPage(),
              const MyeventPage(),
              const MycollectPage(),
              const MyPage(),
            ][controller.state.currentIndex]);
      },
    );
  }
}
