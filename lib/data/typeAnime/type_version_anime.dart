enum TypeVersionAnime {
  TV('tv'),
  OVA('ova'),
  MOVIE('movie'),
  SPECIAL('special');

  final String value;
  const TypeVersionAnime(this.value);
  String toStringToLowerCase() {
    return toString().toLowerCase();
  }
}
