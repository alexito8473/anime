import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../animation/hero_animation_widget.dart';

class TitleBannerWidget extends StatelessWidget {
  final String title;
  final String? tag;
  final Color color;
  final List<Shadow>? shadows;

  const TitleBannerWidget(
      {super.key,
      this.tag,
      required this.title,
      required this.color,
      this.shadows});

  @override
  Widget build(BuildContext context) {
    return TitleWidget(
        tag: tag,
        maxLines: 1,
        title: title,
        isAutoSize: false,
        textStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
            fontSize: 18,
            shadows: shadows,
            fontWeight: FontWeight.bold,
            color: color));
  }
}

class TitleWidget extends StatelessWidget {
  final String title;
  final int maxLines;
  final TextStyle textStyle;
  final String? tag;
  final bool isAutoSize;

  const TitleWidget(
      {super.key,
      required this.title,
      required this.maxLines,
      required this.textStyle,
      required this.tag,
      this.isAutoSize = true});

  @override
  Widget build(BuildContext context) {
    return HeroAnimationWidget(
        heroTag: title,
        tag: tag,
        child: isAutoSize
            ? AutoSizeText(title, style: textStyle, maxLines: maxLines)
            : Text(title,
                style: textStyle,
                maxLines: maxLines,
                softWrap: true,
                overflow: TextOverflow.ellipsis));
  }
}

class SubTilesAnime extends StatelessWidget {
  final String title;
  final String subtitle;
  final Size size;

  const SubTilesAnime(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.size});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 80),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AutoSizeText(title,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: Colors.blue)),
              AutoSizeText(subtitle,
                  style: Theme.of(context).textTheme.bodySmall, maxLines: 2)
            ]));
  }
}

class SliverTitle extends StatelessWidget {
  const SliverTitle({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return SliverToBoxAdapter(
        child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.05, vertical: size.height * 0.05),
            child: const TitleBannerWidget(
                title: "Animes en emisión", color: Colors.green)));
  }
}
