import 'package:get/get.dart';
import 'en_US.dart';
import 'zh_CH.dart';
import 'zh_HK.dart';

class Langs extends Translations {
  @override
  Map<String, Map<String, String>> get keys =>
      {'en_US': en_US, 'zh_CH': zh_CH, 'zh_HK': zh_HK};
}
