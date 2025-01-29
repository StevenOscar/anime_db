import 'package:anime_db/anime_model.dart';
import 'package:anime_db/response_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

abstract class AnimeProvider extends ChangeNotifier {
  List<AnimeModel> _animeList = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<AnimeModel> get animeList => _animeList;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  void setAnimeList(List<AnimeModel> list) {
    _animeList = list;
    notifyListeners();
  }
}

class CurrentSeasonAnimeProvider extends AnimeProvider {
  Future<List<AnimeModel>> getAnimeCurrentSeasonList() async {
    final dio = Dio();
    final response = await dio.get('https://api.jikan.moe/v4/seasons/now');
    ResponseModel<AnimeModel> responseModel =
        ResponseModel.fromJson(response.data, AnimeModel.fromJson);
    _animeList = responseModel.data!;

    for (var i = 0; i < _animeList.length; i++) {
      print(_animeList[i].title);
    }
    notifyListeners();
    return _animeList;
  }
}

class SearchAnimeProvider extends AnimeProvider {
  Future<List<AnimeModel>> getAnimeSearch() async {
    final dio = Dio();
    final response = await dio.get('https://api.jikan.moe/v4/anime/58567/full');
    ResponseModel<AnimeModel> responseModel =
        ResponseModel.fromJson(response.data, AnimeModel.fromJson);
    print(responseModel.data);
    _animeList = responseModel.data!;

    for (var i = 0; i < _animeList.length; i++) {
      print(_animeList[i].title);
    }
    return _animeList;
  }
}

class TopAnimeProvider extends AnimeProvider {
  //TODO ganti ini
  Future<List<AnimeModel>> getTopAnime() async {
    final dio = Dio();
    final response = await dio.get('https://api.jikan.moe/v4/top/anime');
    ResponseModel<AnimeModel> responseModel =
        ResponseModel.fromJson(response.data, AnimeModel.fromJson);
    print(responseModel.data);
    _animeList = responseModel.data!;

    for (var i = 0; i < _animeList.length; i++) {
      print(_animeList[i].title);
    }
    notifyListeners();

    return _animeList;
  }
}
