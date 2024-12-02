import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../utils/index.dart';

class AuthService extends GetxService {
  static bool isLogin = false;
  static bool remember = false;
  static int currentUserId = 0;
  static int currentMemberId = 0;
  static int memberIndex = 0;
  static dynamic memberData = {};
  static String authorizationToken = '';
  static AuthService get to => Get.find();

  Future<AuthService> init() async {
    String authorization = DB.getString('authorization');
    currentUserId = DB.getInt('userId');
    currentMemberId = DB.getInt('memberId');
    remember = DB.getBool('remember');
    memberIndex = DB.getInt('memberIndex');
    memberData = DB.get('memberData');
    isLogin = GetUtils.isNullOrBlank(authorization) == false;
    authorizationToken = authorization;
    return this;
  }

  static void setRemember(bool flag) async {
    DB.set('remember', flag);
    remember = flag;
  }

  static void setMemberData(var data) async {
    DB.set('memberData', data);
    memberData = data;
  }

  static void setMemberIndex(int index) async {
    int memberId = memberData[index]['id'];
    int userId = memberData[index]['memberId'];
    DB.set('memberIndex', index);
    DB.set('userId', userId);
    DB.set('memberId', memberId);
    memberIndex = index;
    currentUserId = memberId;
    currentMemberId = memberId;
    // notifyListeners(); // 通知监听器状态改变
  }

  static void setMember(var data, int index) async {
    int memberId = data[index]['id'];
    int userId = data[index]['memberId'];
    DB.set('userId', userId);
    DB.set('memberId', memberId);
    DB.set('memberIndex', index);
    DB.set('memberData', data);
    memberIndex = index;
    memberData = data;
    currentUserId = userId;
    currentMemberId = memberId;
    // notifyListeners(); // 通知监听器状态改变
  }

  static void login(String token) async {
    DB.set('authorization', token);
    authorizationToken = token;
    isLogin = true;
    // notifyListeners(); // 通知监听器状态改变
  }

  static void loginOut() async {
    isLogin = false;
    authorizationToken = '';
    currentUserId = 0;
    currentMemberId = 0;
    DB.remove('userId');
    DB.remove('memberId');
    DB.remove('authorization');
    DB.remove('remember');
    DB.remove('memberIndex');
    DB.remove('memberData');
    // notifyListeners(); // 通知监听器状态改变
  }
}
