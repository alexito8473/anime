import 'package:anime/data/enums/type_data.dart';
import 'package:anime/presentation/pages/list_anime_page.dart';
import 'package:flutter/material.dart';

import '../../../data/interface/anime_interface.dart';

class ButtonNavigateListAnimeWidget extends StatelessWidget {
  final Color color;
  final List<AnimeBanner> animes;
  final String tag;
  final String title;
  final Color colorTitle;
  final TypeAnime typeAnime;

  const ButtonNavigateListAnimeWidget({
    super.key,
    required this.color,
    required this.animes,
    required this.tag,
    required this.title,
    required this.colorTitle,
    required this.typeAnime,
  });

  void navigateListAnime(BuildContext context) {
    Navigator.push(
        context,
        PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 600),
            pageBuilder: (_, __, ___) => ListAnimePage(
                tag: tag,
                title: title,
                colorTitle: colorTitle,
                typeAnime: typeAnime),
            transitionsBuilder: (_, animation, __, child) =>
                FadeTransition(opacity: animation, child: child)));
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(backgroundColor: WidgetStateProperty.all(color)),
        onPressed: () => navigateListAnime(context),
        child: const Text('Ver todos'));
  }
}
