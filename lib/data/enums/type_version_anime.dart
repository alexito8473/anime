import 'package:anime/constanst.dart';

enum TypeVersionAnime {
  tv('tv'),
  ova('ova'),
  movie('movie'),
  special('special');

  final String value;
  const TypeVersionAnime(this.value);
  String getImage() {
    switch (this) {
      case TypeVersionAnime.tv:
        return Constants.urlAssetImagePageTV;
      case TypeVersionAnime.ova:
        return Constants.urlAssetImagePageOva;
      case TypeVersionAnime.movie:
        return Constants.urlAssetImagePageSerie;
      case TypeVersionAnime.special:
        return Constants.urlAssetImagePageSpecial;
    }
  }

  String getTitle() {
    switch (this) {
      case TypeVersionAnime.tv:
        return "Televisión";
      case TypeVersionAnime.ova:
        return "Ova";
      case TypeVersionAnime.movie:
        return "Películas";
      case TypeVersionAnime.special:
        return "Especiales";
    }
  }
}
