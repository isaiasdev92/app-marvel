import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
export 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:marvel_app/data/database/hive/models/marvel_characters_db_model.dart';
import 'package:path_provider/path_provider.dart';

/// Clase que proporciona una instancia de Hive y permite el acceso a la base de datos de personajes de Marvel.
class DbProviderHive {
  static final DbProviderHive _singleton = DbProviderHive._internal();
  static const _folderName = 'marveldb';
  static const _folderNameTest = 'marveldbTest';
  static String databasePath = "";

  factory DbProviderHive() {
    return _singleton;
  }

  /// Método privado para inicializar los ajustes de la base de datos.
  DbProviderHive._internal() {
    initSettings();
  }

  /// Método estático para inicializar los ajustes de la base de datos.
  /// Registra un adaptador de modelo para el modelo de personajes de Marvel y abre una caja para almacenar los personajes.
  static Future<void> initSettings({bool isTest = false}) async {
    try {
      final databasePathRoot = await getApplicationDocumentsDirectory();
      final dataBasePath = databasePathRoot.path;

      databasePath = !isTest ? "$dataBasePath/$_folderName" : "$dataBasePath/$_folderNameTest";

      await Hive.initFlutter(databasePath);

      if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(MarvelCharacterDbModelAdapter());

      if (isTest) {
        await Hive.openBox<MarvelCharacterDbModel>(MarvelCharacterDbModel.tableNameTest);
      } else {
        await Hive.openBox<MarvelCharacterDbModel>(MarvelCharacterDbModel.tableName);
      }
    } catch (e) {
      Future.error(e.toString());
    }
  }

  /// Método estático que devuelve una caja de personajes de Marvel.
  static Future<Box<MarvelCharacterDbModel>>? getCharacterBox({bool isTestValue = false}) async {
    Box<MarvelCharacterDbModel>? charactersBox;
    bool isInitialize = false;

    try {
      if (isTestValue) {
        charactersBox = Hive.box<MarvelCharacterDbModel>(MarvelCharacterDbModel.tableNameTest);
      } else {
        charactersBox = Hive.box<MarvelCharacterDbModel>(MarvelCharacterDbModel.tableName);
      }
    } catch (e) {
      debugPrint("$e");
      isInitialize = true;
    }

    if (isInitialize) {
      try {
        await initSettings(isTest: isTestValue);
        if (isTestValue) {
          charactersBox = Hive.box<MarvelCharacterDbModel>(MarvelCharacterDbModel.tableNameTest);
        } else {
          charactersBox = Hive.box<MarvelCharacterDbModel>(MarvelCharacterDbModel.tableName);
        }
      } catch (e) {
        debugPrint("$e");
      }
    }

    return Future.value(charactersBox);
  }

  /// Método estático que cierra la base de datos.
  static Future<void> dispose({bool isTest = false}) async {
    try {
      await Hive.deleteBoxFromDisk(databasePath);
      await Hive.close();
    } catch (e) {
      debugPrint("CLOSE");
    }
  }

  static join(String dataBasePath, String folderName) {}
}
