// ignore_for_file: constant_identifier_names

import './index.dart';

enum MoneyFormats {
  NORMAL, //保留两位小数(6.00元)
  END_INTEGER, //去掉末尾'0'(6.00元 -> 6元, 6.60元 -> 6.6元)
  YUAN_INTEGER, //整元(6.00元 -> 6元)
}

enum MoneyUnit {
  NORMAL, // 6.00
  YUAN, // ¥6.00
  YUAN_ZH, // 6.00元
  DOLLAR, // $6.00
}

/**
 * @Author: Sky24n
 * @GitHub: https://github.com/Sky24n
 * @Description: Money Util.
 * @Date: 2018/9/29
 */

/// Money Util.
class MoneyUtil {
  static const String yuan = '¥';
  static const String yuanZh = '元';
  static const String dollar = '\$';

  /// yuan, format & unit  output.(yuan is int,double,str).
  /// 元, format 与 unit 格式 输出.
  // static String changeYWithUnit(Object yuan, MoneyUnit unit,
  //     {MoneyFormats? format}) {
  //   String yuanTxt = yuan.toString();
  //   if (format != null) {
  //     int amount = changeY2F(yuan);
  //     yuanTxt = changeF2Y(amount.toInt(), format: format);
  //   }
  //   return withUnit(yuanTxt, unit);
  // }

  /// yuan to fen.F
  /// 元 转 分，
  // static int changeY2F(Object yuan) {
  //   return NumUtil.multiplyDecStr(yuan.toString(), '100').toBigInt().toInt();
  // }

  /// with unit.
  /// 拼接单位.
  static String withUnit(String moneyTxt, MoneyUnit unit) {
    switch (unit) {
      case MoneyUnit.YUAN:
        moneyTxt = yuan + moneyTxt;
        break;
      case MoneyUnit.YUAN_ZH:
        moneyTxt = moneyTxt + yuanZh;
        break;
      case MoneyUnit.DOLLAR:
        moneyTxt = dollar + moneyTxt;
        break;
      default:
        break;
    }
    return moneyTxt;
  }
}
