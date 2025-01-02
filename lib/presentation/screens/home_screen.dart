import 'package:anime/domain/bloc/anime_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/banner/banner_widget.dart';
import '../widgets/load/load_widget.dart';
import '../widgets/title/title_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) => BlocBuilder<AnimeBloc, AnimeState>(
      builder: (context, state) => Stack(children: [
            const Positioned.fill(
                child: CustomScrollView(slivers: [
              BannerWidget(),
              ListBannerAnimeAddWidget(),
              ListAnimeSaveWidget(),
              SliverTitle(),
              ListAiringAnime()
            ])),
            if (state.initLoad) const Positioned.fill(child: LoadWidget())
          ]));
}
