import 'package:anime/data/typeAnime/type_data.dart';
import 'package:anime/domain/bloc/anime_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/model/anime.dart';
import '../../data/model/basic_anime.dart';
import '../../data/model/complete_anime.dart';
import '../../data/model/last_episode.dart';
import '../widgets/banner/banner_widget.dart';
import '../widgets/title/title_widget.dart';

class HomeScreen extends StatelessWidget {
  final List<LastEpisode> lastEpisodes;
  final List<Anime> lastAnimesAdd;
  final List<CompleteAnime> listAnimeSave;
  final List<BasicAnime> listAringAnime;
  final GlobalKey? targetKey;
  const HomeScreen(
      {super.key,
      required this.lastEpisodes,
      required this.lastAnimesAdd,
      required this.listAnimeSave,
      required this.listAringAnime,
      this.targetKey});
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);

    return RefreshIndicator(
        onRefresh: () {
          context.read<AnimeBloc>().add(ObtainData(context: context));
          return Future.value();
        },
        child: CustomScrollView(slivers: [
          BannerWidget(
              key: targetKey,
              lastEpisodes: lastEpisodes,
              size: mediaQueryData.size,
              orientation: mediaQueryData.orientation),
          ListBannerAnime(
              listAnime: lastAnimesAdd,
              size: mediaQueryData.size,
              tag: 'agregados',
              title: 'Últimos animes agregados',
              typeAnime: TypeAnime.ADD,
              colorTitle: Colors.blueAccent),
          if (listAnimeSave.isNotEmpty)
            ListBannerAnime(
                listAnime: listAnimeSave,
                size: mediaQueryData.size,
                tag: 'favoritos',
                title: 'Ánimes favoritos',
                typeAnime: TypeAnime.SAVE,
                colorTitle: Colors.orangeAccent),
          const SliverTitle(),
          ListAiringAnime(
              listAringAnime: listAringAnime, size: mediaQueryData.size)
        ]));
  }
}
