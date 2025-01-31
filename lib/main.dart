import 'dart:ui';

import 'package:anime_db/providers/anime_provider.dart';
import 'package:anime_db/providers/character_provider.dart';
import 'package:anime_db/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/*
  IMPORTANT:
  1. Untuk dapat menjalankan aplikasi dengan baik pada platform web, perlu untuk mendisable browser security terlebih dahulu
  (meruj)
  https://stackoverflow.com/questions/65630743/how-to-solve-flutter-web-api-cors-error-only-with-dart-code
*/
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<CurrentSeasonAnimeProvider>(create: (context) => CurrentSeasonAnimeProvider()),
        ChangeNotifierProvider<SearchAnimeProvider>(create: (context) => SearchAnimeProvider()),
        ChangeNotifierProvider<TopAnimeProvider>(create: (context) => TopAnimeProvider()),
        ChangeNotifierProvider<CharacterProvider>(create: (context) => CharacterProvider()),
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
