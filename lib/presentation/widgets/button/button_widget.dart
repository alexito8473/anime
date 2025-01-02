import 'package:anime/presentation/pages/list_anime_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../data/last/anime.dart';

class ButtonNavigateListAnime extends StatelessWidget {
  final Color color;
  final List<Anime> animes;
  final String tag;
  final String title;
  final Color colorTitle;
  const ButtonNavigateListAnime(
      {super.key,
      required this.color,
      required this.animes,
      required this.tag, required this.title, required this.colorTitle});

  void navigateListAnime({required BuildContext context}) {
    Navigator.push(
        context,
        PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 600),
            pageBuilder: (context, animation, secondaryAnimation) =>
                ListAnimePage(tag: tag, listAnime: animes, title: title, colorTitle: colorTitle),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    FadeTransition(opacity: animation, child: child)));
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(color)),
        onPressed: () => navigateListAnime(context: context),
        child: const Text("Ver todos"));
  }
}
