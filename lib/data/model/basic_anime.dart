class BasicAnime {
  final String id;
  final String title;
  final String type;

  BasicAnime({required this.id, required this.title, required this.type});

  /// Crea una instancia de [BasicAnime] a partir de un Map (JSON).
  factory BasicAnime.fromJson(Map<String, dynamic> json) {
    return BasicAnime(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      type: json['type'] ?? '',
    );
  }

  /// Convierte la instancia de [BasicAnime] a un Map (JSON).
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'type': type,
    };
  }

  @override
  String toString() {
    return 'AiringAnime(id: $id, title: $title, type: $type)';
  }
}
