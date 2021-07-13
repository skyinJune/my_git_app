import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_git_app/common/Global.dart';
import 'package:my_git_app/models/index.dart';

class Git {
  // 在网络请求过程中可能会需要使用当前的context信息，比如在请求失败时
  // 打开一个新路由，而打开新路由需要context信息
  Git([this.context]) {
    _options = Options(extra: {'context': context});
  }

  BuildContext context;
  Options _options;
  static Dio dio =
      new Dio(BaseOptions(baseUrl: 'https://api.github.com/', headers: {
    HttpHeaders.acceptHeader: "application/vnd.github.v3+json",
  }));

  static void init() {
    // 添加缓存插件
    dio.interceptors.add(Global.netCache);
    // 设置用户token（可能为null，代表未登录）
    dio.options.headers[HttpHeaders.authorizationHeader] = Global.profile.token;
    // 在调试模式下需要抓包调试，所以我们使用代理，并禁用HTTPS证书校验
    // if (!Global.isRelease) {
    //   (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
    //       (client) {
    //     client.findProxy = (uri) {
    //       return 'PROXY 10.1.10.250:8888';
    //     };
    //     // 代理工具会提供一个抓包的自签名证书，会通不过证书校验，所以我们禁用证书校验
    //     client.badCertificateCallback =
    //         (X509Certificate cert, String host, int port) => true;
    //   };
    // }
  }

  // 登录接口，登录成功后返回用户信息
  Future<User> login(String login, String pwd) async {
    String basic = 'Basic ' + base64.encode(utf8.encode('$login:$pwd'));
    var r = await dio.get('/users/$login',
        options: _options.merge(
            headers: {HttpHeaders.authorizationHeader: basic},
            extra: {'noCache': true}));
    dio.options.headers[HttpHeaders.authorizationHeader] = basic;
    Global.netCache.cache.clear(); // 清空所有缓存
    Global.profile.token = basic; // 更新profile中的token信息
    return User.fromJson(r.data);
  }

  // 获取用户项目列表
  Future<List<Repo>> getRepos(
      {Map<String, dynamic> queryParameters, // quer参数，分页信息等
      refresh = false}) async {
    if (refresh) {
      _options.extra.addAll({'refresh': true, 'list': true});
    }
    var r = await dio.get<List>('user/repos',
        queryParameters: queryParameters, options: _options);
    return r.data.map((e) => Repo.fromJson(e)).toList();
  }
}
