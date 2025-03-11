import 'package:flutter/material.dart';

class HomePageContentRouteInformationParser
    extends RouteInformationParser<String> {
  @override
  Future<String> parseRouteInformation(RouteInformation routeInformation) {
    return Future.value(routeInformation.uri.path);
  }

  @override
  RouteInformation? restoreRouteInformation(String configuration) {
    RouteInformation information =
        RouteInformation(uri: Uri.tryParse(configuration));
    return information;
  }
}
