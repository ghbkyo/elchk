import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'servie/index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get_storage/get_storage.dart';

import './routes/app_pages.dart';
import './langs/lang.dart';
import './app.dart';

Future<void> initServices() async {
  print('starting services ...');
  await GetStorage.init();

  ///这里是你放get_storage、hive、shared_pref初始化的地方。
  ///或者moor连接，或者其他什么异步的东西。
  await Get.putAsync(() => AppService().init());
  await Get.putAsync(() => AuthService().init());
  await Get.putAsync(
      () => ApiService().init(timeout: 10, baseUrl: AppService.apiUrl));
  // await Get.putAsync(
  //     () => HttpService().init(timeout: 10, baseUrl: AppService.API_URL));

  // await Get.putAsync(SettingsService()).init();
  print('All services started...');
}

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();
  await initServices();

  /// 等待服务初始化.
  // HttpService.to.setBaseUrl(Constants.API_URL);
  // ApiService.to.setBaseUrl(Constants.API_URL);

  // dynamic response = await ApiService.to.post('product.provide', {
  //   'product_id': 10190,
  // });

  initializeDateFormatting().then((_) => runApp(const MyApp()));
  // runApp(const MyApp());
}
