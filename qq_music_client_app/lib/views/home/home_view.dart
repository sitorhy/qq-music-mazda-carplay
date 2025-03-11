import 'package:flutter/material.dart';
import 'package:qq_music_client_app/router/home_page_content_route_information_parser.dart';
import 'package:qq_music_client_app/router/home_page_content_router_delegate.dart';
import 'package:qq_music_client_app/theme/client_colors.dart';
import 'package:qq_music_client_app/views/home/home_view_footer.dart';
import 'package:qq_music_client_app/widgets/page_tabs.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomeViewState();
  }
}

class _HomeViewState extends State<HomeView> {
  String activePlacementName = "1";
  final HomePageContentRouterDelegate routerDelegate =
      HomePageContentRouterDelegate(globalKey: GlobalKey<NavigatorState>());

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: const TextStyle(
        decoration: TextDecoration.none,
        fontSize: 26,
        color: ClientColors.text,
      ),
      child: Container(
        decoration: const BoxDecoration(color: ClientColors.background),
        // padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: ClientColors.background,
                ),
                child: FractionallySizedBox(
                  widthFactor: 1850 / 1945,
                  child: SizedBox(
                    height: 42,
                    child: PageTabs(
                      onItemTap: (name, index) {
                        setState(() {
                          activePlacementName = name;
                          switch(name)  {
                            case "1":
                              routerDelegate.setNewRoutePath("/categorized");
                            case "2":
                              routerDelegate.setNewRoutePath("/recommendation");
                            case "3":
                              routerDelegate.setNewRoutePath("/my_playlists");
                            case "4":
                              routerDelegate.setNewRoutePath("/my_favourite_playlists");
                            case "5":
                              routerDelegate.setNewRoutePath("/my_favourite_singers");
                            case "6":
                              routerDelegate.setNewRoutePath("/settings");
                            default:
                              routerDelegate.setNewRoutePath("/not_found");
                          }
                        });
                      },
                      activePlacementName: activePlacementName,
                      itemPlacements: [
                        PageTabItemPlacement(
                          icon: const IconData(0xf895, fontFamily: "IconFont"),
                          name: "1",
                          itemWidth: 64,
                          itemHeight: 36,
                        ),
                        PageTabItemPlacement(
                          icon: const IconData(0xe7fc, fontFamily: "IconFont"),
                          name: "2",
                          itemWidth: 64,
                          itemHeight: 36,
                        ),
                        PageTabItemPlacement(
                          icon: const IconData(0xe72f, fontFamily: "IconFont"),
                          name: "3",
                          itemWidth: 64,
                          itemHeight: 36,
                        ),
                        PageTabItemPlacement(
                          icon: const IconData(0xe699, fontFamily: "IconFont"),
                          name: "4",
                          itemWidth: 64,
                          itemHeight: 36,
                        ),
                        PageTabItemPlacement(
                          icon: const IconData(0xea4c, fontFamily: "IconFont"),
                          name: "5",
                          itemWidth: 64,
                          itemHeight: 36,
                        ),
                        PageTabItemPlacement(
                          icon: const IconData(0xe60f, fontFamily: "IconFont"),
                          name: "6",
                          itemWidth: 64,
                          itemHeight: 36,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(top: 10),
                  decoration: const BoxDecoration(color: ClientColors.primary),
                  child: Router(
                    routerDelegate: routerDelegate,
                    routeInformationParser:
                        HomePageContentRouteInformationParser(),
                  ),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  color: ClientColors.primary,
                  border: Border(
                    top: BorderSide(
                      color: ClientColors.primary,
                    ),
                  ),
                ),
                height: 46,
                child: const FractionallySizedBox(
                  widthFactor: 1850 / 1945,
                  child: HomeViewFooter(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
