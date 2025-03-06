import 'package:anime/data/enums/gender.dart';
import 'package:anime/domain/bloc/anime/anime_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
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
        duration: Duration(milliseconds: 800), // Duración de la animación
        curve: Curves.easeInOut // Curva de animación
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnimeBloc, AnimeState>(builder: (context, state) {
      return AnimationLoadPage(
          child: GenderListAnimeScreen(
              genderAnimeForPage: state.mapGeneresAnimes[widget.gender]!,
              scrollController: _controller,
              targetKey: key,
              isCollapsed: isCollapsed,
              goUp: _scrollToTop));
    });
  }
}
