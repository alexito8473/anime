import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Constants {
  static final ColorScheme _darkColorScheme = const ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF7C4DFF),
    onPrimary: Colors.white,
    primaryContainer: Color(0xFF311B92),
    onPrimaryContainer: Color(0xFFE8D5FF),
    secondary: Color(0xFFFF6B35),
    onSecondary: Colors.white,
    secondaryContainer: Color(0xFFBF360C),
    onSecondaryContainer: Color(0xFFFFE0D0),
    tertiary: Color(0xFF00BFA5),
    onTertiary: Colors.black,
    tertiaryContainer: Color(0xFF00796B),
    onTertiaryContainer: Color(0xFFB2F5EA),
    error: Color(0xFFCF6679),
    onError: Colors.black,
    background: Color(0xFF0A0E17),
    onBackground: Color(0xFFE2E8F0),
    surface: Color(0xFF111827),
    onSurface: Color(0xFFCBD5E1),
    surfaceVariant: Color(0xFF1E293B),
    onSurfaceVariant: Color(0xFF94A3B8),
    outline: Color(0xFF334155),
    outlineVariant: Color(0xFF475569),
    surfaceContainerHighest: Color(0xFF1E293B),
    surfaceContainerHigh: Color(0xFF1A2234),
    surfaceContainer: Color(0xFF151D2E),
    surfaceContainerLow: Color(0xFF111827),
    surfaceContainerLowest: Color(0xFF0D1117),
  );

  static var theme = ThemeData.from(
    useMaterial3: true,
    textTheme: GoogleFonts.interTextTheme(Typography.whiteRedwoodCity),
    colorScheme: _darkColorScheme,
  ).copyWith(
    scaffoldBackgroundColor: _darkColorScheme.background,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: GoogleFonts.inter(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: const IconThemeData(color: Color(0xFF7C4DFF)),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: const Color(0xFF111827),
      selectedItemColor: const Color(0xFF7C4DFF),
      unselectedItemColor: const Color(0xFF64748B),
      selectedLabelStyle: GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      elevation: 8,
      type: BottomNavigationBarType.fixed,
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF1E293B),
      elevation: 2,
      shadowColor: Colors.black.withAlpha(80),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side:const  BorderSide(color: Color(0xFF334155), width: 0.5),
      ),
    ),
    cardColor: const Color(0xFF1E293B),
    dialogBackgroundColor: const Color(0xFF1A2234),
    dialogTheme: DialogThemeData(
      backgroundColor: const Color(0xFF1A2234),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Color(0xFF334155), width: 0.5),
      ),
    ),
    iconTheme: const IconThemeData(color: Color(0xFF7C4DFF)),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF1E293B),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF334155)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF334155)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF7C4DFF), width: 2),
      ),
      hintStyle: const TextStyle(color: Color(0xFF64748B)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF7C4DFF),
        foregroundColor: Colors.white,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF7C4DFF),
      foregroundColor: Colors.white,
      elevation: 4,
    ),
    tabBarTheme: TabBarThemeData(
      labelColor: const Color(0xFF7C4DFF),
      unselectedLabelColor: const Color(0xFF64748B),
      indicatorColor: const Color(0xFF7C4DFF),
      indicatorSize: TabBarIndicatorSize.tab,
      labelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: const Color(0xFF1E293B),
      selectedColor: const Color(0xFF7C4DFF).withAlpha(60),
      side: const BorderSide(color: Color(0xFF334155)),
      labelStyle: GoogleFonts.inter(fontSize: 13, color: const Color(0xFFCBD5E1)),
      secondaryLabelStyle: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF7C4DFF)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFF1E293B),
      thickness: 1,
      space: 1,
    ),
    listTileTheme: ListTileThemeData(
      tileColor: Colors.transparent,
      selectedTileColor: const Color(0xFF7C4DFF).withAlpha(40),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );

  static const gender = "Géneros";
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