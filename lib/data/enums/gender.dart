enum Gender {
  ACCION("Acción", "accion"),
  MATIAL_ARTS("Artes marciales", "artes-marciales"),
  ADVENTURE("Aventuras", "aventura"),
  CARRER("Carreras", "carreras"),
  SCIENCE_FICTION("Ciencia ficción", "ciencia-ficcion"),
  COMEDY("Comedia", "comedia"),
  DEMENTIA("Demencia", "demencia"),
  DEMONS("Demonios", "demonios"),
  SPORT("Deportes", "deportes"),
  DRAMA("Drama", "drama"),
  ECCHI("Ecchi", "ecchi"),
  SCHOOL_CHILDREN("Escolares", "escolares"),
  SPACE("Espacial", "espacial"),
  FANCY("Fantasía", "fantasia"),
  HAREM("Harem", "harem"),
  HISTORICAL("Historico", "historico"),
  CHILDREN("Infantil", "infantil"),
  JOSEI("Josei", "josei"),
  GAMES("Videojuegos", "juegos"),
  MAGIC("Magia", "magia"),
  WICK("Mecha", "mecha"),
  MYSTERY("Misterio", "misterio"),
  MILITARY("Militar", "militar"),
  MUSIC("Musical", "musica"),
  PARODY("Parodia", "parodia"),
  POLICE("Policial", "policia"),
  PSYCHOLOGIST("Psicologico", "psicologico"),
  ROMANCE("Romance", "romance"),
  SAMURAI("Samurai", "samurai"),
  SEINEN("Seinen", "seinen"),
  SHOUJO("Shoujo", "shoujo"),
  SHOUNEN("Shounen", "shounen"),
  SUPERNATURAL("Sobrenatural", "sobrenatural"),
  SUPERPOWERS("Superpoderes", "superpoderes"),
  SUSPENSE("Suspense", "suspenso"),
  TERROR("Terror", "terror"),
  VAMPIRES("Vampiros", "vampiros"),
  YAOI("Yaoi", "yaoi"),
  YURI("Yuri", "yuri");

  final String name;
  final String search;

  String getImage() {
    switch (this) {
      case Gender.ACCION:
        return "assets/gender/accion.webp";
      case Gender.MATIAL_ARTS:
        return "assets/gender/artes_marciales.jpg";
      case Gender.ADVENTURE:
        return "assets/gender/aventura.jpg";
      case Gender.CARRER:
        return "assets/gender/carrera.jpg";
      case Gender.SCIENCE_FICTION:
        return "assets/gender/ciencia_ficcion.webp";
      case Gender.COMEDY:
        return "assets/gender/comedia.webp";
      case Gender.DEMENTIA:
        return "assets/gender/demencia.webp";
      case Gender.DEMONS:
        return "assets/gender/demonios.webp";
      case Gender.SPORT:
        return "assets/gender/deporte.webp";
      case Gender.DRAMA:
        return "assets/gender/drama.jpg";
      case Gender.ECCHI:
        return "assets/gender/ecchi.webp";
      case Gender.SCHOOL_CHILDREN:
        return "assets/gender/escolar.webp";
      case Gender.SPACE:
        return "assets/gender/espacio.webp";
      case Gender.FANCY:
        return "assets/gender/fantasia.jpg";
      case Gender.HAREM:
        return "assets/gender/accion.webp";
      case Gender.HISTORICAL:
        return "assets/gender/accion.webp";
      case Gender.CHILDREN:
        return "assets/gender/accion.webp";
      case Gender.JOSEI:
        return "assets/gender/accion.webp";
      case Gender.GAMES:
        return "assets/gender/accion.webp";
      case Gender.MAGIC:
        return "assets/gender/accion.webp";
      case Gender.WICK:
        return "assets/gender/accion.webp";
      case Gender.MYSTERY:
        return "assets/gender/accion.webp";
      case Gender.MILITARY:
        return "assets/gender/accion.webp";
      case Gender.MUSIC:
        return "assets/gender/accion.webp";
      case Gender.PARODY:
        return "assets/gender/accion.webp";
      case Gender.POLICE:
        return "assets/gender/accion.webp";
      case Gender.PSYCHOLOGIST:
        return "assets/gender/accion.webp";
      case Gender.ROMANCE:
        return "assets/gender/accion.webp";
      case Gender.SAMURAI:
        return "assets/gender/accion.webp";
      case Gender.SEINEN:
        return "assets/gender/accion.webp";
      case Gender.SHOUJO:
        return "assets/gender/accion.webp";
      case Gender.SHOUNEN:
        return "assets/gender/accion.webp";
      case Gender.SUPERNATURAL:
        return "assets/gender/accion.webp";
      case Gender.SUPERPOWERS:
        return "assets/gender/accion.webp";
      case Gender.SUSPENSE:
        return "assets/gender/accion.webp";
      case Gender.TERROR:
        return "assets/gender/accion.webp";
      case Gender.VAMPIRES:
        return "assets/gender/accion.webp";
      case Gender.YAOI:
        return "assets/gender/accion.webp";
      case Gender.YURI:
        return "assets/gender/accion.webp";
    }
  }

  const Gender(this.name, this.search);
}
