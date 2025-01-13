import 'package:flutter/material.dart';
import '../widgets/sliver/sliver_widget.dart';
import '../widgets/title/title_widget.dart';

class ListAnimeScreen extends StatelessWidget {
  final String? tag;
  final String title;
  final Color colorTitle;
  final TextEditingController controller;
  final int count;
  final Function(BuildContext context, int index) itemBuilder;
  const ListAnimeScreen(
      {super.key,
      required this.tag,
      required this.title,
      required this.colorTitle,
      required this.itemBuilder,
      required this.count,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
        body: CustomScrollView(slivers: [
      SliverAppBar(
          snap: true,
          floating: true,
          title: TitleBannerWidget(title: title, color: colorTitle, tag: tag)),
      SliverAppBarSearch(
          controller: controller,
          snapFloatingPinned: false,
          isFlexibleSpaceBar: false),
      SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
          sliver: SliverGrid.builder(
              itemCount: count,
              itemBuilder: (context, index) => itemBuilder(context, index),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  maxCrossAxisExtent: 150,
                  mainAxisExtent: 300)))
    ]));
  }
}
