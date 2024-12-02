import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import '../../extensions/ex_widget.dart';
import '../../servie/index.dart';
import 'state.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import '../../routes/app_pages.dart';
import '../../utils/index.dart';

class NoticeController extends GetxController {
  NoticeController();

  String uiKey = 'notice';

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GetNoticeState state = GetNoticeState();
  final ScrollController scrollController = ScrollController();

  int page = 1;
  int totalRows = 0;
  int totalPage = 0;
  int pageSize = 10;

  void backTop() {
    if (scrollController.hasClients) {
      scrollController.animateTo(0.0,
          duration: const Duration(milliseconds: 30), curve: Curves.easeInOut);
    }
    state.isBackTop = false;
  }

  void scrollListener() {
    if (scrollController.offset >= 100 && state.isBackTop == false) {
      state.isBackTop = true;
      update([uiKey]);
    } else if (scrollController.offset <= 100 && state.isBackTop) {
      state.isBackTop = false;
      update([uiKey]);
    }
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      getMore();
    }
  }

  void loadList() async {
    // Helper.loadingShow();

    if (page >= 2 && page > totalPage) {
      Get.snackbar('友情提示', "沒有更多數據");
      return;
    }

    if (state.isLoading) return;
    state.isLoading = true;
    update([uiKey]);

    var body = {
      "isOrderByAsc": false,
      "orderBy": "id",
      "pageNumber": page,
      "pageSize": pageSize,
    };
    String apiUrl = 'ProgramNotice/GetProgramNotices';

    dynamic res = await ApiService.post(apiUrl, data: body);

    state.isLoading = false;
    // log(res.toString());
    // Helper.loadingHide();
    if (res != null) {
      // print(res);
      totalRows = res['totalCount'];
      totalPage =
          res['totalPages']; //(total_rows + page_size - 1) ~/ page_size;
      state.list.addAll(res['items']);
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
  void onInit() {
    loadList();
    scrollController.addListener(scrollListener);
    super.onInit();
  }

  @override
  void dispose() {
    scrollController.removeListener(scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  // @override
  // void onInit() async {
  //   try {
  //     var body = {
  //       "isOrderByAsc": false,
  //       "orderBy": "id",
  //       "pageNumber": 1,
  //       "pageSize": 10,
  //     };
  //     String apiUrl = 'ProgramNotice/GetProgramNotices';

  //     dynamic data = await ApiService.post(apiUrl, data: body);
  //     // dynamic data = await ApiService.get('MemberInfo');
  //     print(data);
  //     if (data != null) {}
  //   } catch (error) {
  //     // print('异常捕获: $error');
  //     Get.snackbar('错误', '网络连接出错');
  //   }
  //   super.onInit();
  // }

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
