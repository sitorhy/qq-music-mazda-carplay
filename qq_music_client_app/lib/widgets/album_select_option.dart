import 'package:flutter/material.dart';
import 'package:qq_music_client_app/theme/client_colors.dart';

enum AlbumSelectOptionStatus { normal, hover, active }

class AlbumSelectOption extends StatefulWidget {
  final AlbumSelectOptionStatus status;
  final double fontSize;
  final double subtitleFontSize;
  final String title;
  final String description;
  final bool looseDescription;

  const AlbumSelectOption({
    super.key,
    this.status = AlbumSelectOptionStatus.normal,
    this.fontSize = 28,
    this.subtitleFontSize = 24,
    this.title = "标题",
    this.description = "描述",
    this.looseDescription = false,
  });

  @override
  State<StatefulWidget> createState() {
    return AlbumSelectOptionState();
  }
}

class AlbumSelectOptionState extends State<AlbumSelectOption> {
  @override
  Widget build(BuildContext context) {
    var status = widget.status;

    var backgroundDecoration = DecoratedBox(
      decoration: BoxDecoration(
        color: status == AlbumSelectOptionStatus.hover
            ? ClientColors.focus
            : (status == AlbumSelectOptionStatus.active
                ? ClientColors.border
                : ClientColors.lightPrimary),
      ),
    );

    var activeBackgroundDecoration = AnimatedFractionallySizedBox(
      alignment: Alignment.centerLeft,
      widthFactor: status == AlbumSelectOptionStatus.active ? 1.0 : 0.0,
      heightFactor: 1.0,
      duration: status == AlbumSelectOptionStatus.active
          ? const Duration(milliseconds: 300)
          : const Duration(milliseconds: 0),
      curve: Curves.easeOut,
      child: const DecoratedBox(
        decoration: BoxDecoration(color: ClientColors.subtitleLight),
      ),
    );

    var borderDecoration = DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: status == AlbumSelectOptionStatus.normal
                ? ClientColors.focus
                : ClientColors.textLight,
            width: status == AlbumSelectOptionStatus.active ? 10.0 : 5.0,
          ),
          top: BorderSide(
            color: ClientColors.textLight,
            width: status == AlbumSelectOptionStatus.hover ? 5.0 : 0,
          ),
          right: BorderSide(
            color: ClientColors.textLight,
            width: status == AlbumSelectOptionStatus.hover ? 5.0 : 0,
          ),
          bottom: BorderSide(
            color: ClientColors.textLight,
            width: status == AlbumSelectOptionStatus.hover ? 5.0 : 0,
          ),
        ),
      ),
    );

    var textContainerList = [
      Flexible(
        child: Text(
          widget.title,
          maxLines: 1,
          style: TextStyle(
            overflow: TextOverflow.ellipsis,
            color: status != AlbumSelectOptionStatus.active
                ? ClientColors.text
                : ClientColors.subtitleLight,
            fontWeight: FontWeight.bold,
            fontSize: widget.fontSize,
          ),
        ),
      ),
    ];
    if (widget.description.isNotEmpty || (widget.looseDescription && widget.description.isNotEmpty)) {
      textContainerList.add(
        Flexible(
          child: Text(
            widget.description,
            maxLines: 1,
            style: TextStyle(
              overflow: TextOverflow.ellipsis,
              color: status != AlbumSelectOptionStatus.active
                  ? ClientColors.text
                  : ClientColors.subtitleLight,
              fontSize: widget.subtitleFontSize,
            ),
          ),
        ),
      );
    }
    var textContainer = Container(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: textContainerList,
      ),
    );

    return LayoutBuilder(builder: (context, constraints) {
      return DefaultTextStyle(
        textAlign: TextAlign.center,
        style: const TextStyle(
          decoration: TextDecoration.none,
        ),
        child: Center(
          child: AspectRatio(
            aspectRatio: 535 / (widget.looseDescription && widget.description.isEmpty ? 100 : 150),
            child: Stack(
              fit: StackFit.expand,
              children: [
                backgroundDecoration,
                activeBackgroundDecoration,
                textContainer,
                borderDecoration,
              ],
            ),
          ),
        ),
      );
    });
  }
}
