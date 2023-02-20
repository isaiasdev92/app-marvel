import 'package:marvel_app/core/base/base_remote_source.dart';
import 'package:marvel_app/core/model/search_query_param.dart';
import 'package:marvel_app/data/remote/characters/characters_data_source_abst.dart';
import 'package:marvel_app/data/remote/models/marvel_character_marvel_model.dart';

/// Esta clase implementa la interfaz [CharactersDataSourceAbst] y extiende de [BaseRemoteSource].
/// Proporciona la implementación de los métodos [getListCharacters] y [getDetailsCharacter] que hacen llamadas
/// a una API remota para obtener una lista de personajes de Marvel o detalles de un personaje específico,
class CharactersDataSourceImpl extends BaseRemoteSource implements CharactersDataSourceAbst {
  /// Este método es una implementación de la interfaz [CharactersDataSourceAbst].
  /// Realiza una llamada a la API utilizando la instancia dioClient de la clase [BaseRemoteSource],
  /// pasando la URL de consulta y los parámetros de consulta que se pasan como un objeto de [ServicesUrlSettings].
  /// La respuesta se analiza utilizando [callApiWithErrorParser] de la clase [BaseRemoteSource].
  /// El método devuelve una instancia de [Future<MarvelCharacterModel>] que contiene los datos del personaje de Marvel devueltos por la API,
  /// que se convierten en un objeto [MarvelCharacterModel]. Si ocurre una excepción, se vuelve a lanzar.
  @override
  Future<MarvelCharacterModel> getDetailsCharacter(ServicesUrlSettings queryParams, int characterId) {
    var dioCall = dioClient.get(queryParams.url, queryParameters: queryParams.toJson());

    try {
      return callApiWithErrorParser(dioCall).then((response) {
        return marvelCharacterModelFromMap(response.data);
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Este método [getListCharacters] es una implementación de la interfaz [CharactersDataSourceAbst] y se encarga de obtener una
  /// lista de personajes de Marvel de forma remota, utilizando una URL y parámetros de consulta proporcionados a través de un objeto [ServicesUrlSettings].
  ///
  /// El método recibe un parámetro queryParams de tipo [ServicesUrlSettings], que contiene la URL y los parámetros de consulta necesarios para realizar la solicitud a la API remota.
  ///
  /// El método devuelve una instancia de [Future<MarvelCharacterModel>], que representa una promesa de que en algún momento en el futuro
  /// se obtendrá la lista de personajes de Marvel.
  /// Este método utiliza el cliente HTTP dio para realizar la solicitud a la API y luego utiliza un método [callApiWithErrorParser]
  /// para manejar cualquier error que pueda ocurrir durante la solicitud.
  /// Finalmente, devuelve una instancia de [MarvelCharacterModel] que se crea a partir de la respuesta de la API.
  @override
  Future<MarvelCharacterModel> getListCharacters(ServicesUrlSettings queryParams) {
    var dioCall = dioClient.get(queryParams.url, queryParameters: queryParams.toJson());

    try {
      return callApiWithErrorParser(dioCall).then((response) {
        return MarvelCharacterModel.fromMap(response.data);
      });
    } catch (e) {
      rethrow;
    }
  }
}
