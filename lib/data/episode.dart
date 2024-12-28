import 'package:anime/data/server.dart';

class Episode {
  final int episode;
  final String id;
  final String? part;
  final String imagePreview;
  List<ServerInfo> servers = List.empty(growable: true);
  Episode(
      {required this.episode,
      required this.id,
      required this.imagePreview,
      this.part});

  factory Episode.fromJson(Map<String, dynamic> json) {
    dynamic jsonValue = json['episode'];
    int cantDecimalPat;
    String? partDecimal;
    if (jsonValue.toString().contains('.')) {
      cantDecimalPat = jsonValue
          .toString()
          .split('.')[1]
          .replaceAll(RegExp(r'0+$'), '')
          .length;
      partDecimal = (jsonValue.toDouble() - jsonValue.toInt())
          .toStringAsFixed(cantDecimalPat).toString().substring(2);
    }
    return Episode(
        part: partDecimal,
        episode: jsonValue.toInt(),
        id: json['id'],
        imagePreview: json['imagePreview']);
  }

  Map<String, dynamic> toMap() =>
      {'episode': episode, 'id': id, 'imagePreview': imagePreview};
  Episode addNewListServers(List<ServerInfo> listServers) {
    servers.addAll(listServers);
    return this;
  }
}
