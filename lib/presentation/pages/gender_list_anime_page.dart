import 'package:anime/data/enums/gender.dart';
import 'package:anime/domain/bloc/anime/anime_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/gender_anime_page.dart';
import '../screens/gender_list_anime_screen.dart';
import '../widgets/load/load_widget.dart';

class GenderListAnimePage extends StatefulWidget {
  final Gender gender;

  const GenderListAnimePage({super.key, required this.gender});

  @override
  State<GenderListAnimePage> createState() => _GenderListAnimePageState();
}

class _GenderListAnimePageState extends State<GenderListAnimePage> {
  final ScrollController _controller = ScrollController();
  final GlobalKey key = GlobalKey();
  bool isCollapsed = false;
  bool _canUpdate = true;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
    _controller.addListener(
      () => loadMore(
          context.read<AnimeBloc>().state.mapGeneresAnimes[widget.gender]!),
    );
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  void _onScroll() {
    if (_controller.offset >= 250 != isCollapsed) {
      setState(() {
        // Ajusta el umbral según la altura del AppBar expandido
        isCollapsed = !isCollapsed;
      });
    }
  }

  void _scrollToTop() {
    _controller.animateTo(0, // Ir al inicio
        duration: const Duration(milliseconds: 800), // Duración de la animación
        curve: Curves.easeInOut // Curva de animación
        );
  }

  void loadMore(GenderAnimeForPage page) async {
    if (page.isObtainAllData) {
      if (_canUpdate) {
        setState(() {
          _canUpdate = false;
        });
      }
      return;
    }
    if (_controller.position.pixels >=
        _controller.position.maxScrollExtent - 200) {
      final double currentScrollPosition = _controller.position.pixels;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller.jumpTo(currentScrollPosition - 100);
      });
      context
          .read<AnimeBloc>()
          .add(LoadMoreGender(gender: widget.gender, context: context));
    }
  }
  void navigation({required String id, String? tag, required String title}) {
    context.read<AnimeBloc>().add(ObtainDataAnime(
        context: context,
        id: id,
        tag: tag,
        title: title));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AnimeBloc, AnimeState>(
      listener: (context, state) {
        _controller.removeListener(
            () => loadMore(state.mapGeneresAnimes[widget.gender]!));
      },
      builder: (context, state) {
        return AnimationLoadPage(
            child: GenderListAnimeScreen(
                genderAnimeForPage: state.mapGeneresAnimes[widget.gender]!,
                scrollController: _controller,
                targetKey: key,
                isCollapsed: isCollapsed,
                goUp: _scrollToTop, onTapElement: navigation,));
      },
    );
  }
}
