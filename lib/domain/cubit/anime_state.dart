part of 'anime_cubit.dart';

class AnimeState {
  final AnimeFlv animeFlv;
  final List<LastEpisode> lastEpisodes;
  const AnimeState({required this.animeFlv, required this.lastEpisodes});
  factory AnimeState.init() {
    return AnimeState(
        animeFlv: AnimeFlv(), lastEpisodes: List.empty(growable: true));
  }
  AnimeState copyWith({AnimeFlv? animeFlv, List<LastEpisode>? lastEpisodes}) {
    return AnimeState(
        animeFlv: animeFlv ?? this.animeFlv,
        lastEpisodes: lastEpisodes ?? this.lastEpisodes);
  }
}
