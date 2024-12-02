import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import '../../utils/index.dart';

class AppService extends GetxService {
  String sysLanguageCode = '';
  String sysCountryCode = '';
  String themeName = '';

  static const String apiUrl = "https://4s-mobileapi-sit.elchk.org.hk/api/";
  static const String imageUrl = "https://4s-mobileapi-sit.elchk.org.hk/";

  static AppService get to => Get.find();

  Future<AppService> init() async {
    sysLanguageCode = await Storage.getString('sysLanguageCode') ?? 'zh';
    sysCountryCode = await Storage.getString('sysCountryCode') ?? 'CH';
    themeName = await Storage.getString('sys_theme') ?? '';
    return this;
  }

  Locale? getLang() {
    return sysLanguageCode != ''
        ? Locale(sysLanguageCode, sysCountryCode)
        : null;
  }

  void setLang(String languageCode, String countryCode) async {
    var locale = Locale(languageCode, countryCode);
    Get.updateLocale(locale);
    sysLanguageCode = languageCode;
    sysCountryCode = countryCode;
    await Storage.saveString('sysLanguageCode', languageCode);
    await Storage.saveString('sysCountryCode', countryCode);
  }

  ThemeData? getTheme() {
    String name = themeName;
    // ColorScheme.fromSeed(seedColor: seedColor)
    // FlexScheme.values[name]
    FlexScheme theme = FlexScheme.green;
    if (name == 'shark') {
      theme = FlexScheme.shark;
    } else if (name == 'green') {
      theme = FlexScheme.green;
    } else if (name == 'aquaBlue') {
      theme = FlexScheme.aquaBlue;
    }
    return FlexThemeData.light(scheme: theme, useMaterial3: true);
  }

  void setTheme(ThemeData theme, String name) async {
    Get.changeTheme(theme);
    Get.forceAppUpdate();
    themeName = name;
    await Storage.saveString('sys_theme', name);
  }

  static void addFontSize(double size) async {
    AppService.fontSize = size;
    Get.forceAppUpdate();
    // Get.appUpdate();
  }

  // 布局
  static const double padding = 16;
  static double fontSize = 0;

  static const double fontSizeLg = 22;
}
