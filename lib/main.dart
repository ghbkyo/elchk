import 'package:flutter/material.dart';
import 'package:get/get.dart';
import './routes/app_pages.dart';
import './langs/lang.dart';
import 'servie/index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_storage/get_storage.dart';

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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: '中文信義會',
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: AppService.to.getTheme(),
      darkTheme: AppService.to.getTheme(),
      themeMode: ThemeMode.system,
      translations: Langs(), // your translations
      locale: AppService.to
          .getLang(), // translations will be displayed in that locale
      fallbackLocale: AppService.to.getLang(),
      supportedLocales: const [
        //此处
        Locale('zh', 'CH'),
        Locale('zh', 'HK'),
        Locale('en', 'US'),

        Locale.fromSubtags(
            languageCode: 'zh',
            scriptCode: 'Hans',
            countryCode: 'CN'), // 'zh_Hans_CN'

        Locale.fromSubtags(
            languageCode: 'zh',
            scriptCode: 'Hant',
            countryCode: 'TW'), // 'zh_Hant_TW'

        Locale.fromSubtags(
            languageCode: 'zh', scriptCode: 'Hant', countryCode: 'HK'),
      ],
      localizationsDelegates: const [
        // 这里使用Getx的GetDelegate

        // 默认的本地化代理
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
    );
  }
}


// 修改图标
// 48,72,96,144,192

// 图标生成网站：
// icon.wuruihong.com/