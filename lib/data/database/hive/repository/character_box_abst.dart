import 'package:marvel_app/core/model/general_view_model_list.dart';
import 'package:marvel_app/data/database/hive/models/marvel_characters_db_model.dart';

/// Esta es una clase abstracta que define un contrato para acceder y manipular los datos de personajes de Marvel en una base de datos.
/// Contiene varios métodos abstractos que deben ser implementados por las clases que la extienden.
abstract class CharacterBoxAbst {
  ///[insert]: un método asíncrono que toma un objeto de modelo de personaje de Marvel y devuelve un booleano que indica si la inserción fue exitosa.
  Future<bool> insert(MarvelCharacterDbModel character);

  ///[insertBulk]: un método asíncrono que toma una lista de objetos de modelo de personajes de Marvel y devuelve un booleano que indica si la inserción de la lista fue exitosa.
  Future<bool> insertBulk(List<MarvelCharacterDbModel> value);

  ///[getPaginatedList]: un método asíncrono que toma un número de página, un tamaño de página y una cadena de búsqueda, y devuelve un objeto GeneralViewModelListLight de personajes de Marvel paginados.
  Future<GeneralViewModelListLight<MarvelCharacterDbModel>> getPaginatedList(
      int pageNumber, int pageSize, String search);

  ///[getById]: un método asíncrono que toma un ID de personaje y devuelve un objeto de modelo de personaje de Marvel.
  Future<MarvelCharacterDbModel> getById(int id);

  ///[exist]: un método asíncrono que toma un ID de personaje y devuelve un booleano que indica si el personaje existe en la base de datos.
  Future<bool> exist(int id);

  ///[total]: un método asíncrono que devuelve el número total de personajes almacenados en la base de datos.
  Future<int> total();
}
