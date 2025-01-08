import 'package:anime/constans.dart';

enum TypeVersionAnime {
  TV('tv'),
  OVA('ova'),
  MOVIE('movie'),
  SPECIAL('special');

  final String value;

  String getImage() {
    switch (this) {
      case TypeVersionAnime.TV:
        return Constants.urlAssetImagePageSerie;
      case TypeVersionAnime.OVA:
        return Constants.urlAssetImagePageSerie;
      case TypeVersionAnime.MOVIE:
        return Constants.urlAssetImagePageSpecial;
      case TypeVersionAnime.SPECIAL:
        return Constants.urlAssetImagePageSpecial;
    }
  }

  const TypeVersionAnime(this.value);
  String getTitle() {
    switch (this) {
      case TypeVersionAnime.TV:
        return "Televisión";
      case TypeVersionAnime.OVA:
        return "Ova";
      case TypeVersionAnime.MOVIE:
        return "Películas";
      case TypeVersionAnime.SPECIAL:
        return "Especiales";
    }
  }
}
