import 'package:flutter/material.dart';

class HomeRoute extends StatefulWidget {
  _HomeRouteState createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('项目'),
      ),
      body: Center(
        child: Column(
          children: [
            Text('首页'),
            RaisedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('login');
              },
              child: Text('登录'),
            )
          ],
        ),
      ),
    );
  }
}
