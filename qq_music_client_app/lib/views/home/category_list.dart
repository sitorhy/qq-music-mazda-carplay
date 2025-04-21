import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:qq_music_client_app/widgets/category_select_option.dart';
import 'package:qq_music_client_app/widgets/circle_image_select_option.dart';
import 'package:qq_music_client_app/widgets/positioned_single_scroll_item.dart';
import 'package:qq_music_client_app/widgets/positioned_single_scroll_view.dart';

class Category {
  final String imageUrl;
  final String title;
  final String description;
  final String tag;

  Category({
    required this.title,
    this.description = "",
    this.tag = "",
    this.imageUrl = "",
  });
}

class CategoryList extends StatelessWidget {
  final List<Category> categories;
  final int activeIndex;
  final void Function (int index)? onActiveIndexChange;

  const CategoryList({
    super.key,
    this.activeIndex = -1,
    this.categories = const [],
    this.onActiveIndexChange,
  });

  @override
  Widget build(BuildContext context) {
    return PositionedSingleScrollView(
      scrollDirection: Axis.horizontal,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: categories.mapIndexed((index, category) {
        return PositionedSingleScrollItem(
          child: GestureDetector(
            child: Container(
              padding: EdgeInsets.fromLTRB(index == 0 ? 0 : 6, 0, 0, 0),
              child: category.imageUrl.isEmpty
                  ? CategorySelectOption(
                      text: category.title,
                      active: index == activeIndex,
                    )
                  : CircleImageSelectOption(
                      imageUrl: category.imageUrl,
                      text: category.title,
                      active: index == activeIndex,
                    ),
            ),
            onTap: () {
              if (onActiveIndexChange != null) {
                  onActiveIndexChange!(index);
              }
            },
          ),
        );
      }).toList(),
    );
  }
}
