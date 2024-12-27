import 'package:flutter/material.dart';
import 'package:flutter_elchk/utils/db.dart';
import 'package:get/get.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
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

  connect();


  /// 等待服务初始化.
  // HttpService.to.setBaseUrl(Constants.API_URL);
  // ApiService.to.setBaseUrl(Constants.API_URL);

  // dynamic response = await ApiService.to.post('product.provide', {
  //   'product_id': 10190,
  // });

  initializeDateFormatting().then((_) => runApp(const MyApp()));
  // runApp(const MyApp());

}

JPush jpush = JPush();
/// 极光注册
connect() async {
  // final fcmToken = await FirebaseMessaging.instance.getToken();
  // print('===========${fcmToken}');

  jpush.applyPushAuthority(
      const NotificationSettingsIOS(sound: true, alert: true, badge: true));

  jpush.setup(
    appKey: "7511ed5c0eedf4a57871b1e0",
    channel: "theChannel",
    production: true,
    debug: true, // 设置是否打印 debug 日志
  );
  jpush.setUnShowAtTheForeground(unShow: true);
  jpush.addEventHandler(
    // 接收通知回调方法。
    onReceiveNotification: (Map<String, dynamic> message) async {
      /// ios 接受到极光推送的方法
      debugPrint("flutter onReceiveNotification: $message");

      // var json = message['message'];
      // Get.snackbar('${json['msg_type']}', '${json['alert']}');
      // var localNotification = LocalNotification(
      //     id: 234,
      //     title: "本地推送",
      //     buildId: 1,
      //     content: "😁 随便写点内容，时间 ${DateTime.now().toIso8601String()}",
      //     fireTime: DateTime.now(), // 立即发送
      //     subtitle: "副标题 123456",

      //     badge: 1,
      //     extra: {"myInfo": "推送信息balabla"} // 携带数据
      // );
      // jpush.sendLocalNotification(localNotification);
    },
    // 点击通知回调方法。
    onOpenNotification: (Map<String, dynamic> message) async {

      debugPrint("flutter onOpenNotification: $message");

      Get.toNamed(Routes.NOTICE);

      print('================== ${message['extras']['cn.jpush.android.EXTRA']}');

    },
    // 接收自定义消息回调方法。
    onReceiveMessage: (Map<String, dynamic> message) async {
      debugPrint("接收自定义消息回调方法 --- flutter onReceiveMessage: $message");
    },
  );
  jpush.getRegistrationID().then((value) async {
    debugPrint('getRegistrationID  === $value');
    // BotToast.showText(text: 'reg_id ========== ${value}');
    // requestDataWithUpDataResgister(value);

    // GetStorage().write('reg_id', '${value}');
    DB.set('reg_id', value);

  });



  /// fcm token上传成功 ：[ThirdPushManager] uploadRegID regid:dQKeohwRROCsporVCHyjn6:APA91bEFaPTI8gXAMaQVyO1DyZuJOQcZ-pyNPrR-WtRSSsf_6rEfKZfRHiC1ZQVE1dx4IeT4Ad6CnaysS7fox-b33s03GG3b2CPQz6uWj93KaQpy1VUchHA
  debugPrint('getRegistrationID=== ${await jpush.getRegistrationID()}');  /// 140fe1da9f9f9b5540e
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