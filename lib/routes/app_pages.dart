import 'package:flutter_elchk/pages/event/view.dart';
import 'package:get/get.dart';

import '../pages/home/index.dart';
import '../pages/initial/index.dart';
import '../pages/event/index.dart';
import '../pages/myevent/index.dart';
import '../pages/mycollect/index.dart';
import '../pages/about/index.dart';
import '../pages/clause/index.dart';
import '../pages/my/index.dart';
import '../pages/index.dart';
import 'middleware/auth.dart';

class Routes {
  static const INITIAL = '/initial';
  static const HOME = '/home';
  static const EVENT = '/event';
  static const MYEVENT = '/myevent';
  static const MYCOLLECT = '/mycollect';
  static const LOGIN = '/login';
  static const MY = '/my';
  static const ABOUT = '/about';
  static const CLAUSE = '/clause';
  static const FILTER = '/filter';
  static const NOTICE = '/notice';
  static const SHIP = '/membership';
  static const PAYMENT = '/payment';
  static const REMARK = '/remark';
  static const FREE = '/free';
  static const PAY = '/pay';
}

// ignore: avoid_classes_with_only_static_members
class AppPages {
  static const INITIAL = Routes.INITIAL;

  static final routes = [
    GetPage(
      name: Routes.INITIAL,
      page: () => const InitialPage(),
      // middlewares: [authMiddleware()],
    ),
    GetPage(
      name: Routes.HOME,
      page: () => const HomePage(),
    ),
    GetPage(
      name: Routes.EVENT,
      page: () => const EventPage(),
    ),
    GetPage(
      name: Routes.MYEVENT,
      page: () => const MyeventPage(),
    ),
    GetPage(
      name: Routes.MYCOLLECT,
      page: () => const MycollectPage(),
    ),
    GetPage(
      name: Routes.ABOUT,
      page: () => const AboutPage(),
      middlewares: [authMiddleware()],
    ),
    GetPage(
      name: Routes.CLAUSE,
      page: () => const ClausePage(),
      middlewares: [authMiddleware()],
    ),
    GetPage(
      name: Routes.MY,
      page: () => const MyPage(),
    ),
    GetPage(
      name: Routes.FILTER,
      page: () => const FilterPage(),
    ),
    GetPage(
      name: Routes.NOTICE,
      page: () => const NoticePage(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginPage(),
    ),
    GetPage(
      name: Routes.SHIP,
      page: () => const MembershipPage(),
    ),
    GetPage(
      name: Routes.PAYMENT,
      page: () => const PaymentPage(),
      middlewares: [authMiddleware()],
    ),
    GetPage(
      name: Routes.REMARK,
      page: () => const RemarkPage(),
      middlewares: [authMiddleware()],
    ),
    GetPage(
      name: Routes.FREE,
      page: () => const FreePage(),
      middlewares: [authMiddleware()],
    ),
    GetPage(
      name: Routes.PAY,
      page: () => const PayPage(),
      middlewares: [authMiddleware()],
    ),
  ];
}
