import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:qq_music_client_app/widgets/category_select_option.dart';
import 'package:qq_music_client_app/widgets/positioned_single_scroll_item.dart';
import 'package:qq_music_client_app/widgets/positioned_single_scroll_view.dart' show PositionedSingleScrollView;

class Category {
  final String title;
  final String description;
  final String tag;

  Category({required this.title, this.description = "", this.tag = ""});
}

class CategoryList extends StatefulWidget {
  final List<Category> categories;

  const CategoryList({super.key, this.categories = const []});

  @override
  State<StatefulWidget> createState() {
    return _CategoryListState();
  }
}

class _CategoryListState extends State<CategoryList> {
  int active = 1;
  List<String> titles = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PositionedSingleScrollView(
      scrollDirection: Axis.horizontal,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.categories.mapIndexed((index, category) {
        return PositionedSingleScrollItem(
          child: GestureDetector(
            child: Container(
              padding: EdgeInsets.fromLTRB(index == 0 ? 0 : 6, 0, 0, 0),
              child: CategorySelectOption(
                text: category.title,
                active: index == active,
              ),
            ),
            onTap: () {
              setState(() {
                active = index;
              });
            },
          ),
        );
      }).toList(),
    );
  }
}