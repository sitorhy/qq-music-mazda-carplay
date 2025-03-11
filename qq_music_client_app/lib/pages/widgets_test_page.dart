import 'dart:math';

import 'package:flutter/material.dart';
import 'package:qq_music_client_app/theme/client_colors.dart';
import 'package:qq_music_client_app/widgets/album_select_option.dart';
import 'package:qq_music_client_app/widgets/positioned_list_controller.dart';
import 'package:qq_music_client_app/widgets/positioned_list_item.dart';
import 'package:qq_music_client_app/widgets/positioned_list_view.dart';

class WidgetsTestPage extends StatefulWidget {
  const WidgetsTestPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _TestPageState();
  }
}

class _TestPageState extends State<WidgetsTestPage> {
  AlbumSelectOptionStatus _status = AlbumSelectOptionStatus.normal;
  final PositionedListController _controller = PositionedListController();
  int _scrollIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ClientColors.primary,
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            SizedBox(
              width: 535 / 3 * 2,
              child: AlbumSelectOption(
                status: _status,
                title: "带我去找夜生活",
                description: "告五人",
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _status = AlbumSelectOptionStatus.normal;
                    });
                  },
                  child: const Text("Normal"),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _status = AlbumSelectOptionStatus.hover;
                    });
                  },
                  child: const Text("Hover"),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _status = AlbumSelectOptionStatus.active;
                    });
                  },
                  child: const Text("Active"),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              decoration: const BoxDecoration(color: Colors.transparent),
              height: 400,
              width: 535 / 3 * 2,
              child: PositionedListView.separated(
                itemCount: 20,
                controller: _controller,
                separatorExtent: 10,
                itemBuilder: (buildContext, index) {
                  return PositionedListItem(
                    index: index,
                    child: AlbumSelectOption(
                      title: "带我去找夜生活",
                      description: "告五人",
                      status: _scrollIndex == index
                          ? AlbumSelectOptionStatus.active
                          : AlbumSelectOptionStatus.normal,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _scrollIndex = (_scrollIndex + 1) % 20;
                    });
                    _controller.animateToIndex(_scrollIndex);
                  },
                  child: const Text("Next"),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _scrollIndex = max((_scrollIndex - 1), 0);
                    });
                    _controller.animateToIndex(_scrollIndex);
                  },
                  child: const Text("Previous"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
