import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import '../../extensions/ex_widget.dart';
import '../../servie/index.dart';
import './state.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import '../../routes/app_pages.dart';
import '../../utils/index.dart';
import '../initial/index.dart';

class HomeController extends GetxController {
  HomeController();

  String uiKey = 'home';
  int page = 1;
  void changePage(int index) {
    if (index != state.currentIndex) {
      state.currentIndex = index;
      // state.appBarText = appTitle[index];
      update([uiKey]);
    }
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final GetHomeState state = GetHomeState();

  void collectTap(int id) async {
    bool collect = false;
    int index = 0;
    for (var item in state.list) {
      int itemId = item['id'];
      if (id == itemId) {
        collect = state.list[index]['hasBookmark'];
        break;
      }
      index += 1;
    }

    var body = {
      "programInfoId": id,
      "isEnabled": !collect,
    };
    String apiUrl = 'ProgramBookmark/Set';

    dynamic res = await ApiService.post(apiUrl, data: body);

    if (res != null) {
      state.list[index]['hasBookmark'] = !collect;
      update([uiKey]);
    }
  }

  Future loadList() async {
    var body = {
      "isInProgress": true,
      "isOrderByAsc": false,
      "isShow": true,
      "isTop": null,
      "orderBy": "startDate",
      "pageNumber": 1,
      "pageSize": 6,
    };
    String apiUrl = 'ProgramInfo/GetProgramInfos';

    dynamic res = await ApiService.post(apiUrl,
        data: body, duration: const Duration(hours: 10));

    // state.isLoading = false;
    if (res != null) {
      var items = res['items'];
      int index = 0;
      for (var item in items) {
        int id = item['id'];
        // String imageGetUrl = 'ProgramInfo/$id/Image';
        // dynamic data = await ApiService.get(imageGetUrl,
        //     duration: const Duration(seconds: 10));
        dynamic data = await ApiService.getImage(id);

        String? imageUrl;
        if (data != null && data != 'none') {
          imageUrl =
              data.replaceFirst(RegExp(r'data:image\/[a-zA-Z]+;base64,'), '');
        }
        items[index]['imageData'] = imageUrl;
        index += 1;
      }
      // print(index);

      state.list.addAll(items);
      // update([uiKey]);
    }
  }

  Future loadList2() async {
    var body = {
      "isInProgress": false,
      "isOrderByAsc": false,
      "isShow": true,
      "isTop": null,
      "orderBy": "startDate",
      "pageNumber": 1,
      "pageSize": 12,
    };
    String apiUrl = 'ProgramInfo/GetProgramInfos';

    dynamic res = await ApiService.post(apiUrl,
        data: body, duration: const Duration(hours: 10));

    // state.isLoading = false;
    if (res != null) {
      var items = res['items'];
      int index = 0;
      for (var item in items) {
        int id = item['id'];
        // String imageGetUrl = 'ProgramInfo/$id/Image';
        // dynamic data = await ApiService.get(imageGetUrl,
        //     duration: const Duration(seconds: 10));
        // dynamic data = await ApiService.getImage(id);

        String? imageUrl = await ApiService.getImage(id);

        items[index]['imageData'] = imageUrl;
        index += 1;
      }
      // print(index);

      state.list2.addAll(items);
      // update([uiKey]);
    }
  }

  Future bannerInfo() async {
    dynamic data =
        await ApiService.get('BannerInfo', duration: const Duration(hours: 10));
    if (data != null) {
      state.banner = true;
      state.banners = data;
    }
  }

  @override
  void onInit() async {
    state.isLoading = true;
    update([uiKey]);
    await bannerInfo();
    await loadList();
    await loadList2();
    state.isLoading = false;
    update([uiKey]);
    super.onInit();
  }

  @override
  void onReady() async {
    // update();
    // print("加载完成");
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    print("控制器被释放");
    super.onClose();
  }
}
