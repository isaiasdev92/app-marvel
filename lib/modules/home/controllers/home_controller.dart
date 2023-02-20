import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:get/get.dart';
import 'package:marvel_app/core/base/base_controller.dart';
import 'package:marvel_app/core/model/general_view_model_list.dart';
import 'package:marvel_app/core/model/search_query_param.dart';
import 'package:marvel_app/core/values/app_values.dart';
import 'package:marvel_app/data/database/hive/models/marvel_characters_db_model.dart';
import 'package:marvel_app/data/database/hive/repository/character_box_abst.dart';
import 'package:marvel_app/data/remote/models/marvel_character_marvel_model.dart';
import 'package:marvel_app/data/remote/repository/abstracts/characters_repository_abst.dart';
import 'package:marvel_app/modules/home/models/characters_list_ui_model.dart';

/// Es una clase que obtiene datos de una API remota y los guarda en una base de datos local
class HomeController extends BaseController {
  final CharactersRepositoryAbst _repository = Get.find(tag: (CharactersRepositoryAbst).toString());
  final CharacterBoxAbst _hive = Get.find(tag: (CharacterBoxAbst).toString());
  final ReceivePort _receivePort = ReceivePort();

  late Isolate? _isolate;
  late GeneralViewModelList<ItemListUiModel> _charactersListUi;
  final RxBool _isLoadingDataRemote = false.obs;

  GeneralViewModelList<ItemListUiModel> get charactersList => _charactersListUi;
  bool get loadingData => _isLoadingDataRemote.value;

  bool _isLoadFirst = true;
  int _totalRowsLocal = 0;

  /// _initialData() es llamada para inicializar los datos, _receivePort.listen() es llamada para escuchar los datos
  /// desde el lado nativo, y super.onInit() es llamado para inicializar el plugin
  @override
  void onInit() {
    _initialData();
    _receivePort.listen((message) => _onListenData(message));
    super.onInit();
  }

  /// Es una función que obtiene una lista de caracteres de una API remota y los guarda en una base de datos local
  ///
  /// Args:
  /// searchTerms (String): El término de búsqueda que introdujo el usuario.
  /// isReset (bool): Si es true, reiniciará la lista y empezará desde el principio.
  ///
  /// Devuelve:
  /// El tipo de retorno es Future.
  Future getCharactersList(String searchTerms, bool isReset) async {
    showLoading();
    _totalRowsLocal = await _hive.total();

    if (_totalRowsLocal == 0) {
      _isLoadingDataRemote.value = true;
      var listRemote = GeneralViewModelList<MarvelCharacterDbModel>(
          list: [],
          totalPages: 0,
          totalRows: 0,
          sizePage: AppValues.initialPageSizeRemote,
          pageIndex: AppValues.defaultPageNumber);

      var queryParam = ServicesUrlSettings(
          url: "$baseUrl/v1/public/characters",
          apiKey: FlutterConfig.get('PUBLIC_KEY'),
          hashValue: FlutterConfig.get('HASH_VALUE'),
          timestamp: FlutterConfig.get('TIMESTAMP'),
          pageNumber: listRemote.take,
          perPage: listRemote.sizePage);

      _isolate = await Isolate.spawn<List<dynamic>>(
          HomeController._getCharactersRemote, [_receivePort.sendPort, queryParam, _repository]);

      return;
    }
    await _getCharactersListLocal(searchTerms, isReset);
  }

  /// _getCharactersRemote es una función estática que toma una lista de objetos dinámicos como argumentos. Se
  /// devuelve un Future de tipo GeneralViewModelList<MarvelCharacterDbModel> y está marcada como async
  ///
  /// Args:
  /// args (List<dynamic>): List<dynamic>
  ///
  /// Devuelve:
  /// Una lista de caracteres.
  static void _getCharactersRemote(List<dynamic> args) async {
    var sendPort = args[0] as SendPort;
    var listRemote = GeneralViewModelList<MarvelCharacterDbModel>(
        list: [],
        totalPages: 0,
        totalRows: 0,
        sizePage: AppValues.initialPageSizeRemote,
        pageIndex: AppValues.defaultPageNumber);

    try {
      var queryParam = args[1] as ServicesUrlSettings;
      var repository = args[2] as CharactersRepositoryAbst;

      listRemote = GeneralViewModelList<MarvelCharacterDbModel>(
          list: [],
          totalPages: 0,
          totalRows: 0,
          sizePage: AppValues.initialPageSizeRemote,
          pageIndex: AppValues.defaultPageNumber);

      var isStop = false;
      int pageRemote = 1;
      bool isLoadRemote = true;
      while (!isStop) {
        queryParam.pageNumber = listRemote.take;
        queryParam.perPage = listRemote.sizePage;

        await _getDataServices(queryParam, listRemote, repository);

        if (pageRemote >= listRemote.totalPages) {
          isStop = true;
          sendPort.send(listRemote);
          return;
        }
        pageRemote++;

        if (isLoadRemote) {
          sendPort.send(listRemote);
          isLoadRemote = false;
        } else {
          sendPort.send(listRemote);
        }
      }
    } catch (e) {
      debugPrint("$e");
      listRemote.status = StatusViewModel.error;
      sendPort.send(listRemote);
    }
  }

  /// _getCharactersListLocal() es una función que obtiene los datos de la base de datos local y actualiza la
  /// UI
  ///
  /// Args:
  /// searchTerms (String): El término de búsqueda que ha introducido el usuario.
  /// isReset (bool): Si es true, reiniciará el pageIndex a 0 y la lista a vacía.
  ///
  /// Devuelve:
  /// Un Futuro.
  Future _getCharactersListLocal(String searchTerms, bool isReset) async {
    try {
      if (isReset) _initialData();

      if (_charactersListUi.status == StatusViewModel.loading) {
        return;
      }

      _charactersListUi.status = StatusViewModel.loading;

      if (!_isLoadFirst) {
        _charactersListUi.sizePage = AppValues.defaultPageSize;
      }

      var results = _hive.getPaginatedList(_charactersListUi.pageIndex, _charactersListUi.sizePage, searchTerms);
      _charactersListUi.pageIndex++;

      await callDataServiceDatabase(results,
          onSuccess: _getDatabaseLocalServicesSuccess, onError: _getDatabaseLocalServicesError);

      update();
    } catch (e) {
      _charactersListUi.list = [];
      _charactersListUi.status = StatusViewModel.error;
      update();
    }
  }

  /// Esta función recibe una respuesta de tipo [GeneralViewModelListLight] que contiene una lista de objetos [MarvelCharacterDbModel]
  /// de un servicio de base de datos local.
  /// Asigna la lista de objetos a una nueva lista de objetos [ItemListUiModel],
  /// y asigna la nueva lista a la variable [_charactersListUi].
  /// También establece el estado de [_charactersListUi] a [StatusViewModel.success] y establece el número total de filas al número total
  ///  de objetos en la base de datos llamando a [_hive.total()].
  /// Si se produce un error durante este proceso, el estado de [_charactersListUi] se establece en [StatusViewModel.error] y se borra la lista.
  void _getDatabaseLocalServicesSuccess(GeneralViewModelListLight<MarvelCharacterDbModel> response) async {
    try {
      var filterList = response.list;
      var resulst = filterList
          .map((item) => ItemListUiModel(
              description: item.description, id: item.id, name: item.name, thumbnailUrl: item.thumbnailUrl))
          .toList();

      _charactersListUi.status = StatusViewModel.success;

      _charactersListUi.listCurrent = resulst;
      _charactersListUi.totalRows = await _hive.total();
      _charactersListUi.list.addAll(resulst);
      _isLoadFirst = false;
    } catch (e) {
      _charactersListUi.status = StatusViewModel.error;
      _charactersListUi.list = [];
    }
  }

  /// _getDatabaseLocalServicesError() es una función que toma una excepción como parámetro y establece la
  /// lista a una lista vacía y el estado a error
  ///
  /// Args:
  /// exception (Excepción): La excepción lanzada.
  void _getDatabaseLocalServicesError(Exception exception) {
    _charactersListUi.list = [];
    _charactersListUi.status = StatusViewModel.error;
  }

  /// _getDataServices() es una función estática que llama a un servicio y devuelve un Futuro
  ///
  /// Args:
  /// queryParam (ServicesUrlSettings): Es el parámetro de consulta que se pasará al servicio.
  /// listRemote (GeneralViewModelList<MarvelCharacterDbModel>): es la lista que se rellenará con los datos de la API
  /// repository (CharactersRepositoryAbst): es el repositorio que se utilizará para obtener los datos de la fuente remota.
  static Future _getDataServices(ServicesUrlSettings queryParam,
      GeneralViewModelList<MarvelCharacterDbModel> listRemote, CharactersRepositoryAbst repository) async {
    var githubRepoSearchService = repository.getCharacters(queryParam);

    await BaseController.callDataServiceIsolate(githubRepoSearchService,
        onSuccess: _handleProjectListResponseSuccess, onError: _handleError, argsOnSuccess: listRemote);
  }

  /// _handleProjectListResponseSuccess es una función estática que toma un MarvelCharacterModel
  /// responseHttp y un args dinámico como parámetros. Devuelve un void
  ///
  /// Args:
  /// responseHttp (MarvelCharacterModel): La respuesta de la API
  /// args (dynamic): es el objeto que se pasa a la función.
  static void _handleProjectListResponseSuccess(MarvelCharacterModel responseHttp, dynamic args) {
    var listRemote = GeneralViewModelList<MarvelCharacterDbModel>(list: []);
    try {
      listRemote = args as GeneralViewModelList<MarvelCharacterDbModel>;
      var data = responseHttp.data;
      var resultsList = data!.results ?? [];

      var results = resultsList
          .map((item) => MarvelCharacterDbModel(
              description: item.description ?? "---",
              id: item.id ?? 0,
              name: item.name ?? "---",
              modified: item.modified ?? "",
              thumbnailUrl: "${item.thumbnail?.path}.${item.thumbnail?.extension}"))
          .toList();

      listRemote.take += listRemote.sizePage;

      if (data.total != listRemote.totalRows) {
        listRemote.totalRows = data.total ?? 0;
        var totalPages = listRemote.totalRows / listRemote.sizePage;
        listRemote.totalPages = totalPages.ceil();
      }

      listRemote.status = StatusViewModel.success;
      listRemote.list.addAll(results);
      listRemote.listCurrent = results;
    } catch (e) {
      listRemote.status = StatusViewModel.error;
      debugPrint("$e");
    }
  }

  /// It prints the exception to the console.
  ///
  /// Args:
  ///   exception (Exception): The exception that was thrown.
  static void _handleError(Exception exception) {
    print("$exception");
  }

  /// _onListenData(mensaje dynamic) {
  /// hideLoading();
  ///
  /// var results = mensaje as GeneralViewModelList<MarvelCharacterDbModel>;
  ///
  /// if (results.status == StatusViewModel.error) {
  /// showErrorMessage("Error al obtener los datos");
  /// return;
  /// }
  /// _saveCharactersDatabase(results);
  /// }
  ///
  /// Args:
  /// mensaje (dinámico): El mensaje que se envió desde el otro aislado.
  ///
  /// Devuelve:
  /// Un GeneralViewModelList&lt;MarvelCharacterDbModel&gt;
  _onListenData(dynamic message) {
    hideLoading();

    var results = message as GeneralViewModelList<MarvelCharacterDbModel>;

    if (results.status == StatusViewModel.error) {
      showErrorMessage("Error al obtener los datos");
      return;
    }
    _saveCharactersDatabase(results);
  }

  /// _saveCharactersDatabase() se llama desde el aislado, y guarda los datos en la base de datos
  ///
  /// Args:
  /// resultados (GeneralViewModelList<MarvelCharacterDbModel>):
  /// GeneralViewModelList<MarvelCharacterDbModel>
  ///
  /// Devuelve:
  /// Una lista de caracteres.
  void _saveCharactersDatabase(GeneralViewModelList<MarvelCharacterDbModel> results) async {
    _totalRowsLocal = await _hive.total();

    await _hive.insertBulk(results.listCurrent);

    if (_totalRowsLocal == 0) {
      debugPrint("Total remoto: ${results.totalRows}");

      await _getCharactersListLocal("", _isLoadFirst);
      return;
    }

    _totalRowsLocal = await _hive.total();
    _charactersListUi.totalRows = _totalRowsLocal;

    if (results.totalRows == _totalRowsLocal) {
      if (_isolate != null) {
        _isolate!.kill(priority: Isolate.immediate);
        _isolate = null;
      }

      _isLoadingDataRemote.value = false;
    }
    update();
  }

  /// _initialData() es una función que inicializa los datos por primera vez
  void _initialData() {
    _isLoadFirst = true;
    _charactersListUi = GeneralViewModelList<ItemListUiModel>(
        list: [],
        totalPages: 0,
        totalRows: 0,
        sizePage: AppValues.initialPageSize,
        pageIndex: AppValues.defaultPageNumberLocal);
  }
}
