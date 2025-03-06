import 'package:anime/domain/bloc/anime/anime_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/enums/type_my_animes.dart';
import '../widgets/banner/banner_widget.dart';

class SavePage extends StatefulWidget {
  const SavePage({super.key});

  @override
  State<SavePage> createState() => _SavePageState();
}

class _SavePageState extends State<SavePage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return BlocBuilder<AnimeBloc, AnimeState>(builder: (context, state) {
      return DefaultTabController(
          length: TypeMyAnimes.values.length - 1, // Número de pestañas
          child: Column(children: [
            TabBar(
                indicatorAnimation: TabIndicatorAnimation.linear,
                physics: ClampingScrollPhysics(),
                isScrollable: true,
                indicatorColor: Colors.orangeAccent,
                tabAlignment: TabAlignment.start,
                labelColor: Colors.yellowAccent,
                dividerColor: Colors.orangeAccent.withAlpha(100),
                tabs: TypeMyAnimes.values
                    .getRange(1, TypeMyAnimes.values.length)
                    .map((e) => Tab(icon: Icon(e.getIcon()), text: e.name))
                    .toList()),
            Expanded(
                child: TabBarView(
                    children: TypeMyAnimes.values
                        .getRange(1, TypeMyAnimes.values.length)
                        .map((e) => GridView.builder(
                            padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.05,
                                vertical: size.height * 0.02),
                            itemBuilder: (context, index) =>
                                BannerAnimeAndEpisodes(
                                    completeAnime:
                                        state.mapAnimesLoad[e]![index],
                                    tag: 'animeSearch'),
                            itemCount: state.mapAnimesLoad[e]!.length,
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 220,
                                    crossAxisSpacing: 30,
                                    mainAxisExtent: 280,
                                    mainAxisSpacing: 30)))
                        .toList()))
          ]));
    });
  }
}
