import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marvel_app/data/database/db_provider.dart';
import 'package:marvel_app/data/database/hive/models/marvel_characters_db_model.dart';
import 'package:marvel_app/data/database/hive/repository/character_box_abst.dart';
import 'package:marvel_app/data/database/hive/repository/character_box_impl.dart';

export 'package:hive/hive.dart';

void main() {
  List<int> generarNumerosAleatorios() {
    final random = Random();
    final numerosAleatorios = <int>[];

    for (int i = 0; i < 10; i++) {
      int numero = 1000 + random.nextInt(1000);
      numerosAleatorios.add(numero);
    }

    return numerosAleatorios;
  }

  group('CharacterBoxImpl', () {
    late CharacterBoxAbst characterBox;

    List<int> listIds = generarNumerosAleatorios();

    setUpAll(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
      const MethodChannel('plugins.flutter.io/path_provider').setMockMethodCallHandler((MethodCall methodCall) async {
        if (methodCall.method == 'getApplicationDocumentsDirectory') {
          return '/mock/directory/path';
        }
        return null;
      });
      await DbProviderHive.dispose(isTest: true);
      await DbProviderHive.initSettings(isTest: true); //Initializes the database
    });

    setUp(() async {
      characterBox = CharacterBoxImpl(isTest: true);
    });

    test('getById should return a MarvelCharacterDbModel with matching id', () async {
      final character = MarvelCharacterDbModel(id: listIds.first, name: 'Spider-Man');
      await characterBox.insert(character);
      final result = await characterBox.getById(listIds.first);
      expect(result, equals(character));
    });

    test('getById should return a MarvelCharacterDbModel with id = -1 if character with matching id not found',
        () async {
      final result = await characterBox.getById(999865);
      expect(result.id, equals(-1));
    });

    test('insert should return true if character was successfully inserted', () async {
      final character = MarvelCharacterDbModel(id: listIds.last, name: 'Spider-Man');
      final result = await characterBox.insert(character);
      expect(result, isTrue);
    });

    test('insert should return false if character was not successfully inserted', () async {
      final character = MarvelCharacterDbModel(id: listIds.first, name: 'Spider-Man');
      await characterBox.insert(character);
      final result = await characterBox.insert(character);
      expect(result, isFalse);
    });

    test('exist should return true if character with matching id exists', () async {
      final character = MarvelCharacterDbModel(id: listIds[2], name: 'Spider-Man');
      await characterBox.insert(character);
      final result = await characterBox.exist(listIds[2]);
      expect(result, isTrue);
    });

    test('exist should return false if character with matching id does not exist', () async {
      final result = await characterBox.exist(126125);
      expect(result, isFalse);
    });
  });

  tearDownAll(() async {
    await DbProviderHive.dispose(isTest: true);
  });
}
