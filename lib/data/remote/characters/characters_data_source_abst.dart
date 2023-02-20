import 'package:marvel_app/core/model/search_query_param.dart';
import 'package:marvel_app/data/remote/models/marvel_character_marvel_model.dart';

///clase abstracta llamada CharactersDataSourceAbst. Esta clase contiene dos métodos que definen el compartamiento para obtener informacion de los personajes
abstract class CharactersDataSourceAbst {
  ///Este método recibe un objeto de la clase ServicesUrlSettings y devuelve un objeto de la clase MarvelCharacterModel. Este método es utilizado para obtener una lista de personajes de Marvel.
  Future<MarvelCharacterModel> getListCharacters(ServicesUrlSettings queryParams);

  ///Este método recibe un objeto de la clase ServicesUrlSettings y un entero characterId, y devuelve un objeto de la clase MarvelCharacterModel. Este método es utilizado para obtener detalles específicos de un personaje de Marvel.
  Future<MarvelCharacterModel> getDetailsCharacter(ServicesUrlSettings queryParams, int characterId);
}
