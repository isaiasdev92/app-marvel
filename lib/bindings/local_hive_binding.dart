import 'package:get/get.dart';
import 'package:marvel_app/data/database/hive/repository/character_box_abst.dart';
import 'package:marvel_app/data/database/hive/repository/character_box_impl.dart';

/// Clase que implementa la interfaz [Bindings] y se utiliza para definir las
/// dependencias necesarias para acceder a una base de datos local usando Hive.
class LocalHiveBinding implements Bindings {
  /// Método que debe ser implementado al implementar la interfaz [Bindings].
  /// En este método se definen las dependencias necesarias para acceder a una
  /// base de datos local usando Hive.
  @override
  void dependencies() {
    Get.lazyPut<CharacterBoxAbst>(
      () => CharacterBoxImpl(),
      tag: (CharacterBoxAbst).toString(),
    );
  }
}
