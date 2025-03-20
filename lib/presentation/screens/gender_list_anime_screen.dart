import 'package:anime/presentation/widgets/banner/banner_widget.dart';
import 'package:flutter/material.dart';

import '../../data/model/gender_anime_page.dart';

class GenderListAnimeScreen extends StatelessWidget {
  final GlobalKey? targetKey;
  final ScrollController scrollController;
  final GenderAnimeForPage genderAnimeForPage;
  final bool isCollapsed;
  final Function goUp;

  const GenderListAnimeScreen({super.key,
    required this.targetKey,
    required this.scrollController,
    required this.genderAnimeForPage,
    required this.isCollapsed,
    required this.goUp});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverAppBar.large(
            centerTitle: true,
            pinned: true,
            expandedHeight: 250,
            actions: [
              if (isCollapsed)
                IconButton(onPressed: () => goUp(), icon: Icon(Icons.move_up))
            ],
            title: Text(genderAnimeForPage.typeVersionAnime.name,
                style: Theme
                    .of(context)
                    .textTheme
                    .titleLarge),
            flexibleSpace: FlexibleSpaceBar(
              background: Material(
                  child: Hero(
                    tag: genderAnimeForPage.typeVersionAnime.name,
                    child: ShaderMask(
                        shaderCallback: (bounds) {
                          return LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black26,
                                Colors.black,
                              ]).createShader(bounds);
                        },
                        blendMode: BlendMode.darken,
                        child: Image.asset(
                          genderAnimeForPage.typeVersionAnime.getImage(),
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                        )),
                  )),
            ),
          ),
          SliverPadding(
              padding: EdgeInsets.symmetric(
                  vertical: size.height * 0.02, horizontal: size.width * 0.08),
              sliver: SliverGrid.builder(
                itemCount: genderAnimeForPage.listAnime.length,
                itemBuilder: (context, index) {
                  return BannerAnime(
                      anime: genderAnimeForPage.listAnime[index],
                      tag:
                      "${genderAnimeForPage.listAnime[index].title} $index");
                },
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    mainAxisExtent: 250,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 20,
                    maxCrossAxisExtent: 150),
              ))
        ],
      ),
    );
  }
}
