import '../enums/gender.dart';
import 'anime.dart';

class GenderAnimeForPage {
  final int page;
  final List<Anime> listAnime;
  late bool isObtainAllData;
  final Gender typeVersionAnime;

  GenderAnimeForPage(
      {required this.page,
      required this.listAnime,
      required this.isObtainAllData,
      required this.typeVersionAnime});

  factory GenderAnimeForPage.init({required Gender type}) {
    return GenderAnimeForPage(
        page: 1,
        listAnime: List.empty(growable: true),
        isObtainAllData: false,
        typeVersionAnime: type);
  }

  GenderAnimeForPage copyWith(
      {int? page,
      List<Anime>? listAnime,
      bool? isObtainAllData,
      Gender? typeVersionAnime}) {
    return GenderAnimeForPage(
        isObtainAllData: isObtainAllData ?? this.isObtainAllData,
        page: page ?? this.page,
        listAnime: listAnime ?? this.listAnime,
        typeVersionAnime: typeVersionAnime ?? this.typeVersionAnime);
  }
}
