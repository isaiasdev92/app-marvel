import 'package:marvel_app/core/model/page_state.dart';

/// Clase que representa el estado de una página de la aplicación. Contiene propiedades para indicar si la operación
/// realizada en la página fue exitosa o no, el mensaje y título a mostrar en la pantalla, la siguiente ruta a la que
/// se debe navegar y el estado de la página.
class PageStatus {
  final bool isSuccess;
  final String message;
  final String title;
  final String nextRoute;
  final PageState pageState;

  PageStatus({
    this.isSuccess = false,
    this.title = "",
    this.message = "",
    this.nextRoute = "",
    this.pageState = PageState.defaultInitial,
  });
}
