import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import '../../extensions/ex_widget.dart';
import '../../servie/index.dart';
import 'state.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import '../../routes/app_pages.dart';
import '../../utils/index.dart';

class MyeventController extends GetxController {
  MyeventController();

  static Future<bool> dialog(
    BuildContext context, {
    String? title = "提示",
    String? content,
    String? cancelText = "否",
    String confirmText = "是",
  }) async {
    final bool? isConfirm = await showDialog<bool>(
      context: context,
      //点击背景灰色区域是否关闭对话框
      //barrierDismissble: false,
      builder: (BuildContext context) => Dialog(
        //这部分是对话框样式，可以完全自定义
        child: Container(
          width: 560,
          padding: const EdgeInsets.only(top: 40),
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (title != null)
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 34, left: 30, right: 30),
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFF353A37),
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              if (content != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 40, left: 30),
                  child: Text(
                    content,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF858786),
                      fontSize: 28,
                    ),
                  ),
                ),
              Row(
                children: [
                  if (cancelText != null)
                    Expanded(
                      child: GestureDetector(
                        //点击取消按钮
                        onTap: () {
                          Navigator.pop(context, false);
                        },
                        child: Container(
                          height: 100,
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(color: Color(0xFFE5E5E5)),
                              right: BorderSide(
                                color: Color(0xFFE5E5E5),
                              ),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              cancelText,
                              style: const TextStyle(
                                fontSize: 36,
                                color: Color(0xFF858786),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  Expanded(
                    child: GestureDetector(
                      //点击确认按钮
                      onTap: () {
                        Navigator.pop(context, true);
                      },
                      child: Container(
                        height: 100,
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Color(0xFFE5E5E5)),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            confirmText,
                            style: const TextStyle(
                              fontSize: 36,
                              color: Color(0xFF40B169),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
    //返回结果
    return isConfirm ?? false;
  }

  String uiKey = 'myevent';

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GetMyEventState state = GetMyEventState();

  void changeIndex(int index) {
    state.currentIndex = index;
    update([uiKey]);
  }

  void cancelEvent(var id) async {
    if (await dialog(
      Get.context!,
      title: "提示",
      content: "是否取消報名此活動？",
    )) {
      //print("点击确认");

      var params = {'programEnrollmentId': id, 'remark': ''};
      String apiUrl = 'ProgramEnrollment/Cancel';

      dynamic res = await ApiService.post(apiUrl, data: params);
      if (res != null) {
        int index = 0;
        for (var item in state.list) {
          int itemId = item['id'];
          if (id == itemId) {
            break;
          }
          index += 1;
        }
        state.list.removeAt(index);
        update([uiKey]);

        eventDialogShow(type: 2);
      }
    } else {
      print("点击取消");
    }
  }

  void eventDialogShow({int type = 0}) {
    if (type >= 1) state.dialogType = type;
    state.dialogStatus = true;
    update([uiKey]);
  }

  void closePaySuccess() {
    state.payStatus = false;
    update([uiKey]);
  }

  void showPaySuccess() {
    state.payStatus = true;
    update([uiKey]);
  }

  void showQrcode(var post) {
    state.dialogType = 4;
    state.dialogStatus = true;
    state.post = post;
    update([uiKey]);
  }

  void eventDialogType(int type) {
    state.dialogType = type;
    update([uiKey]);
  }

  void eventDialogClose() {
    state.dialogStatus = false;
    update([uiKey]);
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
    var body = {
      "programInfoId": id,
      "isEnabled": true,
    };
    String apiUrl = 'ProgramBookmark/Set';

    dynamic res = await ApiService.post(apiUrl, data: body);

    if (res != null) {
      int index = 0;
      for (var item in state.list) {
        int itemId = item['programInfo']['id'];
        if (id == itemId) {
          break;
        }
        index += 1;
      }
      //print(index);
      //state.list.removeAt(index);
      update([uiKey]);
    }
  }

  Future loadList() async {
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
    var params = {'params': body};
    String apiUrl = 'ProgramEnrollment/GetProgramEnrollments';

    dynamic res = await ApiService.post(apiUrl, data: params);

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
        int id = item['programInfo']['id'];
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
    state.memberNo =
        AuthService.memberData[AuthService.memberIndex]['memberNo'];
    scrollController.addListener(scrollListener);
    await loadList();

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
