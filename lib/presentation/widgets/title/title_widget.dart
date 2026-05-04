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
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 4,
          height: 22,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [color, color.withAlpha(100)],
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        TitleWidget(
            tag: tag,
            maxLines: 1,
            title: title,
            isAutoSize: true,
            textStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontSize: 20,
                shadows: shadows,
                fontWeight: FontWeight.bold,
                color: color)),
      ],
    );
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
            ? Container(
                constraints: const BoxConstraints(maxHeight: 100),
                child: AutoSizeText(
                  title,
                  style: textStyle,
                  maxLines: maxLines,
                ),
              )
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
  final double minHeight;
  const SubTilesAnime(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.size,
      this.minHeight=90});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
        constraints: BoxConstraints(maxHeight: minHeight, maxWidth: 160),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: const Color(0xFF7C4DFF), fontWeight: FontWeight.w600)),
                ),
                const SizedBox(height: 2),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFFCBD5E1),
                        fontWeight: FontWeight.w500,
                      ),
                ),
                )]),
        ));
  }
}

class SliverTitleAnimeEmissionWidget extends StatelessWidget {
  const SliverTitleAnimeEmissionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return SliverToBoxAdapter(
        child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.05, vertical: size.height * 0.04),
            child: const TitleBannerWidget(
                title: 'Animes en emisión', color: Color(0xFF00BFA5))));
  }
}
