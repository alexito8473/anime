import 'dart:math';

import 'package:anime/domain/bloc/anime/anime_bloc.dart';
import 'package:anime/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

class LoadPage extends StatefulWidget {
  const LoadPage({super.key});

  @override
  State<LoadPage> createState() => _LoadPageState();
}

class _LoadPageState extends State<LoadPage> with TickerProviderStateMixin {
  final List<String> listVideo = [
    'assets/video/video1.mp4',
    'assets/video/video2.mp4',
    'assets/video/video3.mp4',
    'assets/video/video4.mp4',
    'assets/video/video5.mp4',
    'assets/video/video6.mp4'
  ];
  late VideoPlayerController _controller;

  @override
  void initState() {

    _initializeVideo();
    super.initState();
  }

  void _initializeVideo() async {
    final List<String> listVideo = [
      'assets/video/video1.mp4',
      'assets/video/video2.mp4',
      'assets/video/video3.mp4',
      'assets/video/video4.mp4',
      'assets/video/video5.mp4',
      'assets/video/video6.mp4'
    ];
    _controller = VideoPlayerController.asset(
      listVideo[Random().nextInt(listVideo.length)],
    )
      ..setLooping(true)
      ..setVolume(0.00)
      ..initialize()
      ..play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateToHome() {
    Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
            transitionDuration: const Duration(seconds: 1),
            // Ajusta la duración del fundido
            pageBuilder: (context, animation, secondaryAnimation) =>
                const HomePage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            }),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AnimeBloc, AnimeState>(
        listener: (context, state) async {
          if (state.isObtainAllData) {
            _navigateToHome();
          }
        },
        child: AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller)));
  }
}
