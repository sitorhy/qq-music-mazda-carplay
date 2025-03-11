import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qq_music_client_app/pages/not_found_page.dart';
import 'package:qq_music_client_app/views/home/categorized_playlists/categorized_playlists.dart';
import 'package:qq_music_client_app/views/home/my_favourite_playlists/my_favourite_playlists.dart';
import 'package:qq_music_client_app/views/home/my_favourite_singers/my_favourite_singers.dart';
import 'package:qq_music_client_app/views/home/my_playlists/my_playlists.dart';
import 'package:qq_music_client_app/views/home/recommendation/recommendation.dart';
import 'package:qq_music_client_app/views/home/settings/settings.dart';

class _AnimatedHomeContent extends AnimatedWidget {
  final Widget child;
  final TextDirection direction;

  const _AnimatedHomeContent(
      {required this.direction,
      required Animation<double> animation,
      required this.child})
      : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    double offset = 128.0;
    return Transform.translate(
      offset: Offset(
          direction == TextDirection.rtl
              ? (1.0 - animation.value) * offset
              : -(1.0 - animation.value) * offset,
          0),
      child: Opacity(opacity: animation.value, child: child),
    );
  }
}

class _HomePage extends Page {
  final Widget child;
  final TextDirection direction;

  const _HomePage({super.key, required this.child, required this.direction});

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return child;
      },
      transitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = 0.0;
        const end = 1.0;
        const curve = Curves.ease;

        final tween = Tween(begin: begin, end: end);
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: curve,
        );

        return _AnimatedHomeContent(
          direction: direction,
          animation: tween.animate(curvedAnimation),
          child: child,
        );
      },
    );
  }
}

class HomePageContentRouterDelegate extends RouterDelegate<String>
    with PopNavigatorRouterDelegateMixin<String>, ChangeNotifier {
  final GlobalKey<NavigatorState> globalKey;
  final List<String> _stack = ["/categorized"];

  HomePageContentRouterDelegate({required this.globalKey});

  @override
  Widget build(BuildContext context) {
    var pages = _stack.map((configuration) {
      switch (configuration) {
        case "/categorized":
          {
            return _HomePage(
              key: ValueKey(configuration),
              direction: TextDirection.ltr,
              child: CategorizedPlaylists(),
            );
          }
        case "/recommendation":
          {
            return _HomePage(
              key: ValueKey(configuration),
              direction: TextDirection.rtl,
              child: Recommendation(),
            );
          }
        case "/my_playlists":
          {
            return _HomePage(
              key: ValueKey(configuration),
              direction: TextDirection.ltr,
              child: MyPlaylists(),
            );
          }
        case "/my_favourite_playlists":
          {
            return _HomePage(
              key: ValueKey(configuration),
              direction: TextDirection.rtl,
              child: MyFavouritePlaylists(),
            );
          }
        case "/my_favourite_singers":
          {
            return _HomePage(
              key: ValueKey(configuration),
              direction: TextDirection.ltr,
              child: MyFavouriteSingers(),
            );
          }
        case "/settings":
          {
            return _HomePage(
              key: ValueKey(configuration),
              direction: TextDirection.rtl,
              child: Settings(),
            );
          }
        default:
          return NotFoundPage(key: ValueKey(configuration));
      }
    }).toList();
    return Navigator(
      pages: pages,
      onDidRemovePage: (page) {
        _stack.remove((page.key as ValueKey<String>).value);
      },
    );
  }

  @override
  GlobalKey<NavigatorState>? get navigatorKey => globalKey;

  @override
  Future<void> setNewRoutePath(String configuration) {
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
