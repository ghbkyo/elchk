import 'package:flutter/material.dart';
import 'package:get/get.dart';
import './routes/app_pages.dart';
import './langs/lang.dart';
import 'servie/index.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
      // translations: Langs(), // your translations
      // locale: AppService.to
      //     .getLang(), // translations will be displayed in that locale
      // fallbackLocale: AppService.to.getLang(),
      // localizationsDelegates: const [
      //   // 默认的本地化代理
      //   GlobalMaterialLocalizations.delegate,
      //   GlobalWidgetsLocalizations.delegate,
      //   GlobalWidgetsLocalizations.delegate,
      // ],
    );
  }
}


// 修改图标
// 48,72,96,144,192

// 图标生成网站：
// icon.wuruihong.com/