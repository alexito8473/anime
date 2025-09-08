import 'package:anime/presentation/widgets/banner/banner_widget.dart';
import 'package:flutter/material.dart';

import '../../data/model/gender_anime_page.dart';

class GenderListAnimeScreen extends StatelessWidget {
  final GlobalKey? targetKey;
  final ScrollController scrollController;
  final GenderAnimeForPage genderAnimeForPage;
  final bool isCollapsed;
  final Function goUp;
  final void Function({required String id, String? tag, required String title})
      onTapElement;

  const GenderListAnimeScreen(
      {super.key,
      required this.targetKey,
      required this.scrollController,
      required this.genderAnimeForPage,
      required this.isCollapsed,
      required this.goUp,
      required this.onTapElement});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final ThemeData theme = Theme.of(context);
    final bool isPortrait =
        MediaQuery.orientationOf(context) == Orientation.portrait;
    return Scaffold(
        body: CustomScrollView(controller: scrollController, slivers: [
      SliverAppBar.large(
          centerTitle: true,
          pinned: true,
          expandedHeight: 250,
          actions: [
            if (isCollapsed)
              IconButton(onPressed: () => goUp(), icon: const Icon(Icons.move_up))
          ],
          title: Text(genderAnimeForPage.typeVersionAnime.name,
              style: Theme.of(context).textTheme.titleLarge),
          flexibleSpace: FlexibleSpaceBar(
              background: Material(
                  child: Hero(
                      tag: genderAnimeForPage.typeVersionAnime.name,
                      child: ShaderMask(
                          shaderCallback: (bounds) {
                            return const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black26,
                                  Colors.black54,
                                  Colors.black87,
                                  Colors.black,
                                ]).createShader(bounds);
                          },
                          blendMode: BlendMode.darken,
                          child: Image.asset(
                              genderAnimeForPage.typeVersionAnime.getImage(),
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter)))))),
      SliverPadding(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.05,
            vertical: size.height * 0.05,
          ),
          sliver: SliverGrid.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 150,
                  mainAxisExtent: 300,
                  crossAxisSpacing: 10),
              itemCount: genderAnimeForPage.listAnime.length,
              itemBuilder: (context, index) {
                return BannerAnime(
                    size: size,
                    theme: theme,
                    isPortrait: isPortrait,
                    anime: genderAnimeForPage.listAnime[index],
                    tag: '${genderAnimeForPage.listAnime[index].title} $index',
                    onTapElement: onTapElement);
              })),
    ]));
  }
}
