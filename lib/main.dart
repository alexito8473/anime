import 'package:anime/constanst.dart';
import 'package:anime/domain/bloc/anime/anime_bloc.dart';
import 'package:anime/domain/bloc/update/update_bloc.dart';
import 'package:anime/presentation/pages/home_page.dart';
import 'package:anime/utils/obtain_data_init.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';
import 'domain/bloc/configuration/configuration_bloc.dart';

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
            theme: Constants.theme,
            title: 'Anime',
            home: const HomePage()));
  }
}
