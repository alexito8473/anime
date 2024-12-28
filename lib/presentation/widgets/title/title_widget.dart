import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TitleWidget extends StatelessWidget {
  final String title;
  final int maxLines;
  final TextStyle textStyle;
  final String tag;
  const TitleWidget(
      {super.key,
      required this.title,
      required this.maxLines,
      required this.textStyle,
        required this.tag});

  @override
  Widget build(BuildContext context) {
    return Hero(
        tag: tag,
        child: AutoSizeText(title, style: textStyle, maxLines: maxLines));
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
    return Container(
        constraints: const BoxConstraints(minHeight: 40),
        height: size.height * 0.07,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title,
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
            child: AutoSizeText("Animes en emisión",
                maxLines: 1,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.green, fontWeight: FontWeight.bold))));
  }
}
