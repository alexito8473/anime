import 'package:anime/constans.dart';

enum TypeVersionAnime {
  TV('tv'),
  OVA('ova'),
  MOVIE('movie'),
  SPECIAL('special');

  final String value;
  const TypeVersionAnime(this.value);
  String getImage() {
    switch (this) {
      case TypeVersionAnime.TV:
        return Constants.urlAssetImagePageTV;
      case TypeVersionAnime.OVA:
        return Constants.urlAssetImagePageOva;
      case TypeVersionAnime.MOVIE:
        return Constants.urlAssetImagePageSerie;
      case TypeVersionAnime.SPECIAL:
        return Constants.urlAssetImagePageSpecial;
    }
  }

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
