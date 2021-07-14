import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_git_app/common/GitApi.dart';
import 'package:my_git_app/common/Global.dart';
import 'package:my_git_app/models/index.dart';
import 'package:provider/provider.dart';

class LoginRoute extends StatefulWidget {
  _LoginRouteState createState() => _LoginRouteState();
}

class _LoginRouteState extends State<LoginRoute> {
  TextEditingController _unameController = new TextEditingController();
  TextEditingController _pwdController = new TextEditingController();
  bool pwdShow = false; // 是否展示明文密码
  GlobalKey _formKey = new GlobalKey<FormState>();
  bool _nameAutoFocus = true;

  @override
  void initState() {
    _unameController.text = Global.profile.lastLogin;
    if (_unameController.text.isNotEmpty) {
      // 如果上次有登录用户，则直接定位密码框
      _nameAutoFocus = false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('登录'),
      ),
      body: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.always,
              child: Column(
                children: [
                  TextFormField(
                    autofocus: _nameAutoFocus,
                    controller: _unameController,
                    decoration: InputDecoration(
                        hintText: '输入github账号',
                        labelText: '账号',
                        prefixIcon: Icon(Icons.person)),
                    validator: (e) {
                      return e.trim().isNotEmpty ? null : '账号不能为空';
                    },
                  ),
                  TextFormField(
                    autofocus: !_nameAutoFocus,
                    controller: _pwdController,
                    decoration: InputDecoration(
                        hintText: '输入密码',
                        labelText: '密码',
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                            icon: Icon(pwdShow
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                pwdShow = !pwdShow;
                              });
                            })),
                    obscureText: !pwdShow,
                    validator: (e) {
                      return e.trim().isNotEmpty ? null : '密码不能为空';
                    },
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: ConstrainedBox(
                        constraints: BoxConstraints.expand(height: 55),
                        child: RaisedButton(
                          onPressed: _onLogin,
                          color: Theme.of(context).primaryColor,
                          textColor: Colors.white,
                          child: Text('登录'),
                        ),
                      )),
                ],
              ))),
    );
  }

  void _onLogin() async {
    if (!(_formKey.currentState as FormState).validate()) return;
    User user;
    try {
      user =
          await Git(context).login(_unameController.text, _pwdController.text);
      Provider.of<UserModel>(context, listen: false).user = user;
    } catch (e) {
      print(e.toString());
    }
    if (user != null) {
      Navigator.of(context).pop();
    }
  }
}
