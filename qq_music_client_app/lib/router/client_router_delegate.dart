import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qq_music_client_app/pages/home_page.dart';
import 'package:qq_music_client_app/pages/immersive_page.dart';
import 'package:qq_music_client_app/pages/not_found_page.dart';

class ClientRouterDelegate extends RouterDelegate<String>
    with PopNavigatorRouterDelegateMixin<String>, ChangeNotifier {
  final List<String> _stack = ["/"];
  final GlobalKey<NavigatorState> globalKey;

  ClientRouterDelegate({required this.globalKey});

  static ClientRouterDelegate of(BuildContext context) {
      return Router.of(context).routerDelegate as ClientRouterDelegate;
  }

  @override
  Widget build(BuildContext context) {
    var pages = _stack.map((configuration) {
      switch (configuration) {
        case "/":
          {
            return HomePage(key: ValueKey(configuration));
          }
        case "/immersive":
          {
            return ImmersivePage(key: ValueKey(configuration));
          }
        default:
          return NotFoundPage(key: ValueKey(configuration));
      }
    }).toList();
    return Navigator(
      key: navigatorKey,
      pages: pages,
      // Called when the Route associated with the given Page has been removed from the Navigator.
      onDidRemovePage: (page) {
        // pages.remove(page);
        _stack.remove((page.key as ValueKey<String>).value);
      },
    );
  }

  @override
  GlobalKey<NavigatorState>? get navigatorKey => globalKey;

  @override
  Future<void> setNewRoutePath(String configuration) {
    // configuration = "/"
    _stack.clear();
    _stack.add(configuration);
    return SynchronousFuture(null);
  }

  push(String path) {
    _stack.add(path);
    notifyListeners();
  }

  void pop() {
    if (_stack.isNotEmpty) {
      _stack.remove(_stack.last);
    }
    notifyListeners();
  }
}
