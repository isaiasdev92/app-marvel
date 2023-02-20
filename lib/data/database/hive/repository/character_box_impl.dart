import 'package:flutter/material.dart';
import 'package:marvel_app/core/model/general_view_model_list.dart';
import 'package:marvel_app/data/database/db_provider.dart';
import 'package:marvel_app/data/database/hive/models/marvel_characters_db_model.dart';
import 'package:marvel_app/data/database/hive/repository/character_box_abst.dart';

///Clase que implementa una interfaz llamada CharacterBoxAbst.
///La clase se utiliza para manejar la persistencia de objetos de tipo MarvelCharacterDbModel utilizando la base de datos local de Hive.
class CharacterBoxImpl implements CharacterBoxAbst {
  bool _isTest = false;

  CharacterBoxImpl({isTest = false}) {
    _isTest = isTest;
  }
  late Box<MarvelCharacterDbModel>? _characterBox;

  /// Es un método privado asincrónico que se utiliza para obtener una instancia de la base de datos de Hive. La instancia de la caja de personajes (_characterBox) se inicializa aquí.
  Future<void> _getDbInstance() async {
    _characterBox = await DbProviderHive.getCharacterBox(isTestValue: _isTest);
  }

  ///[getPaginatedList] es un método asincrónico que se utiliza para obtener una lista paginada de personajes de Marvel.
  ///
  ///Toma tres parámetros: pageNumber, pageSize y search. El parámetro search se utiliza para buscar personajes por nombre.
  ///
  ///Este método devuelve un objeto GeneralViewModelListLight que contiene la lista de personajes y el número total de filas.
  @override
  Future<GeneralViewModelListLight<MarvelCharacterDbModel>> getPaginatedList(
      int pageNumber, int pageSize, String search) async {
    var result = GeneralViewModelListLight<MarvelCharacterDbModel>();
    try {
      await _getDbInstance();
      if (pageSize == 0) {
        pageSize = 10;
      }
      final int start = pageNumber * pageSize;

      Iterable<MarvelCharacterDbModel> charactersIterable;

      if (search.isNotEmpty) {
        charactersIterable =
            _characterBox?.values.where((element) => element.name.toLowerCase().contains(search.toLowerCase())) ?? [];
      } else {
        charactersIterable = _characterBox?.values ?? [];
      }
      result.rowsTable = charactersIterable.length;
      if (result.rowsTable <= pageSize) {
        result.list = charactersIterable.toList();
      } else {
        result.list = charactersIterable.skip(start).take(pageSize).toList();
      }

      return Future.value(result);
    } catch (e, s) {
      debugPrint("$e =====> $s");
      return Future.value(result);
    }
  }

  ///[getById] es un método asincrónico que se utiliza para obtener un personaje por su identificación.
  ///Toma un parámetro id y devuelve un objeto MarvelCharacterDbModel.
  @override
  Future<MarvelCharacterDbModel> getById(int id) async {
    var character = MarvelCharacterDbModel(id: -1);
    try {
      await _getDbInstance();
      var character = _characterBox?.values
          .singleWhere((element) => element.id == id, orElse: () => MarvelCharacterDbModel(id: -1));
      return Future.value(character);
    } catch (e, s) {
      debugPrint("$e =====> $s");
      return Future.value(character);
    }
  }

  ///insert() es un método asincrónico que se utiliza para insertar un personaje en la base de datos.
  ///Toma un parámetro character de tipo MarvelCharacterDbModel y devuelve un booleano que indica si la inserción fue exitosa o no.
  @override
  Future<bool> insert(MarvelCharacterDbModel character) async {
    try {
      await _getDbInstance();
      await _characterBox?.add(character);
      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  }

  ///[total] es un método asincrónico que se utiliza para obtener el número total de personajes almacenados en la base de datos.
  ///Devuelve un entero.
  @override
  Future<int> total() async {
    try {
      await _getDbInstance();
      var charactersTotal = _characterBox?.length;
      return Future.value(charactersTotal);
    } catch (e, s) {
      debugPrint("$e =====> $s");
      return Future.value(0);
    }
  }

  ///[exist] es un método asincrónico que se utiliza para comprobar si un personaje existe en la base de datos. Toma un parámetro id y devuelve un booleano que indica si el personaje existe o no.
  @override
  Future<bool> exist(int id) async {
    try {
      await _getDbInstance();
      var exist = _characterBox?.values.any((element) => element.id == id);
      return Future.value(exist ?? false);
    } catch (e, s) {
      debugPrint("$e =====> $s");
      return Future.value(false);
    }
  }

  ///[insertBulk] es un método asincrónico que se utiliza para insertar una lista de personajes en la base de datos.
  ///Toma un parámetro values de tipo List<MarvelCharacterDbModel> y devuelve un booleano que indica si la inserción fue exitosa o no.
  @override
  Future<bool> insertBulk(List<MarvelCharacterDbModel> values) async {
    try {
      await _getDbInstance();
      await _characterBox?.addAll(values);
      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  }
}
