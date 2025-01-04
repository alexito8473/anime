import 'anime.dart';

class ListTypeAnimePage {
  final int page;
  final List<Anime> listAnime;
  final bool isObtainAllData;
  const ListTypeAnimePage(
      {required this.page, required this.listAnime, required this.isObtainAllData});

  factory ListTypeAnimePage.init() {
    return ListTypeAnimePage(page: 0, listAnime: List.empty(growable: true), isObtainAllData: false);
  }
}