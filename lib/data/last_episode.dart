class LastEpisode {
  final String anime;
  final String episode;
  final String id;
  final String imagePreview;

  const LastEpisode(
      {required this.anime,
      required this.episode,
      required this.id,
      required this.imagePreview});

  factory LastEpisode.fromJson(Map<String, dynamic> json) {
    return LastEpisode(
        anime: json['anime'],
        episode: json['episode'],
        id: json['id'],
        imagePreview: json['imagePreview']);
  }
}
