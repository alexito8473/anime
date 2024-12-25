import 'package:anime/data/last_episode.dart';
import 'package:anime/domain/cubit/anime_cubit.dart';
import 'package:anime/presentation/pages/home_page.dart';
import 'package:anime/presentation/route/route.dart';
import 'package:animeflv/animeflv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AnimeFlv animeFlv = AnimeFlv();
  runApp(MyApp(
    animeFlv: animeFlv,
    lastEpisodes: (await animeFlv.getLastEpisodes())
        .map((e) => LastEpisode.fromJson(e))
        .toList(growable: true),
  ));
}

class MyApp extends StatelessWidget {
  final AnimeFlv animeFlv;
  final List<LastEpisode> lastEpisodes;
  MyApp({super.key, required this.animeFlv, required this.lastEpisodes});

  final ThemeData lightAnimeTheme = ThemeData.from(
    useMaterial3: true,
    textTheme: GoogleFonts.notoSerifTextTheme(Typography.blackRedwoodCity),
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF4A90E2), // Azul cielo anime
      onPrimary: Colors.white,
      secondary: Color(0xFF50BFA0), // Verde esmeralda anime
      onSecondary: Colors.white,
      error: Color(0xFFD32F2F),
      onError: Colors.white,
      surface: Color(0xFFF0F4F8),
      onSurface: Color(0xFF2C3E50),
    ),
  ).copyWith(
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: const Color(0xFFF0F4F8), // Fondo claro anime
        selectedItemColor: const Color(0xFF4A90E2), // Azul cielo (activo)
        unselectedItemColor: const Color(0xFF95A5A6), // Gris (inactivo)
        selectedLabelStyle:
            GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold),
        unselectedLabelStyle: GoogleFonts.poppins(fontSize: 12),
        elevation: 10),
  );

  /// 🌙 Tema Oscuro Anime
  final ThemeData darkAnimeTheme = ThemeData.from(
    useMaterial3: true,
    textTheme: GoogleFonts.notoSerifTextTheme(Typography.whiteRedwoodCity),
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFF1C2833), // Azul noche anime
      onPrimary: Colors.white,
      secondary: Color(0xFFD4AC0D), // Dorado anime
      onSecondary: Colors.white,
      error: Color(0xFFCF6679),
      onError: Colors.white,
      surface: Color(0xFF121212),
      onSurface: Color(0xFFBDC3C7),
    ),
  ).copyWith(
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: const Color(0xFF1C2833), // Fondo oscuro anime
        selectedItemColor: const Color(0xFFD4AC0D), // Dorado (activo)
        unselectedItemColor: const Color(0xFF7F8C8D), // Gris (inactivo)
        selectedLabelStyle:
            GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold),
        unselectedLabelStyle: GoogleFonts.poppins(fontSize: 12),
        elevation: 10),
  );

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) =>
                  AnimeCubit(animeFlv: animeFlv, lastEpisodes: lastEpisodes))
        ],
        child: MaterialApp.router(
            theme: lightAnimeTheme,
            darkTheme: darkAnimeTheme,
            themeMode: ThemeMode.dark,
            title: 'Anime',
            routerConfig: router,
            checkerboardRasterCacheImages: true,
            builder: (context, child) {
              return child!;
            }));
  }
}
