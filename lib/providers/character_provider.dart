import 'package:anime_db/models/character_model.dart';
import 'package:anime_db/models/response_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class CharacterProvider extends ChangeNotifier {
  List<CharacterModel> _characterList = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<CharacterModel> get characterList => _characterList;
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

  void setCharacterList(List<CharacterModel> list) {
    _characterList = list;
    notifyListeners();
  }

  Future<void> getCharacterByAnime({
    required int animeId,
  }) async {
    final dio = Dio();
    setLoading(true);
    setError(null);

    try {
      final response = await dio.get('https://api.jikan.moe/v4/anime/$animeId/characters');
      ResponseModel<CharacterModel> responseModel = ResponseModel.fromJson(response.data, CharacterModel.fromJson);
      setCharacterList(responseModel.data ?? []);
    } catch (e) {
      setError(e.toString());
      clearProvider();
    } finally {
      setLoading(false);
    }
  }
}
