import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../index.dart';
import '../../servie/auth.dart';

class authMiddleware extends GetMiddleware {
  @override
  // 优先级越低越先执行
  int? get priority => -1;

  @override
  RouteSettings? redirect(String? route) {
    bool value = AuthService.isLogin;
    if (!value) return const RouteSettings(name: Routes.LOGIN);
    return null;
  }
}
