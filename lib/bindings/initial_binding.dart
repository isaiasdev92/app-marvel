import 'package:get/get.dart';
import 'package:marvel_app/bindings/local_hive_binding.dart';
import 'package:marvel_app/bindings/remote_source_binding.dart';
import 'package:marvel_app/bindings/repository_bindings.dart';

/// Clase que implementa la interfaz [Bindings] y se utiliza para definir las
/// dependencias necesarias para inicializar la aplicación.
class InitialBinding implements Bindings {
  /// Método que debe ser implementado al implementar la interfaz [Bindings].
  /// En este método se definen las dependencias necesarias para inicializar la
  /// aplicación.
  @override
  void dependencies() {
    RepositoryBindings().dependencies();
    RemoteSourceBindings().dependencies();
    LocalHiveBinding().dependencies();
  }
}
