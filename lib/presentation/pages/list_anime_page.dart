import 'package:anime/presentation/widgets/title/title_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../data/last/anime.dart';
import '../widgets/banner/banner_widget.dart';

class ListAnimePage extends StatelessWidget {
  final String? tag;
  final List<Anime> listAnime;
  final String title;
  final Color colorTitle;
  const ListAnimePage({super.key, required this.tag, required this.listAnime, required this.title, required this.colorTitle});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: TitleBannerWidget(title: title, color: colorTitle,tag: tag,),

          ),
          SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
              sliver: SliverGrid.builder(
                  itemCount: listAnime.length,
                  itemBuilder: (context, index) {
                    return BannerAnime(anime: listAnime[index], tag: tag);
                  },
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 150,mainAxisExtent: 300))),

        ],
      ),
    );
  }
}
