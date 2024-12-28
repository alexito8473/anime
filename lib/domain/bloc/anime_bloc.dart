import 'package:anime/data/airing_anime.dart';
import 'package:anime/domain/repository/anime_repository.dart';
import 'package:animeflv/animeflv.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import '../../data/anime.dart';
import '../../data/episode.dart';
import '../../data/interface/last_interface.dart';
import '../../data/last/last_anime.dart';
import '../../data/last/last_episode.dart';
import '../../data/server.dart';

part 'anime_event.dart';
part 'anime_state.dart';

class AnimeBloc extends Bloc<AnimeEvent, AnimeState> {
  final AnimeRepository animeRepository;
  AnimeBloc(
      {required this.animeRepository,
      required List<LastEpisode> lastEpisodes,
      required List<LastAnime> lastAnimeAdd,
      required List<AiringAnime> listAringAnime})
      : super(AnimeState(
            lastEpisodes: lastEpisodes,
            listAnimes: List.empty(growable: true),
            lastAnimesAdd: lastAnimeAdd,
            isComplete: false,
            initLoad: false,
            listAringAnime: listAringAnime)) {

    on<Reset>((event, emit) async {
      emit(state.copyWith(isComplete: false, initLoad: false));
    });

    on<ObtainDataAnime>((event, emit) async {
      Anime? anime;
      emit(state.copyWith(initLoad: true));
      anime = await animeRepository.obtainAnimeForTitleAndId(
          state: state,
          id: event.id,
          title: event.title);
      state.listAnimes.add(anime!);
      emit(state.copyWith(initLoad: false));
      event.context.push('/animeData', extra: anime);
    });

    on<ObtainVideoSever>((event, emit) async {
      emit(state.copyWith(initLoad: true));
      if (event.episode.servers.isEmpty) {
        state.listAnimes
                .firstWhere((animeDeleted) => animeDeleted.id == event.anime.id)
                .episodes
                .firstWhere((element) => element.id == event.episode.id)
                .servers =
            await animeRepository.obtainVideoServerOfEpisode(
                id: event.episode.id);
        emit(state.copyWith());
      }
      emit(state.copyWith(initLoad: false));
      event.context.push('/animeData/servers',
          extra: state.listAnimes
              .firstWhere((animeDeleted) => animeDeleted.id == event.anime.id)
              .episodes
              .firstWhere((element) => element.id == event.episode.id));
    });

  }
}
