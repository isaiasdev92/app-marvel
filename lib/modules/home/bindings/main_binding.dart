import 'package:get/get.dart';
import 'package:marvel_app/modules/home/controllers/home_controller.dart';

/// Esta clase es una extensión de la clase Bindings de GetX.
/// Es utilizada para establecer las dependencias de la vista principal.
/// En este caso, se está usando el método lazyPut de GetX, que
/// crea una instancia de HomeController solo cuando se llama a Get.find<HomeController>()
class MainBinding extends Bindings {
  /// Define las dependencias necesarias para el funcionamiento de la vista. En este caso, se utiliza el método [Get.lazyPut()]
  /// para realizar la inyección de dependencia de la clase [HomeController] de forma diferida, es decir, se crea la instancia
  /// del controlador en el momento en el que es necesaria y no antes.
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
  }
}
