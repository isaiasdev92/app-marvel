import 'package:get/get.dart';
import 'package:marvel_app/data/remote/repository/abstracts/characters_repository_abst.dart';
import 'package:marvel_app/data/remote/repository/implements/characters_repository_impl.dart';

/// Clase que implementa la interfaz [Bindings] y se utiliza para definir las
/// dependencias necesarias para acceder al repositorio de personajes.
class RepositoryBindings implements Bindings {
  /// Método que debe ser implementado al implementar la interfaz [Bindings].
  /// En este método se definen las dependencias necesarias para acceder al
  /// repositorio de personajes.
  @override
  void dependencies() {
    Get.lazyPut<CharactersRepositoryAbst>(
      () => CharactersRepositoryImpl(),
      tag: (CharactersRepositoryAbst).toString(),
    );
  }
}
