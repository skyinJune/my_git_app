import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_git_app/models/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _themes = <MaterialColor>[
  Colors.blue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.red,
];

class Global {
  static SharedPreferences _preferences;
  static Profile profile = Profile();
  static CacheConfig cacheConfig = CacheConfig(); // 网络缓存对象
  static List<MaterialColor> get themes => _themes; // 可选的主题列表
  static bool get isRelease =>
      bool.fromEnvironment("dart.vm.product"); // 是否为release版

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
    var _profile = _preferences.getString('profile');
    if (_profile != null) {
      try {
        profile = Profile.fromJson(jsonDecode(_profile));
      } catch (e) {
        print(e);
      }
    }

    // 如果没有缓存策略，设置默认缓存策略
    profile.cache = profile.cache ?? CacheConfig()
      ..enable = true
      ..maxAge = 3600
      ..maxCount = 100;

    //初始化网络请求相关配置
    // Git.init();
  }
}
