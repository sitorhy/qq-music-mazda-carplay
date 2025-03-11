import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qq_music_client_app/router/client_router_delegate.dart';
import 'package:qq_music_client_app/router/client_route_information_parser.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(ClientApp());
}

class ClientApp extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  
  ClientApp({super.key});

  /// MaterialApp.router 初始化
  /// RouterDelegate 必须项，路由代理
  /// RouteInformationParser 必须项，路由信息解析
  /// backButtonDispatcher 返回事件 回退键
  /// TransitionDelegate 转场动画

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'QQMusic Carplay',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      //home: const Scaffold(
        // body: WidgetsTestPage(),
      //  body: HomeView(),
      //),
      routeInformationParser: ClientRouteInformationParser(),
      routerDelegate: ClientRouterDelegate(globalKey: navigatorKey),
    );
  }
}
