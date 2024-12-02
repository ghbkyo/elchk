import 'dart:convert';
import 'package:flutter_elchk/servie/app.dart';
import 'package:get/get.dart';
import '../utils/storage.dart';
import 'auth.dart';
import 'package:flutter/material.dart';
import '../../common/index.dart';
import '../utils/db.dart';
import 'dart:ffi';

class ApiService extends GetxService {
  static ApiService get to => Get.find();

  static late final GetConnect getc;

  static void setBaseUrl(String baseUrl) {
    getc.httpClient.baseUrl = baseUrl;
  }

  static void resetBaseUrl() {
    getc.httpClient.baseUrl = AppService.apiUrl;
  }

  /// 初始化
  /// [timeout] 请求超时时间
  Future<ApiService> init({int timeout = 10, String? baseUrl}) async {
    getc = GetConnect(timeout: const Duration(seconds: 30));
    getc.baseUrl = baseUrl;
    getc.httpClient.baseUrl = baseUrl;

    // 请求拦截器
    getc.httpClient.addRequestModifier<dynamic>((request) async {
      // add request here

      // print('token:');
      // print(authorizationToken);
      if (!request.headers.containsKey('Authorization')) {
        String authorizationToken = DB.getString('authorization');
        if (GetUtils.isNullOrBlank(authorizationToken) == false) {
          request.headers['Authorization'] = 'Bearer $authorizationToken';
        }
      }
      return request;
    });

    // 响应拦截器
    getc.httpClient.addResponseModifier((request, response) {
      print('response.statusCode:${response.statusCode}');
      print(response.bodyString);
      if (response.isOk && response.statusCode == 200) {
        return response;
        dynamic res = response.body;

        if (res['code'] == 200) {
          Response rep =
              Response(statusCode: response.statusCode, body: res['data']);
          return rep;
        } else if (res['code'] == 401) {
          Get.dialog(
            AlertDialog(
              title: const Text('友情提示'),
              content: const Text('请先登录'),
              actions: [
                TextButton(
                  onPressed: () {
                    Get.back(); // 关闭弹窗
                  },
                  child: const Text('取消'),
                ),
                TextButton(
                  onPressed: () {
                    Get.back();
                    // 执行确认逻辑
                    Get.toNamed('/login');
                  },
                  child: const Text('确认'),
                ),
              ],
            ),
          );
        } else {
          Get.snackbar('输入有误', res['message']);
        }
        Response rep = Response(statusCode: response.statusCode, body: null);
        return rep;
      }

      // 無内容
      if (response.statusCode == 204) {
        Response rep = Response(statusCode: response.statusCode, body: 'null');
        return rep;
      }

      if (response.statusCode == 400) {
        // AuthService.loginOut();
        // Get.snackbar('請先登錄', 'statusCode：${response.statusCode}');
        // Get.snackbar('請先登錄', '請重新登陸');
        Response rep = Response(statusCode: response.statusCode, body: null);
        return rep;
      }

      if (response.statusCode == 401) {
        // print(response.bodyString);
        // AuthService.loginOut();
        // Get.snackbar('請先登錄', 'statusCode：${response.statusCode}');
        Get.snackbar('請先登錄', '請重新登陸');
        Response rep = Response(statusCode: response.statusCode, body: null);
        return rep;
      }
      if (response.statusCode == 504) {
        // print(response.bodyString);
        // AuthService.loginOut();
        // Get.snackbar('請先登錄', 'statusCode：${response.statusCode}');
        Get.snackbar('請先登錄', '請重新登陸');
        Response rep = Response(statusCode: response.statusCode, body: null);
        return rep;
      }
      if (response.statusCode != 200) {
        Get.snackbar('服务器异常', 'statusCode：${response.statusCode}');
        Response rep = Response(statusCode: response.statusCode, body: null);
        return rep;
      }
      if (response.hasError) {
        Get.snackbar('未知错误', 'statusCode${response.statusCode}');
        Response rep = Response(statusCode: response.statusCode, body: null);
        return rep;
      }
      return response;
    });

    return this;
  }

  static Future<dynamic> login(
    String username,
    String password,
  ) async {
    final params = {
      'grant_type': 'password',
      'username': username,
      'password': password,
    };

    final body = params.entries
        .map((entry) => '${Uri.encodeComponent(entry.key)}=${entry.value}')
        .join('&');
    Map<String, String>? headers = {
      'Origin': 'https://4s-member-sit.elchk.org.hk',
      'Referer': 'https://4s-member-sit.elchk.org.hk/',
      'User-Agent':
          'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
      'Host': '4s-id-sit.elchk.org.hk',
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Basic NHNNb2JpbGU6'
    };
    DB.remove('authorization');
    //getc.httpClient.defaultContentType = 'application/x-www-form-urlencoded';
    setBaseUrl('https://4s-id-sit.elchk.org.hk/');
    String path = "connect/token";
    //print(body);
    Response<dynamic> response = await getc.post(path, body, headers: headers);
    resetBaseUrl();
    dynamic res = response.body;
    // print(res);
    return res;
  }

  static Future<dynamic> post(String path,
      {dynamic data, Duration? duration, Map<String, String>? headers}) async {
    print(getc.httpClient.baseUrl);
    print(path);
    print(getc.httpClient.defaultContentType);
    print(data);

    if (duration != null) {
      // dynamic body = getCache(path, data);
      String key = _cacheKey(path, data);
      dynamic body = Cache.get(key);
      if (body != null) return body;
      print('获取缓存失败：进入api请求');
    }

    Response<dynamic> response = await getc.post(path, data, headers: headers);
    dynamic res = response.body;
    if (duration != null && res != null) {
      String key = _cacheKey(path, data);
      Cache.set(key, res, duration);
    }
    return res;
  }

  static Future<dynamic> get(String path,
      {dynamic data, Duration? duration, Map<String, String>? headers}) async {
    // print(getc.httpClient.baseUrl);
    // print(path);
    // print(data);
    if (duration != null) {
      // dynamic body = getCache(path, data);
      String key = _cacheKey(path, data);
      dynamic body = Cache.get(key);
      if (body != null) return body;
      print('获取缓存失败：进入api请求');
    }
    Response<dynamic> response =
        await getc.get("$path?$data", headers: headers);
    dynamic res = response.body;
    if (duration != null && res != null) {
      String key = _cacheKey(path, data);
      Cache.set(key, res, duration);
      // setCache(path, data, res, duration);
    }
    return res;
  }

  static Future<dynamic> getImage(int postId, {Duration? duration}) async {
    String path = 'ProgramInfo/$postId/Image';
    Duration duration = const Duration(hours: 100);
    var data = {};
    // print(getc.httpClient.baseUrl);
    // print(path);
    // print(data);

    // dynamic body = getCache(path, data);
    String key = _cacheKey(path, data);
    dynamic body = Cache.get(key);
    // print('get key:$key');
    // print('get key body:$body');
    if (body == 'none') return null;
    if (body != null) return body;
    // print('获取缓存失败：进入api请求');
    Response<dynamic> response = await getc.get(path);
    dynamic res = response.body;

    print('set key:$key');
    print('response.statusCode:${response.statusCode}');
    if (response.statusCode == 204) {
      Cache.set(key, 'none', duration);
      return null;
    }
    if (res != null) {
      // 去除图片头部数据base64信息
      String imageUrl =
          res.replaceFirst(RegExp(r'data:image\/[a-zA-Z]+;base64,'), '');
      Cache.set(key, imageUrl, duration);
      return imageUrl;
    }
    return res;
  }

  static String _cacheKey(String path, dynamic data) {
    return '${AuthService.currentUserId}:$path?$data';
  }
}
