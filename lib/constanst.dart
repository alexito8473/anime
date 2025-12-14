import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Constants {
  static var theme = ThemeData.from(
    useMaterial3: true,
    textTheme: GoogleFonts.notoSerifTextTheme(Typography.whiteRedwoodCity),
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFF1C2833),
      onPrimary: Colors.white,
      secondary: Color(0xFFD4AC0D),
      onSecondary: Colors.black,
      error: Color(0xFFCF6679),
      onError: Colors.black,
      background: Color(0xFF121212),
      onBackground: Color(0xFFEAECEE),
      surface: Colors.black,
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
      selectedLabelStyle:
          GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold),
      unselectedLabelStyle: GoogleFonts.poppins(fontSize: 12),
      elevation: 10,
    ),
    cardColor: const Color(0xFF212F3D),
    // Azul oscuro para tarjetas
    dialogBackgroundColor: const Color(0xFF1B2631),
    // Fondo para diálogos
    iconTheme: const IconThemeData(color: Color(0xFFD4AC0D)), // Íconos dorados
  );

  static const fileNameSaveAnime = "guardadoDeDatosAnime";
  static const corsFilter = 'https://api.allorigins.win/get?url=';
  static const corsFilter2 = 'https://corsproxy.io/?url=';
  static const searchUrl = 'https://animeflv.net/browse?q=';
  static const searchUrlForType =
      'https://www3.animeflv.net/browse?type%5B%5D=';
  static const searchUrlForGender =
      'https://www3.animeflv.net/browse?genre%5B%5D=';
  static const baseUrl = 'https://animeflv.net';
  static const browseUrl = 'https://animeflv.net/browse?';
  static const animeVideoUrl = 'https://animeflv.net/ver/';
  static const baseEpisodeImgUrl = 'https://cdn.animeflv.net/screenshots/';
  static const ieUserAgent =
      'User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; Trident/7.0; rv:11.0) like Gecko';
  static const ffUserAgent =
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:88.0) Gecko/20100101 Firefox/88.0';
  static const operaUserAgent =
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.132 Safari/537.36 OPR/67.0.3575.97';
  static const iosUserAgent =
      'Mozilla/5.0 (iPhone; CPU iPhone OS 13_3_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.5 Mobile/15E148 Safari/604.1';
  static const androidUserAgent =
      'Mozilla/5.0 (Linux; Android 9; SM-G973F) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.138 Mobile Safari/537.36';
  static const edgeUserAgent =
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.102 Safari/537.36 Edge/18.18363';
  static const chromeUserAgent =
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4136.7 Safari/537.36';
  static const safariUserAgent =
      'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_4) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.1 Safari/605.1.15';
  static const String urlAssetImagePageSpecial =
      'assets/image/image_special.jpg';
  static const String urlAssetImagePageSerie = 'assets/image/image_serie.jpg';
  static const String urlAssetImagePageTV = 'assets/image/image_tv.jpg';
  static const String urlAssetImagePageOva = 'assets/image/image_ova.jpg';
  static const String keySharedPreferencesListAnimeFavorite = 'listSafeAnime';
  static const String keySharedPreferencesListAnimeInProgress =
      'listInProgressAnime';
  static const String keySharedPreferencesListAnimeFilled = 'listFilledAnime';
  static const String keySharedPreferencesListAnimeWaiting = 'listWaitingAnime';
  static const String keySharedPreferencesListAnimeAbandoned =
      'listAbandonedAnime';
  static const String keySharedPreferencesListAnimePlanned = 'listPlannedAnime';
  static const String keySharedPreferencesListEpisode = 'listSafeEpisode';
}
