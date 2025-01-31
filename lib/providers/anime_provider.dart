import 'package:anime_db/models/anime_model.dart';
import 'package:anime_db/constants/genres.dart';
import 'package:anime_db/models/response_model.dart';
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

  Future<void> clearProvider() async {}

  void setAnimeList(List<AnimeModel> list) {
    _animeList = list;
    notifyListeners();
  }
}

class CurrentSeasonAnimeProvider extends AnimeProvider {
  int _currentPage = 1;
  bool _hasNextPage = false;

  int get currentPage => _currentPage;
  bool get hasNextPage => _hasNextPage;

  Future<void> getAnimeCurrentSeasonList() async {
    final dio = Dio();
    setLoading(true);
    setError(null);

    try {
      final response = await dio.get(
        'https://api.jikan.moe/v4/seasons/now',
        queryParameters: {
          "page": currentPage,
        },
      );
      ResponseModel<AnimeModel> responseModel = ResponseModel.fromJson(response.data, AnimeModel.fromJson);

      _hasNextPage = responseModel.pagination?.hasNextPage ?? false;
      setAnimeList(responseModel.data ?? []);
    } catch (e) {
      setError(e.toString());
      clearProvider();
    } finally {
      setLoading(false);
    }
  }

  Future<void> incrementPage() async {
    _currentPage++;
  }

  Future<void> decrementPage() async {
    _currentPage--;
  }

  @override
  Future<void> clearProvider() async {
    _animeList = [];
    _currentPage = 1;
    notifyListeners();
  }
}

class SearchAnimeProvider extends AnimeProvider {
  int _currentPage = 1;
  bool _hasNextPage = false;

  int get currentPage => _currentPage;
  bool get hasNextPage => _hasNextPage;

  Future<void> getAnimeSearch({
    String? title,
    List<String>? genres,
    int? startYear,
    int? endYear,
  }) async {
    final dio = Dio();
    setLoading(true);
    setError(null);

    try {
      final response = await dio.get(
        'https://api.jikan.moe/v4/anime/',
        queryParameters: {
          "q": title,
          "genres": (genres == null || genres.isEmpty) ? null : genres.map((genre) => Genres.genresMap[genre]).toList().join(","),
          "page": currentPage,
          "start_date": startYear == null ? null : "$startYear-01-01",
          "end_date": endYear == null ? null : "$endYear-12-31",
        },
      );

      ResponseModel<AnimeModel> responseModel = ResponseModel.fromJson(response.data, AnimeModel.fromJson);

      _hasNextPage = responseModel.pagination?.hasNextPage ?? false;
      setAnimeList(responseModel.data ?? []);
    } catch (e) {
      setError(e.toString());
      clearProvider();
    } finally {
      setLoading(false);
    }
  }

  Future<void> incrementPage() async {
    _currentPage++;
  }

  Future<void> decrementPage() async {
    _currentPage--;
  }

  @override
  Future<void> clearProvider() async {
    _animeList = [];
    _currentPage = 1;
    notifyListeners();
  }
}

class TopAnimeProvider extends AnimeProvider {
  int _currentPage = 1;
  bool _hasNextPage = false;

  int get currentPage => _currentPage;
  bool get hasNextPage => _hasNextPage;

  Future<void> getTopAnime() async {
    final dio = Dio();
    setLoading(true);
    setError(null);

    try {
      final response = await dio.get(
        'https://api.jikan.moe/v4/top/anime',
        queryParameters: {
          "page": currentPage,
        },
      );
      ResponseModel<AnimeModel> responseModel = ResponseModel.fromJson(response.data, AnimeModel.fromJson);

      _hasNextPage = responseModel.pagination?.hasNextPage ?? false;
      setAnimeList(responseModel.data ?? []);
    } catch (e) {
      setError(e.toString());
      clearProvider();
    } finally {
      setLoading(false);
    }
  }

  Future<void> incrementPage() async {
    _currentPage++;
  }

  Future<void> decrementPage() async {
    _currentPage--;
  }

  @override
  Future<void> clearProvider() async {
    _animeList = [];
    _currentPage = 1;
    notifyListeners();
  }
}
