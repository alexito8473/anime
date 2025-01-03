import 'package:anime/domain/bloc/anime_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/model/complete_anime.dart';
import '../../data/model/episode.dart';
import '../screens/detail_anime_screen.dart';
import '../widgets/load/load_widget.dart';

class DetailAnimePage extends StatefulWidget {
  final String idAnime;
  final String? tag;
  const DetailAnimePage({super.key, required this.idAnime, required this.tag});
  @override
  State<DetailAnimePage> createState() => _DetailAnimePageState();
}

class _DetailAnimePageState extends State<DetailAnimePage> {
  final TextEditingController _controller = TextEditingController();
  int _currentPage = 0;

  @override
  void initState() {
    _controller.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  List<Episode> filteredList(List<Episode> list, String text) {
    if (text.isEmpty) {
      return list;
    }
    return list
        .where((element) => element.episode.toString().contains(text))
        .toList();
  }

  void onTap(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    CompleteAnime anime = context
        .watch<AnimeBloc>()
        .state
        .listAnimes
        .firstWhere((element) => element.id == widget.idAnime);
    return AnimationLoadPage(
        child: DetailAnimeScreen(
            size: MediaQuery.sizeOf(context),
            anime: anime,
            onTap: onTap,
            currentPage: _currentPage,
            listAnimeFilter: filteredList(anime.episodes, _controller.text),
            textController: _controller,
            tag: widget.tag));
  }
}
