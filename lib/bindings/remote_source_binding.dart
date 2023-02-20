import 'package:get/get.dart';
import 'package:marvel_app/data/remote/characters/characters_data_source_abst.dart';
import 'package:marvel_app/data/remote/characters/characters_data_source_impl.dart';

/// Clase que implementa la interfaz [Bindings] y se utiliza para definir las
/// dependencias necesarias para acceder a los servicios web.
class RemoteSourceBindings implements Bindings {
  /// Método que debe ser implementado al implementar la interfaz [Bindings].
  /// En este método se definen las dependencias necesarias para acceder a los servicios web
  @override
  void dependencies() {
    Get.lazyPut<CharactersDataSourceAbst>(() => CharactersDataSourceImpl(),
        tag: (CharactersDataSourceAbst).toString(), fenix: true);
  }
}
