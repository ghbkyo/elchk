import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import '../../extensions/ex_widget.dart';
import '../../servie/index.dart';
import './state.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import '../../routes/app_pages.dart';
import '../../utils/index.dart';
import '../home/index.dart';
import '../event/index.dart';
import '../myevent/index.dart';
import '../mycollect/index.dart';
import '../my/index.dart';

class InitialController extends GetxController {
  InitialController();

  String uiKey = 'initial';

  void changePage(int index) {
    if (index != state.currentIndex) {
      state.currentIndex = index;
      state.showDrawer = false;
      // state.appBarText = appTitle[index];
      update([uiKey]);
    }
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController scrollController = ScrollController();
  final TextEditingController keywordController = TextEditingController();

  final GetInitialState state = GetInitialState();

  void backTop() {
    if (scrollController.hasClients) {
      scrollController.animateTo(0.0,
          duration: const Duration(milliseconds: 30), curve: Curves.easeInOut);
    }
    state.isBackTop = false;
  }

  showEndDrawer() {
    if (state.currentIndex == 0) {
      final home = Get.find<HomeController>();
      if (state.showDrawer) {
        home.scaffoldKey.currentState!.closeEndDrawer();
      } else {
        home.scaffoldKey.currentState!.openEndDrawer();
      }
    } else if (state.currentIndex == 1) {
      final home = Get.find<EventController>();
      if (state.showDrawer) {
        home.scaffoldKey.currentState!.closeEndDrawer();
      } else {
        home.scaffoldKey.currentState!.openEndDrawer();
      }
    } else if (state.currentIndex == 2) {
      final home = Get.find<MyeventController>();
      if (state.showDrawer) {
        home.scaffoldKey.currentState!.closeEndDrawer();
      } else {
        home.scaffoldKey.currentState!.openEndDrawer();
      }
    } else if (state.currentIndex == 3) {
      final home = Get.find<MycollectController>();
      if (state.showDrawer) {
        home.scaffoldKey.currentState!.closeEndDrawer();
      } else {
        home.scaffoldKey.currentState!.openEndDrawer();
      }
    } else if (state.currentIndex == 4) {
      final home = Get.find<MyController>();
      if (state.showDrawer) {
        home.scaffoldKey.currentState!.closeEndDrawer();
      } else {
        home.scaffoldKey.currentState!.openEndDrawer();
      }
    }
    //state.showDrawer = !state.showDrawer;
    update([uiKey]);
    // home.update(['index']);
    // Get.back();
  }

  void loginOut() {
    AuthService.loginOut();
    update([uiKey]);
  }

  void setLang(languageCode, countryCode) {
    var locale = Locale(languageCode, countryCode);
    Get.updateLocale(locale);
  }

  Widget selectTheme() {
    return SizedBox(
      height: Get.height / 2,
      child: ListView.builder(
          itemCount: FlexScheme.values.length,
          itemBuilder: (context, index) {
            FlexScheme scheme = FlexScheme.values[index];
            ThemeData theme = FlexThemeData.light(scheme: scheme);
            return ListTile(
              tileColor: theme.primaryColor,
              title: Text(
                scheme.name,
                textAlign: TextAlign.center,
                style: TextStyle(color: theme.indicatorColor),
              ),
              onTap: () {
                Get.changeTheme(theme);
                // Get.forceAppUpdate();
                scaffoldKey.currentState!.closeDrawer();
                // Scaffold.of(Get.context!).closeDrawer();
                Navigator.pop(context, '取消');
                // update(['home']);
              },
            );
          }),
    );
  }

  Future openModalBottomSheetLogout() async {
    final option = await showModalBottomSheet(
        context: Get.context!,
        builder: (BuildContext context) {
          return SizedBox(
            height: 60.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ListTile(
                  title: Text(
                    'log off'.tr,
                    textAlign: TextAlign.center,
                  ),
                  onTap: () {
                    AuthService.loginOut();
                    update(['home']);
                    Navigator.pop(context, '取消');
                  },
                ),
              ],
            ),
          );
        });

    print(option);
  }

  void bottomSheetLogout() {
    Get.bottomSheet(Container(
      color: Get.isDarkMode ? Colors.black12 : Colors.white,
      height: 200,
      child: Column(
        children: [
          ListTile(
            title: const Text(
              "白天模式",
            ),
            trailing: Icon(Icons.logout,
                color: Get.isDarkMode ? Colors.white : Colors.black),
            onTap: () {
              Get.changeTheme(ThemeData.light());
              Get.back();
            },
          ),
          ListTile(
            leading: Icon(Icons.wb_sunny,
                color: Get.isDarkMode ? Colors.white : Colors.black),
            title: Text("黑夜模式",
                style: TextStyle(
                    color: Get.isDarkMode ? Colors.white : Colors.black)),
            onTap: () {
              Get.changeTheme(ThemeData.dark());
              Get.back();
            },
          )
        ],
      ),
    ));
  }

  @override
  void dispose() {
    scrollController.dispose();
    keywordController.dispose();
    super.dispose();
  }

  @override
  void onReady() async {
    // update();
    // print("加载完成");
    super.onReady();
  }

  @override
  void onClose() {
    print("控制器被释放");
    super.onClose();
  }
}
