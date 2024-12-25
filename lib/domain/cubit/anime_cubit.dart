import 'package:animeflv/animeflv.dart';
import 'package:bloc/bloc.dart';

import '../../data/anime.dart';
import '../../data/last_episode.dart';

part 'anime_state.dart';

class AnimeCubit extends Cubit<AnimeState> {
  AnimeCubit(
      {required AnimeFlv animeFlv, required List<LastEpisode> lastEpisodes})
      : super(AnimeState(animeFlv: animeFlv, lastEpisodes: lastEpisodes));


  Future<Map> obtainDataForAnime(String animeid) async{
    return await state.animeFlv.getAnimeInfo(animeid);
  }
}
