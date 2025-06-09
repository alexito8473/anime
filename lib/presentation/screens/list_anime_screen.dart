import 'package:flutter/material.dart';
import '../../data/model/anime.dart';
import '../widgets/banner/banner_widget.dart';
import '../widgets/sliver/sliver_widget.dart';
import '../widgets/title/title_widget.dart';

class ListAnimeScreen extends StatelessWidget {
  final String? tag;
  final String title;
  final Color colorTitle;
  final List<Anime> listAnime;
  final TextEditingController controller;
  final void Function(String id, String? tag) onTapElement;

  const ListAnimeScreen(
      {super.key,
      required this.tag,
      required this.title,
      required this.colorTitle,
      required this.controller,
      required this.listAnime,
      required this.onTapElement});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final ThemeData theme = Theme.of(context);
    final bool isPortrait =
        MediaQuery.orientationOf(context) == Orientation.portrait;
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
              itemCount: listAnime.length,
              itemBuilder: (context, index) => BannerAnime(
                    size: size,
                    theme: theme,
                    isPortrait: isPortrait,
                    anime: listAnime[index],
                    tag: tag,
                    onTapElement: ({required id, tag, required title}) =>
                        onTapElement(id, tag)),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  maxCrossAxisExtent: 150,
                  mainAxisExtent: 300)))
    ]));
  }
}
