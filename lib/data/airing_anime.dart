class AiringAnime {
  final String id;
  final String title;
  final String type;

  AiringAnime({required this.id, required this.title, required this.type});

  /// Crea una instancia de [AiringAnime] a partir de un Map (JSON).
  factory AiringAnime.fromJson(Map<String, dynamic> json) {
    return AiringAnime(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      type: json['type'] ?? '',
    );
  }

  /// Convierte la instancia de [AiringAnime] a un Map (JSON).
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
