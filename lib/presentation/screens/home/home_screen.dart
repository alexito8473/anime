import 'package:anime/data/enums/type_data.dart';
import 'package:anime/domain/bloc/anime/anime_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/anime.dart';
import '../../../data/model/basic_anime.dart';
import '../../../data/model/last_episode.dart';
import '../../widgets/banner/banner_widget.dart';
import '../../widgets/title/title_widget.dart';

class HomeScreen extends StatelessWidget {
  final GlobalKey? targetKey;
  final void Function({required String id, String? tag, required String title})
      onTapElement;

  const HomeScreen({super.key, this.targetKey, required this.onTapElement});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final Orientation orientation = MediaQuery.orientationOf(context);
    return RefreshIndicator(
        onRefresh: () {
          context.read<AnimeBloc>().add(ObtainData(context: context));
          return Future.value();
        },
        child: CustomScrollView(slivers: [
          BlocSelector<AnimeBloc, AnimeState, List<LastEpisode>>(
              selector: (state) => state.lastEpisodes,
              builder: (context, state) => BannerWidget(
                  key: targetKey,
                  lastEpisodes: state,
                  size: size,
                  orientation: orientation,
                  onTapElement: onTapElement)),
          BlocSelector<AnimeBloc, AnimeState, List<Anime>>(
              selector: (state) => state.lastAnimesAdd,
              builder: (context, state) => ListBannerAnime(
                  listAnime: state,
                  size: size,
                  tag: 'agregados',
                  title: 'Últimos animes agregados',
                  typeAnime: TypeAnime.add,
                  colorTitle: Colors.blueAccent,
                  onTapElement: onTapElement)),
          const SliverTitle(),
          BlocSelector<AnimeBloc, AnimeState, List<BasicAnime>>(
              selector: (state) => state.listAringAnime,
              builder: (context, state) => ListAiringAnime(
                  listAringAnime: state,
                  size: size,
                  onTapElement: onTapElement))
        ]));
  }
}
