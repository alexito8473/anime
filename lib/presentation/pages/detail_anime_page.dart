import 'package:flutter/material.dart';
import '../../data/complete_anime.dart';
import '../../data/episode.dart';
import '../screens/detail_anime_screen.dart';

class DetailAnimePage extends StatefulWidget {
  final CompleteAnime anime;
  final String? tag;
  const DetailAnimePage({super.key, required this.anime, required this.tag});
  @override
  State<DetailAnimePage> createState() => _DetailAnimePageState();
}

class _DetailAnimePageState extends State<DetailAnimePage> {
  late List<Episode> listAnimeFilter;
  final TextEditingController _controller = TextEditingController();
  int _currentPage = 0;

  @override
  void initState() {
    listAnimeFilter = List.from(widget.anime.episodes);
    super.initState();
  }

  void onSubmit() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        listAnimeFilter = widget.anime.episodes
            .where((element) =>
                element.episode.toString().contains(_controller.text))
            .toList();
      });
    } else {
      listAnimeFilter = List.from(widget.anime.episodes);
    }
  }

  void onTap(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DetailAnimeScreen(
        size: MediaQuery.sizeOf(context),
        anime: widget.anime,
        onTap: onTap,
        currentPage: _currentPage,
        listAnimeFilter: listAnimeFilter,
        obSubmit: onSubmit,
        textController: _controller,
        tag: widget.tag);
  }
}

