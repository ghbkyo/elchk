import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import '../../extensions/ex_widget.dart';
import '../../servie/index.dart';
import 'state.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import '../../routes/app_pages.dart';
import '../../utils/index.dart';

class MycollectController extends GetxController {
  MycollectController();

  String uiKey = 'mycollect';

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GetMycollectState state = GetMycollectState();

  final ScrollController scrollController = ScrollController();

  int page = 1;
  int totalRows = 0;
  int totalPage = 0;
  int pageSize = 5;

  void backTop() {
    if (scrollController.hasClients) {
      scrollController.animateTo(0.0,
          duration: const Duration(milliseconds: 30), curve: Curves.easeInOut);
    }
    state.isBackTop = false;
  }

  void scrollListener() {
    // if (scrollController.offset >= 100 && state.isBackTop == false) {
    //   state.isBackTop = true;
    //   update([uiKey]);
    // } else if (scrollController.offset <= 100 && state.isBackTop) {
    //   state.isBackTop = false;
    //   update([uiKey]);
    // }
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      getMore();
    }
  }

  void collectTap(int id) async {
    var body = {
      "programInfoId": id,
      "isEnabled": false,
    };
    String apiUrl = 'ProgramBookmark/Set';

    dynamic res = await ApiService.post(apiUrl, data: body);

    if (res != null) {
      int index = 0;
      for (var item in state.list) {
        int itemId = item['id'];
        if (id == itemId) {
          break;
        }
        index += 1;
      }
      // print(index);
      state.list.removeAt(index);
      update([uiKey]);
    }
  }

  Future loadList() async {
    // Helper.loadingShow();

    if (page >= 2 && page > totalPage) {
      // Get.snackbar('友情提示', "沒有更多數據");
      return;
    }

    if (state.isLoading) return;
    state.isLoading = true;
    update([uiKey]);

    var body = {
      // "isOrderByAsc": false,
      // "orderBy": "id",
      "pageNumber": page,
      "pageSize": pageSize,
    };
    String apiUrl = 'ProgramBookmark/GetProgramBookmarks';

    dynamic res = await ApiService.post(apiUrl, data: body);

    state.isLoading = false;
    update([uiKey]);
    // log(res.toString());
    // Helper.loadingHide();
    if (res != null) {
      // print(res);
      totalRows = res['totalCount'];
      totalPage =
          res['totalPages']; //(total_rows + page_size - 1) ~/ page_size;

      var items = res['items'];
      int index = 0;
      for (var item in items) {
        int id = item['id'];
        // String imageGetUrl = 'ProgramInfo/$id/Image';
        // dynamic data = await ApiService.get(imageGetUrl,
        //     duration: const Duration(hours: 10));

        // String? imageUrl;
        // if (data != null && data != 'null') {
        //   imageUrl =
        //       data.replaceFirst(RegExp(r'data:image\/[a-zA-Z]+;base64,'), '');

        //   print(imageUrl);
        // }
        String? imageUrl = await ApiService.getImage(id);
        items[index]['imageData'] = imageUrl;
        index += 1;
      }
      // print(index);

      state.list.addAll(items);
      page += 1;
      update([uiKey]);
    }
  }

  void getMore() {
    // isLoading = true;
    // update();
    loadList();
  }

  @override
  void onInit() async {
    await loadList();
    scrollController.addListener(scrollListener);
    super.onInit();
  }

  @override
  void dispose() {
    scrollController.removeListener(scrollListener);
    scrollController.dispose();
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
    // TODO: implement onClose
    print("控制器被释放");
    super.onClose();
  }
}
