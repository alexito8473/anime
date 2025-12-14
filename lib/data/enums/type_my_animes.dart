import 'package:anime/constansT.dart';
import 'package:flutter/material.dart';

enum TypeMyAnimes {
  NONE(name:'No esta guardado'),
  IN_PROGURESS(name: 'En progreso'),
  PLANNED(name:'Planeado'),
  FILLED(name:'Compleado'),
  FAVORITE(name:'Favorito'),
  WAITING(name:'Es espera'),
  ABANDONED(name:'Abandonado');

  final String name;
  const TypeMyAnimes({required this.name});

  IconData getIcon(){
    switch(this){
      case TypeMyAnimes.IN_PROGURESS:
        return Icons.hourglass_top;
      case TypeMyAnimes.PLANNED:
        return Icons.assignment;
      case TypeMyAnimes.FILLED:
        return Icons.verified ;
      case TypeMyAnimes.FAVORITE:
        return Icons.favorite ;
      case TypeMyAnimes.WAITING:
        return Icons.access_time;
      case TypeMyAnimes.ABANDONED:
        return Icons.block ;
      case TypeMyAnimes.NONE:
        return Icons.home;
    }
  }
  String getKeySharedPreference(){
    switch(this){
      case TypeMyAnimes.IN_PROGURESS:
        return Constants.keySharedPreferencesListAnimeInProgress;
      case TypeMyAnimes.PLANNED:
        return Constants.keySharedPreferencesListAnimePlanned;
      case TypeMyAnimes.FILLED:
        return Constants.keySharedPreferencesListAnimeFilled;
      case TypeMyAnimes.FAVORITE:
        return Constants.keySharedPreferencesListAnimeFavorite;
      case TypeMyAnimes.WAITING:
        return Constants.keySharedPreferencesListAnimeWaiting;
      case TypeMyAnimes.ABANDONED:
        return Constants.keySharedPreferencesListAnimeAbandoned;
      case TypeMyAnimes.NONE:
        return '';
    }
  }
}