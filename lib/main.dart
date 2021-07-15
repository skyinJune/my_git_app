import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:my_git_app/common/Global.dart';
import 'package:my_git_app/routes/HomeRoute.dart';
import 'package:my_git_app/routes/LoginRoute.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 需要加这么一行，不然跑不起来
  await Global.init();
  runApp(MyApp());
}
// void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: <SingleChildWidget>[
        ChangeNotifierProvider.value(value: ThemeModel()),
        ChangeNotifierProvider.value(value: UserModel()),
        ChangeNotifierProvider.value(value: LocaleModel())
      ],
      child: Consumer2<ThemeModel, LocaleModel>(
        builder: (BuildContext context, themeModel, localModel, Widget child) {
          return MaterialApp(
            theme: ThemeData(primarySwatch: themeModel.theme),
            home: HomeRoute(),
            locale: localModel.getLocale(),
            supportedLocales: [
              const Locale('en', 'US'), // 美国英语
              const Locale('zh', 'CN'), // 中文简体
              //其它Locales
            ],
            localizationsDelegates: [
              // 本地化的代理类
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            routes: <String, WidgetBuilder>{
              'home': (context) => HomeRoute(),
              'login': (context) => LoginRoute()
            },
          );
        },
      ),
    );
  }
}
