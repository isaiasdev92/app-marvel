import 'package:marvel_app/core/model/search_query_param.dart';
import 'package:marvel_app/data/remote/models/marvel_character_marvel_model.dart';

/// Esta clase es una clase abstracta que define una plantilla para un repositorio que maneja personajes del universo Marvel.
abstract class CharactersRepositoryAbst {
  /// Este método toma dos parámetros: [queryParams].
  /// Ambos son de tipo `SearchQueryParam` y [String] respectivamente.
  /// Retorna un objeto de tipo [MarvelCharacterModel], que probablemente contiene una lista de personajes de Marvel que cumplen con los criterios de búsqueda.
  Future<MarvelCharacterModel> getCharacters(ServicesUrlSettings queryParams);

  /// Este método toma dos parámetros: [queryParams] y [characterId].
  /// `queryParams` es de tipo [ServicesUrlSettings] y [characterId] es de tipo [int].
  /// Retorna un objeto de tipo [MarvelCharacterModel], que probablemente contiene los detalles de un personaje de Marvel específico.
  Future<MarvelCharacterModel> getCharacter(ServicesUrlSettings queryParams, int characterId);
}
