class Episode {
  final String episode;
  final String id;
  final String imagePreview;

  const Episode(
      {
        required this.episode,
        required this.id,
        required this.imagePreview});

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
        episode: json['episode'],
        id: json['id'],
        imagePreview: json['imagePreview']);
  }
}
