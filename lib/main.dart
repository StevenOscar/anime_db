import 'dart:ui';

import 'package:anime_db/anime_provider.dart';
import 'package:anime_db/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<CurrentSeasonAnimeProvider>(create: (context) => CurrentSeasonAnimeProvider()),
        ChangeNotifierProvider<SearchAnimeProvider>(create: (context) => SearchAnimeProvider()),
        ChangeNotifierProvider<TopAnimeProvider>(create: (context) => TopAnimeProvider()),
      ],
      child: const MyApp()
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch},
      ),
      title: 'AniDB',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: HomeScreen()
    );
  }
}
