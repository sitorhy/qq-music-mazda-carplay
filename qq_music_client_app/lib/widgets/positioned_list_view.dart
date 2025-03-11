import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:qq_music_client_app/widgets/positioned_list_controller.dart';
import 'package:qq_music_client_app/widgets/positioned_list_item.dart';

/// ListView特化
/// 滚动到指定列表项位置，且列表项在列表组件中间
/// 适用于等尺寸列表项布局，ListView存在回收机制，不会渲染所有项目，未渲染项目无法获取尺寸
/// 列表项尺寸不一致使用PositionedSingleScrollView
class PositionedListView extends StatelessWidget {
  final ListView child;
  final Axis scrollDirection;
  final PositionedListController? controller;

  PositionedListView({
    super.key,
    Key? listViewKey,
    this.scrollDirection = Axis.vertical,
    bool reverse = false,
    this.controller,
    bool? primary,
    ScrollPhysics? physics,
    bool shrinkWrap = false,
    EdgeInsetsGeometry? padding,
    double? itemExtent,
    double? Function(int, SliverLayoutDimensions)? itemExtentBuilder,
    Widget? prototypeItem,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    double? cacheExtent,
    List<Widget> children = const <Widget>[],
    int? semanticChildCount,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
        ScrollViewKeyboardDismissBehavior.manual,
    String? restorationId,
    Clip clipBehavior = Clip.hardEdge,
    HitTestBehavior hitTestBehavior = HitTestBehavior.opaque,
  }) : child = (ListView(
          key: listViewKey,
          scrollDirection: scrollDirection,
          reverse: reverse,
          controller: controller,
          primary: primary,
          physics: physics,
          shrinkWrap: shrinkWrap,
          padding: padding,
          itemExtent: itemExtent,
          itemExtentBuilder: itemExtentBuilder,
          prototypeItem: prototypeItem,
          addAutomaticKeepAlives: addAutomaticKeepAlives,
          addRepaintBoundaries: addRepaintBoundaries,
          addSemanticIndexes: addSemanticIndexes,
          cacheExtent: cacheExtent,
          semanticChildCount: semanticChildCount,
          dragStartBehavior: dragStartBehavior,
          keyboardDismissBehavior: keyboardDismissBehavior,
          restorationId: restorationId,
          clipBehavior: clipBehavior,
          hitTestBehavior: hitTestBehavior,
          children: children,
        ));

  PositionedListView.builder({
    super.key,
    Key? listViewKey,
    this.scrollDirection = Axis.vertical,
    bool reverse = false,
    this.controller,
    bool? primary,
    ScrollPhysics? physics,
    bool shrinkWrap = false,
    EdgeInsetsGeometry? padding,
    double? itemExtent,
    double? Function(int, SliverLayoutDimensions)? itemExtentBuilder,
    Widget? prototypeItem,
    required PositionedListItem? Function(BuildContext, int) itemBuilder,
    int? Function(Key)? findChildIndexCallback,
    int? itemCount,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    double? cacheExtent,
    int? semanticChildCount,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
        ScrollViewKeyboardDismissBehavior.manual,
    String? restorationId,
    Clip clipBehavior = Clip.hardEdge,
    HitTestBehavior hitTestBehavior = HitTestBehavior.opaque,
  }) : child = ListView.builder(
          key: listViewKey,
          scrollDirection: scrollDirection,
          reverse: reverse,
          controller: controller,
          primary: primary,
          physics: physics,
          shrinkWrap: shrinkWrap,
          padding: padding,
          itemExtent: itemExtent,
          itemExtentBuilder: itemExtentBuilder,
          prototypeItem: prototypeItem,
          itemBuilder: itemBuilder,
          findChildIndexCallback: findChildIndexCallback,
          itemCount: itemCount,
          addAutomaticKeepAlives: addAutomaticKeepAlives,
          addRepaintBoundaries: addRepaintBoundaries,
          addSemanticIndexes: addSemanticIndexes,
          cacheExtent: cacheExtent,
          semanticChildCount: semanticChildCount,
          dragStartBehavior: dragStartBehavior,
          keyboardDismissBehavior: keyboardDismissBehavior,
          restorationId: restorationId,
          clipBehavior: clipBehavior,
          hitTestBehavior: hitTestBehavior,
        );

  PositionedListView.separated({
    super.key,
    Key? listViewKey,
    this.scrollDirection = Axis.vertical,
    bool reverse = false,
    this.controller,
    bool? primary,
    ScrollPhysics? physics,
    bool shrinkWrap = false,
    EdgeInsetsGeometry? padding,
    required PositionedListItem? Function(BuildContext, int) itemBuilder,
    int? Function(Key)? findChildIndexCallback,
    double separatorExtent = 0.0,
    required int itemCount,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    double? cacheExtent,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
        ScrollViewKeyboardDismissBehavior.manual,
    String? restorationId,
    Clip clipBehavior = Clip.hardEdge,
    HitTestBehavior hitTestBehavior = HitTestBehavior.opaque,
  }) : child = ListView.separated(
          key: listViewKey,
          scrollDirection: scrollDirection,
          reverse: reverse,
          controller: controller,
          primary: primary,
          physics: physics,
          shrinkWrap: shrinkWrap,
          padding: padding,
          itemBuilder: itemBuilder,
          findChildIndexCallback: findChildIndexCallback,
          separatorBuilder: (buildContext, index) {
            if (scrollDirection == Axis.vertical) {
              return ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: separatorExtent,
                  minHeight: separatorExtent,
                ),
              );
            } else {
              return ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: separatorExtent,
                  minWidth: separatorExtent,
                ),
              );
            }
          },
          itemCount: itemCount,
          addAutomaticKeepAlives: addAutomaticKeepAlives,
          addRepaintBoundaries: addRepaintBoundaries,
          addSemanticIndexes: addSemanticIndexes,
          cacheExtent: cacheExtent,
          dragStartBehavior: dragStartBehavior,
          keyboardDismissBehavior: keyboardDismissBehavior,
          restorationId: restorationId,
          clipBehavior: clipBehavior,
          hitTestBehavior: hitTestBehavior,
        );

  @override
  Widget build(BuildContext context) {
    return NotificationListener<PositionedListItemLayoutNotification>(
      onNotification: (notification) {
        if (scrollDirection == Axis.vertical) {
          controller?.itemExtent = notification.height;
        } else {
          controller?.itemExtent = notification.width;
        }
        return true;
      },
      child: child,
    );
  }
}
