import 'package:flukit/flukit.dart';
import 'package:flutter/material.dart';
import 'package:my_git_app/common/GitApi.dart';
import 'package:my_git_app/common/Global.dart';
import 'package:my_git_app/models/index.dart';
import 'package:provider/provider.dart';

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
      body: _buildBody(context),
    );
  }
}

Widget _buildBody(BuildContext context) {
  UserModel userModel = Provider.of<UserModel>(context);
  if (!userModel.isLogin) {
    return Center(
      child: RaisedButton(
        child: Text('登录'),
        onPressed: () => Navigator.of(context).pushNamed('login'),
      ),
    );
  } else {
    return InfiniteListView<Repo>(
      onRetrieveData: (int page, List<Repo> items, bool refresh) async {
        var r = await Git(context).getRepos(
            refresh: refresh, queryParameters: {'page': page, 'page_size': 20});
        items.addAll(r);
        return r.length == 20;
      },
      itemBuilder: (List list, int index, BuildContext context) {
        return ListTile(
          leading: new CircleAvatar(
            backgroundColor: Colors.blue,
            child: Text('$index'),
          ),
          title: Text(list[index].name),
          subtitle: Text(list[index].description ?? '暂无简介'),
          trailing: Icon(Icons.arrow_right),
        );
      },
    );
  }
}
