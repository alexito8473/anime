import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../data/enums/type_my_animes.dart';

class CreateFileSaveDataAnime {
  Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/anime_data.json');
  }

  Future<(List<String> episodes, Map<TypeMyAnimes, List<String>> mapAnimes)>
      loadAllData() async {
    final file = await _getFile();

    if (!await file.exists()) {
      return (List<String>.empty(), Map<TypeMyAnimes, List<String>>.identity());
    }

    final jsonString = await file.readAsString();
    final decoded = jsonDecode(jsonString);

    // --------------- EPISODIOS ----------------
    final episodes = List<String>.from(decoded["episodes"] ?? []);

    // --------------- MAPA DE TIPOS ----------------
    final rawMap = decoded["animes"] as Map<String, dynamic>? ?? {};

    final mapAnimes = <TypeMyAnimes, List<String>>{};

    rawMap.forEach((keyString, value) {
      final enumKey = TypeMyAnimes.values.firstWhere(
        (e) => e.toString() == keyString,
        orElse: () => TypeMyAnimes.NONE,
      );

      mapAnimes[enumKey] = List<String>.from(value);
    });

    return (episodes, mapAnimes);
  }

  Future<void> saveAllData({
    required List<String> episodes,
    required Map<TypeMyAnimes, List<String>> mapAnimes,
  }) async {
    final file = await _getFile();
    print(file);
    // Convertimos el mapa usando strings porque JSON no soporta enums como claves
    final jsonMap = mapAnimes.map(
      (key, value) => MapEntry(key.toString(), value),
    );

    final data = {
      "episodes": episodes,
      "animes": jsonMap,
    };

    final jsonString = jsonEncode(data);
    print(jsonString);
    await file.writeAsString(jsonString);
  }
}
