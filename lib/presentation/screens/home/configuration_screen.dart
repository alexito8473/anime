import 'package:anime/domain/bloc/anime/anime_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utils/createFileSaveDataAnime.dart';
import '../../widgets/card/update_card_widget.dart';
import '../../widgets/card/version_card_widget.dart';
import '../../widgets/section/avatar_section_widget.dart';
import '../../widgets/section/background_section_widget.dart';

class ConfigurationScreen extends StatelessWidget {
  const ConfigurationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return SafeArea(
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * .1,
            vertical: size.height * .05),
            child: const CustomScrollView(slivers: [
              VersionCardWidget(),
              UpdateCardWidget(),
              CreateCopyAnimeWidget(),
              LoadDataAnimeWidget(),
              AvatarSectionWidget(),
              BackgroundSectionWidget()
            ])));
  }
}

class CreateCopyAnimeWidget extends StatelessWidget {
  const CreateCopyAnimeWidget({super.key});

  void onSaveDataAnime(AnimeState animeState, BuildContext context) async {
    final CreateFileSaveDataAnime createFileSaveDataAnime =
        CreateFileSaveDataAnime();
    print(animeState.mapAnimesSave);
    await createFileSaveDataAnime.saveAllData(
        episodes: animeState.listEpisodesView,
        mapAnimes: animeState.mapAnimesSave);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Se ha realizado la copia de seguridad'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
        child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
                color: Colors.grey.shade800,
                borderRadius: BorderRadius.circular(20)),
            padding: const EdgeInsets.all(20),
            child: Wrap(
              alignment: WrapAlignment.center,
              children: [
                const Text('Realizar una copia de seguridad de los datos'),
                BlocBuilder<AnimeBloc, AnimeState>(
                  builder: (context, state) {
                    return ElevatedButton(
                        style: const ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(Colors.amberAccent)),
                        onPressed: () => onSaveDataAnime(state, context),
                        child: const Text("Copia de seguridad"));
                  },
                ),
                IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'La copia consiste en guardar los animes que tengas guardados como los me gustas para evitar que se pierdan si limpias la cache de tu dispositivo'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.info_rounded))
              ],
            )));
  }
}

class LoadDataAnimeWidget extends StatelessWidget {
  const LoadDataAnimeWidget({super.key});

  void onLoadDataAnime(BuildContext context) async {
    final CreateFileSaveDataAnime createFileSaveDataAnime =
        CreateFileSaveDataAnime();
    final (listEpisodesView, mapAnimes) =
        await createFileSaveDataAnime.loadAllData();
    print((listEpisodesView, mapAnimes));
    if (mapAnimes.isEmpty && listEpisodesView.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se encontraron datos para cargar'),
        ),
      );
    } else {
      context.read<AnimeBloc>().add(
          LoadDataAnimeEvent(episodes: listEpisodesView, mapAnimes: mapAnimes));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cargando los datos anteriormente almacenado'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
        child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
                color: Colors.grey.shade800,
                borderRadius: BorderRadius.circular(20)),
            padding: const EdgeInsets.all(20),
            child: Wrap(
              alignment: WrapAlignment.center,
              children: [
                const Text('Obten los datos de la copia de seguridad'),
                BlocBuilder<AnimeBloc, AnimeState>(
                  builder: (context, state) {
                    return ElevatedButton(
                        style: const ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(Colors.amberAccent)),
                        onPressed: () => onLoadDataAnime(context),
                        child: const Text("Cargar datos"));
                  },
                ),
                IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Cargaras el último estado guarado de los datos de la copia de seguridad, si borras la cache no pasara nada, solamente si borras la aplicación por completo o los archivos internos'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.info_rounded))
              ],
            )));
  }
}
