import 'package:anime/presentation/screens/explore_screen.dart';
import 'package:anime/presentation/screens/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TextEditingController _controller;
  late final List<Widget> listScreen;
  int _currentIndex = 0;
  @override
  void initState() {
    _controller = TextEditingController();
    listScreen = [
      const HomeScreen(),
      ExploreScreen(controller: _controller),
      Container(color: Colors.red)
    ];
    super.initState();
  }

  void changeIndex({required int index}) =>
      setState(() => _currentIndex = index);

  Widget navigationBottom({required Size size}) => Container(
      margin: EdgeInsets.symmetric(
          vertical: size.height * 0.02, horizontal: size.width * 0.05),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: Colors.grey.shade900,
          border: Border.all(color: Colors.white.withAlpha(40)),
          borderRadius: BorderRadius.circular(20)),
      child: GNav(
          onTabChange: (index) => changeIndex(index: index),
          tabBorderRadius: 15,
          tabActiveBorder: Border.all(color: Colors.white10, width: 1),
          curve: Curves.easeInCubic,
          duration: const Duration(milliseconds: 100),
          gap: 10,
          color: Colors.grey[800],
          activeColor: Colors.orange,
          iconSize: 24,
          tabBackgroundColor: Colors.orange.withAlpha(60),
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          tabs: const [
            GButton(icon: Icons.account_circle, text: 'Home'),
            GButton(icon: Icons.account_circle, text: 'Explore'),
            GButton(icon: Icons.account_circle, text: 'Search')
          ]));

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
        extendBody: true,
        body: IndexedStack(index: _currentIndex, children: listScreen),
        bottomNavigationBar: navigationBottom(size: size));
  }
}
