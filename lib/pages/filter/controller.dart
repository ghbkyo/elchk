import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import '../../extensions/ex_widget.dart';
import '../../servie/index.dart';
import 'state.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import '../../routes/app_pages.dart';
import '../../utils/index.dart';
import '../event/controller.dart';

class FilterController extends GetxController {
  FilterController();

  String uiKey = 'filter';

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GetFilterState state = GetFilterState();

  void fliterConfirm() async {
    final con = Get.find<EventController>();
    con.search();
    Get.back();
  }

  void fliterClear() {
    DB.remove('fliter_');
    DB.remove('fliter_centerId');
    DB.remove('fliter_categoryIds');
    DB.remove('fliter_type03');
    DB.remove('fliter_type04');
    update([uiKey]);
  }

  void spanClick(String key, String value) {
    String keyName = 'fliter_$key';
    var list = DB.get(keyName);
    list ??= <String>[];
    //List<String> list0 = list;
    if (list.contains(value)) {
      list.remove(value);
    } else {
      //list = [];
      list.add(value);
    }
    DB.set(keyName, list);
    update([uiKey]);
  }

  bool spanSelected(String key, String value) {
    String keyName = 'fliter_$key';
    var list = DB.get(keyName);
    if (list == null) return false;
    list ??= [];
    return list.contains(value);
  }

  Future getComCenter() async {
    dynamic data =
        await ApiService.get('ComCenter', duration: const Duration(days: 7));
    if (data != null) {
      state.comCenter = data;
      FliterItem type01 = FliterItem('活動中心', 'centerId');
      List<FliterSubItem> list = [];
      for (var element in state.comCenter) {
        list.add(FliterSubItem(element['nameZH'], element['id'].toString()));
      }
      type01.list = list;
      state.type01 = type01;
    }
  }

  Future getCategory() async {
    dynamic data = await ApiService.get('ProgramInfo/Category',
        duration: const Duration(days: 7));
    if (data != null) {
      state.category = data['MobileMenuCategory'];

      FliterItem type01 = FliterItem('活動類別', 'categoryIds');
      List<FliterSubItem> list = [];
      for (var element in state.category) {
        list.add(FliterSubItem(element['data1ZH'], element['id'].toString()));
      }
      type01.list = list;
      state.type02 = type01;

      update([uiKey]);
    }
  }

  @override
  void onInit() async {
    await getComCenter();
    await getCategory();

    // list.add(FliterSubItem('頌安長者鄰舍中心', '02'));
    // list.add(FliterSubItem('葵涌長者鄰舍中心', '03'));
    // list.add(FliterSubItem('善學慈善基金關宣卿愉翠長者鄰舍中心', '04'));

    // FliterItem type02 = FliterItem('活動類別', 'type02');
    // list = [];
    // list.add(FliterSubItem('工作坊', '01'));
    // list.add(FliterSubItem('義工服務', '02'));
    // list.add(FliterSubItem('戲劇表演', '03'));
    // list.add(FliterSubItem('開放日', '04'));
    // list.add(FliterSubItem('參觀', '05'));
    // list.add(FliterSubItem('治療性小組', '06'));
    // list.add(FliterSubItem('班組', '07'));
    // list.add(FliterSubItem('護老者活動', '08'));
    // type02.list = list;
    // state.type02 = type02;

    List<FliterSubItem> list = [];
    FliterItem type03 = FliterItem('費用', 'type03');
    list = [];
    list.add(FliterSubItem('免費', '1'));
    list.add(FliterSubItem('收費', '2'));
    // list.add(FliterSubItem(r'$20或以下', '20'));
    // list.add(FliterSubItem(r'$50或以下', '50'));
    // list.add(FliterSubItem(r'$100或以下', '100'));
    // list.add(FliterSubItem(r'$100以上', '+'));
    type03.list = list;
    state.type03 = type03;

    FliterItem type04 = FliterItem('參加資格', 'type04');
    list = [];
    list.add(FliterSubItem('義工', '義工'));
    list.add(FliterSubItem('個人會員', '個人會員'));
    list.add(FliterSubItem('非會員', '非會員'));
    list.add(FliterSubItem('金卡會員', '金卡會員'));
    list.add(FliterSubItem('銀卡會員', '銀卡會員'));
    list.add(FliterSubItem('銅卡會員', '銅卡會員'));
    // list.add(FliterSubItem('長者', '長者'));
    // list.add(FliterSubItem('義工', '義工'));
    type04.list = list;
    state.type04 = type04;

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
