import 'package:get/get.dart';
import 'package:marvel_app/modules/character_details/controllers/character_details_controller.dart';

/// Esta clase es una implementación de Bindings que se utiliza para realizar la inyección de dependencias de CharacterDetailsController.
class CharacterDetailsBinding extends Bindings {
  /// Este método se utiliza para configurar y registrar las dependencias necesarias para CharacterDetailsController.
  @override
  void dependencies() {
    Get.lazyPut<CharacterDetailsController>(
      () => CharacterDetailsController(),
    );
  }
}
