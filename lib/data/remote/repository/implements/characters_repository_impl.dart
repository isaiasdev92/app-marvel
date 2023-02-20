import 'package:get/get.dart';
import 'package:marvel_app/core/model/search_query_param.dart';
import 'package:marvel_app/data/remote/characters/characters_data_source_abst.dart';
import 'package:marvel_app/data/remote/models/marvel_character_marvel_model.dart';

import '../abstracts/characters_repository_abst.dart';

class CharactersRepositoryImpl implements CharactersRepositoryAbst {
  final CharactersDataSourceAbst _remoteSource = Get.find(tag: (CharactersDataSourceAbst).toString());

  @override
  Future<MarvelCharacterModel> getCharacter(ServicesUrlSettings queryParams, int characterId) {
    return _remoteSource.getDetailsCharacter(queryParams, characterId);
  }

  @override
  Future<MarvelCharacterModel> getCharacters(ServicesUrlSettings queryParams) {
    return _remoteSource.getListCharacters(queryParams);
  }
}
