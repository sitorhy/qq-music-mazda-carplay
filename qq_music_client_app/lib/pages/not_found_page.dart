import 'package:flutter/material.dart';
import 'package:fluttericon/fontelico_icons.dart';
import 'package:qq_music_client_app/theme/client_colors.dart';

class NotFoundPage extends Page {
  const NotFoundPage({super.key});

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
        settings: this,
        builder: (BuildContext context) {
          return Container(
            decoration: const BoxDecoration(color: ClientColors.lightPrimary),
            child: const DefaultTextStyle(
              style: TextStyle(
                decoration: TextDecoration.none,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Fontelico.emo_unhappy,
                    size: 30,
                    color: ClientColors.text,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Not Found",
                    style: TextStyle(
                      fontSize: 32,
                      color: ClientColors.text,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
