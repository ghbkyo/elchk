import 'dart:developer';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import '../../extensions/ex_widget.dart';
import '../../servie/index.dart';
import 'state.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import '../../routes/app_pages.dart';
import '../../utils/index.dart';

class EventController extends GetxController {
  EventController();

  String uiKey = 'event';

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController keywordController = TextEditingController();
  final GetEventState state = GetEventState();

  void changeIndex(int index) {
    state.currentIndex = index;
    search();
    //update([uiKey]);
  }

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

  void search() async {
    page = 1;
    state.list.clear();
    Get.focusScope!.unfocus();
    await loadList();
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

    var centerId = DB.get('fliter_centerId');
    centerId ??= [];
    var categoryIds = DB.get('fliter_categoryIds');
    categoryIds ??= [];

    var fliterType03 = DB.get('fliter_type03');
    fliterType03 ??= [];

    int feeType = 0;
    if (fliterType03.contains('1')) feeType += 1;
    if (fliterType03.contains('2')) feeType += 2;

    //print(feeType);

    var fliterType04 = DB.get('fliter_type04');
    fliterType04 ??= [];

    List<String> orderBys = ['ProgramFee', 'StartDate', 'EndDate'];

    bool? isFree = false;
    if (feeType == 1) isFree = true;
    if (feeType == 3) isFree = null;
    String orderBy =
        orderBys[state.currentIndex]; // ProgramFee StartDate  EndDate
    var body = {
      "isOrderByAsc": true,
      "isTop": null,
      "orderBy": orderBy, // startDate endDate
      "pageNumber": page,
      "keyword": keywordController.text,
      "pageSize": 999,
      "isFree": isFree,
      "centerId": centerId,
      "categoryIds": categoryIds,
      "feeType": feeType,
      "memberType": fliterType04
    };
    String apiUrl = 'ProgramInfo/GetProgramInfos';

    dynamic res = await ApiService.post(apiUrl, data: body);

    state.isLoading = false;
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
        // dynamic data = await ApiService.getImage(id);

        // String? imageUrl;
        // if (data != null && data != 'none') {
        //   imageUrl =
        //       data.replaceFirst(RegExp(r'data:image\/[a-zA-Z]+;base64,'), '');

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
    // TODO: implement onClose
    print("控制器被释放");
    super.onClose();
  }
}
