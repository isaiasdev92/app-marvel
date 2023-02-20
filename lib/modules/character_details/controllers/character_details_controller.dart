import 'package:get/get.dart';
import 'package:marvel_app/core/base/base_controller.dart';
import 'package:marvel_app/data/database/hive/models/marvel_characters_db_model.dart';
import 'package:marvel_app/data/database/hive/repository/character_box_abst.dart';
import 'package:marvel_app/modules/character_details/models/character_details_model.dart';
import 'package:marvel_app/modules/home/models/characters_list_ui_model.dart';
import 'package:intl/intl.dart';

/// Esta clase representa el controlador de la pantalla de detalles de personajes, que se encarga de manejar la lógica y la obtención de datos necesarios para mostrar los detalles del personaje seleccionado.
///
/// Utiliza un objeto de la clase CharacterBoxAbst para acceder a los datos almacenados en la base de datos local.
class CharacterDetailsController extends BaseController {
  final CharacterBoxAbst _hive = Get.find(tag: (CharacterBoxAbst).toString());

  /// Representa los detalles del personaje seleccionado, como su descripción, nombre, identificador, URL de miniatura y fecha de modificación.
  final Rx<CharacterDetailsModel> _charactersDetails = CharacterDetailsModel().obs;

  /// Devuelve los detalles del personaje seleccionado.
  CharacterDetailsModel get characterDetailsUiData => _charactersDetails.value;

  /// Se ejecuta cuando se inicializa el controlador. Si se pasa un objeto ItemListUiModel como argumento al controlador,
  /// llama al método getDetailsLocal para obtener los detalles del personaje seleccionado.
  @override
  void onInit() {
    var dataModel = Get.arguments;
    if (dataModel is ItemListUiModel) {
      getDetailsLocal(dataModel.id);
    }
    super.onInit();
  }

  /// Obtiene los detalles del personaje seleccionado de la base de datos local.
  void getDetailsLocal(characterId) {
    callDataServiceDatabase(
      _hive.getById(characterId),
      onSuccess: _handleCharacterDetailsResponseSuccess,
    );
  }

  /// Se ejecuta cuando se obtienen los detalles del personaje seleccionado de la base de datos local.
  /// Convierte la fecha de modificación a un objeto DateTime y actualiza los detalles del personaje.
  void _handleCharacterDetailsResponseSuccess(MarvelCharacterDbModel item) {
    DateFormat formatoFecha = DateFormat("yyyy-MM-dd'T'HH:mm:ssZ");
    DateTime modifiedDateTime = formatoFecha.parse(item.modified);

    _charactersDetails(CharacterDetailsModel(
        description: item.description.isEmpty ? "No hay descripción" : item.description,
        id: item.id,
        modified: modifiedDateTime,
        name: item.name,
        thumbnailUrl: item.thumbnailUrl));
  }
}
