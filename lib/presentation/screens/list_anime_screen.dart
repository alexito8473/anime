import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widgets/title/title_widget.dart';

class ListAnimeScreen extends StatelessWidget {
  final String? tag;
  final String title;
  final Color colorTitle;
  final Widget floatingChild;
  final int count;
  final Function(BuildContext context, int index) itemBuilder;
  const ListAnimeScreen(
      {super.key,
      required this.tag,
      required this.title,
      required this.colorTitle,
      required this.itemBuilder,
      required this.count,
      required this.floatingChild});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
        floatingActionButton: floatingChild,
        body: CustomScrollView(slivers: [
          SliverAppBar(
              title:
                  TitleBannerWidget(title: title, color: colorTitle, tag: tag)),
          SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
              sliver: SliverGrid.builder(
                  itemCount: count,
                  itemBuilder: (context, index) => itemBuilder(context, index),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      crossAxisSpacing: 20,
                      maxCrossAxisExtent: 150,
                      mainAxisExtent: 300))),
        ]));
  }
}
