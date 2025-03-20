import 'package:anime/domain/bloc/anime/anime_bloc.dart';
import 'package:anime/domain/bloc/update/update_bloc.dart';
import 'package:anime/presentation/pages/home_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'data/enums/type_my_animes.dart';
import 'data/enums/type_version_anime.dart';
import 'data/model/anime.dart';
import 'data/model/basic_anime.dart';
import 'data/model/complete_anime.dart';
import 'data/model/last_episode.dart';
import 'domain/bloc/configuration/configuration_bloc.dart';
import 'domain/repository/anime/anime_repository.dart';

final navigatorKey = GlobalKey<NavigatorState>();

List<Future<Null>> transformListStringToListFuture(
    {required List<String> listAnime,
    required List<CompleteAnime> listAnimeState,
    required AnimeRepository animeRepository}) {
  return listAnime.map((id) async {
    try {
      final anime = await animeRepository.obtainAnimeForId(id: id);
      if (anime != null) {
        listAnimeState.add(anime);
        listAnimeState.sort((a, b) => a.title.compareTo(b.title));
      }
    } catch (e) {
      print("Error al obtener anime con ID $id: $e");
    }
  }).toList();
}

Future<void> extractDataSave(AnimeState animeState) async {
  AnimeRepository animeRepository = AnimeRepository();
  List<Future<Null>> listFutures = List.empty(growable: true);
  for (TypeMyAnimes animes
      in TypeMyAnimes.values.where((element) => element != TypeMyAnimes.NONE)) {
    listFutures.addAll(transformListStringToListFuture(
        listAnime: animeState.mapAnimesSave[animes]!,
        listAnimeState: animeState.mapAnimesLoad[animes]!,
        animeRepository: animeRepository));
  }
  await Future.wait(listFutures);
}

Future<AnimeState> extractData(AnimeState animeState) async {
  AnimeRepository animeRepository = AnimeRepository();

  try {
    final results = await Future.wait([
      animeRepository.getLastEpisodes(),
      animeRepository.getLastAddedAnimes(),
      animeRepository.getAiringAnimes(),
      animeRepository.searchByType(
          listTypeAnimePage: animeState.mapPageAnimes[TypeVersionAnime.OVA]!),
      animeRepository.searchByType(
          listTypeAnimePage: animeState.mapPageAnimes[TypeVersionAnime.MOVIE]!),
      animeRepository.searchByType(
          listTypeAnimePage: animeState.mapPageAnimes[TypeVersionAnime.TV]!),
      animeRepository.searchByType(
          listTypeAnimePage:
              animeState.mapPageAnimes[TypeVersionAnime.SPECIAL]!),
    ]);
    await Future.wait([
      Future.microtask(() => animeState.lastEpisodes
          .addAll(results[0].map((e) => LastEpisode.fromJson(e)).toList())),
      Future.microtask(() => animeState.lastAnimesAdd
          .addAll(results[1].map((e) => Anime.fromJson(e)).toList())),
      Future.microtask(() => animeState.listAringAnime
          .addAll(results[2].map((e) => BasicAnime.fromJson(e)).toList())),
      Future.microtask(() => animeState
          .mapPageAnimes[TypeVersionAnime.OVA]?.listAnime
          .addAll(Anime.listDynamicToListAnime(results[3]))),
      Future.microtask(() => animeState
          .mapPageAnimes[TypeVersionAnime.MOVIE]?.listAnime
          .addAll(Anime.listDynamicToListAnime(results[4]))),
      Future.microtask(() => animeState
          .mapPageAnimes[TypeVersionAnime.TV]?.listAnime
          .addAll(Anime.listDynamicToListAnime(results[5]))),
      Future.microtask(() => animeState
          .mapPageAnimes[TypeVersionAnime.SPECIAL]?.listAnime
          .addAll(Anime.listDynamicToListAnime(results[6]))),
      Future.microtask(() {
        animeState.mapPageAnimes.updateAll((key, value) {
          return value.copyWith(page: value.page + 1);
        });
      })
    ]);
  } catch (e) {
    print("Error en el proceso de carga masiva de animes: $e");
  }
  return animeState;
}

void main() async {
  List<String> listEpisodesView = List.empty(growable: true);
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // await FirebaseApi().initNotifications();
  // FirebaseMessaging.instance.subscribeToTopic("global");
  SystemChrome.setPreferredOrientations(DeviceOrientation.values);
  HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: kIsWeb
          ? HydratedStorageDirectory.web
          : HydratedStorageDirectory((await getTemporaryDirectory()).path));
  final animeBloc = AnimeBloc(animeState: AnimeState.init());
  listEpisodesView.addAll(animeBloc.state.listEpisodesView.toSet());
  animeBloc.state.listEpisodesView.clear();
  animeBloc.state.listEpisodesView.addAll(listEpisodesView);
  extractDataSave(animeBloc.state);
  await extractData(animeBloc.state)
      .then((value) => animeBloc.add(LoadNewState(animeState: value)));
  runApp(MyApp(animeBloc: animeBloc));
}

class MyApp extends StatelessWidget {
  final AnimeBloc animeBloc;

  const MyApp({super.key, required this.animeBloc});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => animeBloc, lazy: false),
          BlocProvider(create: (context) => UpdateBloc(), lazy: false),
          BlocProvider(create: (context) => ConfigurationBloc(), lazy: false)
        ],
        child: MaterialApp(
            navigatorKey: navigatorKey,
            theme: ThemeData.from(
                    useMaterial3: true,
                    textTheme: GoogleFonts.notoSerifTextTheme(
                        Typography.whiteRedwoodCity),
                    colorScheme: const ColorScheme(
                        brightness: Brightness.dark,
                        primary: Color(0xFF1C2833),
                        // Azul noche anime
                        onPrimary: Colors.white,
                        secondary: Color(0xFFD4AC0D),
                        // Dorado anime
                        onSecondary: Colors.white,
                        error: Color(0xFFCF6679),
                        onError: Colors.white,
                        surface: Colors.black,
                        onSurface: Color(0xFFBDC3C7)))
                .copyWith(
                    scaffoldBackgroundColor: Colors.black,
                    bottomNavigationBarTheme: BottomNavigationBarThemeData(
                        backgroundColor: const Color(0xFF1C2833),
                        // Fondo oscuro anime
                        selectedItemColor: const Color(0xFFD4AC0D),
                        // Dorado (activo)
                        unselectedItemColor: const Color(0xFF7F8C8D),
                        // Gris (inactivo)
                        selectedLabelStyle: GoogleFonts.poppins(
                            fontSize: 14, fontWeight: FontWeight.bold),
                        unselectedLabelStyle: GoogleFonts.poppins(fontSize: 12),
                        elevation: 10)),
            title: 'Anime',
            home: const HomePage()));
  }
}
