import 'package:flutter/material.dart';
import 'package:qq_music_client_app/widgets/page_tab_item.dart';

class PageTabItemPlacement {
  final String name;
  final double itemWidth;
  final double itemHeight;
  final IconData? icon;

  PageTabItemPlacement(
      {required this.name,
      this.itemHeight = 36.0,
      this.itemWidth = 64.0,
      this.icon = Icons.settings});
}

class PageTabs extends StatelessWidget {
  final List<PageTabItemPlacement> itemPlacements;
  final String activePlacementName;
  final void Function(String name, int index)? onItemTap;

  const PageTabs(
      {super.key,
      this.itemPlacements = const [],
      this.activePlacementName = "",
      this.onItemTap});

  @override
  Widget build(BuildContext context) {
    double widthTotal = 0.0;
    var children = itemPlacements
        .asMap()
        .map((index, placement) {
          var map = MapEntry(
            index,
            Positioned(
              left: widthTotal * 0.95,
              child: PageTabItem(
                onTap: () {
                  if (onItemTap != null) {
                    onItemTap!(placement.name, index);
                  }
                },
                width: placement.itemWidth,
                height: placement.itemHeight,
                state: activePlacementName == placement.name
                    ? PageTabItemState.focused
                    : PageTabItemState.normal,
                icon: placement.icon,
              ),
            ),
          );
          widthTotal += placement.itemWidth;
          return map;
        })
        .values
        .toList(growable: true);
    int activeIndex = children.indexWhere(
        (i) => (i.child as PageTabItem).state == PageTabItemState.focused);
    if (activeIndex >= 0 && activeIndex != children.length - 1) {
      Positioned activePositioned = children.removeAt(activeIndex);
      children.add(activePositioned);
    }
    return Stack(
      alignment: AlignmentDirectional.bottomStart,
      children: children,
    );
  }
}
