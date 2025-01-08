import 'package:anime/data/typeAnime/type_version_anime.dart';

import 'anime.dart';

class ListTypeAnimePage {
  final int page;
  final List<Anime> listAnime;
  final bool isObtainAllData;
  final TypeVersionAnime typeVersionAnime;
  const ListTypeAnimePage(
      {required this.page,
      required this.listAnime,
      required this.isObtainAllData,
      required this.typeVersionAnime});

  factory ListTypeAnimePage.init({required TypeVersionAnime type}) {
    return ListTypeAnimePage(
        page: 0,
        listAnime: List.empty(growable: true),
        isObtainAllData: false,
        typeVersionAnime: type);
  }
}
