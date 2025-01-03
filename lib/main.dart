import 'package:anime/domain/bloc/anime_bloc.dart';
import 'package:anime/domain/repository/anime/anime_repository.dart';
import 'package:anime/presentation/pages/load_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]); // Solo orientación vertical
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) =>
                  AnimeBloc(animeRepository: AnimeRepository()))
        ],
        child: MaterialApp(
            theme: ThemeData.from(
                    useMaterial3: true,
                    textTheme: GoogleFonts.notoSerifTextTheme(
                        Typography.whiteRedwoodCity),
                    colorScheme: const ColorScheme(
                        brightness: Brightness.dark,
                        primary: Color(0xFF1C2833), // Azul noche anime
                        onPrimary: Colors.white,
                        secondary: Color(0xFFD4AC0D), // Dorado anime
                        onSecondary: Colors.white,
                        error: Color(0xFFCF6679),
                        onError: Colors.white,
                        surface: Colors.black,
                        onSurface: Color(0xFFBDC3C7)))
                .copyWith(
                    scaffoldBackgroundColor: Colors.black,
                    bottomNavigationBarTheme: BottomNavigationBarThemeData(
                        backgroundColor:
                            const Color(0xFF1C2833), // Fondo oscuro anime
                        selectedItemColor:
                            const Color(0xFFD4AC0D), // Dorado (activo)
                        unselectedItemColor:
                            const Color(0xFF7F8C8D), // Gris (inactivo)
                        selectedLabelStyle: GoogleFonts.poppins(
                            fontSize: 14, fontWeight: FontWeight.bold),
                        unselectedLabelStyle: GoogleFonts.poppins(fontSize: 12),
                        elevation: 10)),
            title: 'Anime',
            home: const LoadPage()));
  }
}
