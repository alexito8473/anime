import 'package:anime/data/typeAnime/type_data.dart';
import 'package:anime/domain/bloc/anime_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/banner/banner_widget.dart';
import '../widgets/title/title_widget.dart';

class HomeScreen extends StatelessWidget {
  final GlobalKey? targetKey;
  const HomeScreen({super.key, this.targetKey});
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return BlocBuilder<AnimeBloc, AnimeState>(
      builder: (context, state) {
        return RefreshIndicator(
            onRefresh: () {
              context.read<AnimeBloc>().add(ObtainData(context: context));
              return Future.value();
            },
            child: CustomScrollView(slivers: [
              BannerWidget(
                  key: targetKey,
                  lastEpisodes: state.lastEpisodes,
                  size: mediaQueryData.size,
                  orientation: mediaQueryData.orientation),
              ListBannerAnime(
                  listAnime: state.lastAnimesAdd,
                  size: mediaQueryData.size,
                  tag: 'agregados',
                  title: 'Últimos animes agregados',
                  typeAnime: TypeAnime.ADD,
                  colorTitle: Colors.blueAccent),
              if (state.listAnimeSave.isNotEmpty)
                ListBannerAnime(
                    listAnime: state.listAnimeSave,
                    size: mediaQueryData.size,
                    tag: 'favoritos',
                    title: 'Ánimes favoritos',
                    typeAnime: TypeAnime.SAVE,
                    colorTitle: Colors.orangeAccent),
              const SliverTitle(),
              ListAiringAnime(
                  listAringAnime: state.listAringAnime,
                  size: mediaQueryData.size)
            ]));
      },
    );
  }
}
