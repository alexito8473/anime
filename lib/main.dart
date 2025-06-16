import 'dart:io';
import 'dart:math';

import 'package:anime/domain/bloc/anime/anime_bloc.dart';
import 'package:anime/domain/bloc/update/update_bloc.dart';
import 'package:anime/presentation/pages/home_page.dart';
import 'package:anime/utils/obtain_data_init.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'domain/bloc/configuration/configuration_bloc.dart';
final navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  final List<String> listEpisodesView = List.empty(growable: true);
  WidgetsFlutterBinding.ensureInitialized();
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
              textTheme:
                  GoogleFonts.notoSerifTextTheme(Typography.whiteRedwoodCity),
              colorScheme: const ColorScheme(
                brightness: Brightness.dark,
                // 🎯 Colores principales
                primary: Color(0xFF1C2833),
                // Azul noche anime
                onPrimary: Colors.white,
                // ✨ Colores secundarios
                secondary: Color(0xFFD4AC0D),
                // Dorado anime
                onSecondary: Colors.black,
                // Mejor contraste
                // ❌ Errores
                error: Color(0xFFCF6679),
                onError: Colors.black,
                // 🧱 Fondo general
                background: Color(0xFF121212),
                // Fondo oscuro elegante
                onBackground: Color(0xFFEAECEE),
                // 🖼️ Superficies como tarjetas, diálogos
                surface:  Colors.black,
                // Leve contraste con background
                onSurface: Color(0xFFBDC3C7),
              ),
            ).copyWith(
              scaffoldBackgroundColor: Colors.black,
              appBarTheme: const AppBarTheme(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  elevation: 0),
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                backgroundColor: const Color(0xFF1C2833),
                selectedItemColor: const Color(0xFFD4AC0D),
                unselectedItemColor: const Color(0xFF7F8C8D),
                selectedLabelStyle: GoogleFonts.poppins(
                    fontSize: 14, fontWeight: FontWeight.bold),
                unselectedLabelStyle: GoogleFonts.poppins(fontSize: 12),
                elevation: 10,
              ),
              cardColor: const Color(0xFF212F3D),
              // Azul oscuro para tarjetas
              dialogBackgroundColor: const Color(0xFF1B2631),
              // Fondo para diálogos
              iconTheme: const IconThemeData(
                  color: Color(0xFFD4AC0D)), // Íconos dorados
            ),
            title: 'Anime',
            home: const HomePage()));
  }
}
