import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginRoute extends StatefulWidget {
  _LoginRouteState createState() => _LoginRouteState();
}

class _LoginRouteState extends State<LoginRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('登录'),
      ),
      body: Column(
        children: [Text('用户名'), Text('密码')],
      ),
    );
  }
}
