/// Enum que describe los estados que puede tener un objeto [GeneralViewModelList].
///
/// Los estados son:
///
/// * none: cuando no se ha realizado ninguna acción sobre el objeto.
/// * success: cuando se ha obtenido una respuesta satisfactoria.
/// * loading: cuando se está realizando una acción sobre el objeto.
/// * error: cuando se ha producido un error al realizar una acción sobre el objeto.
/// * empty: cuando no se ha encontrado ningún resultado en la búsqueda realizada.
enum StatusViewModel { none, success, loading, error, empty }

/// Clase genérica que encapsula un conjunto de datos que representan una lista de elementos del modelo T.
class GeneralViewModelList<T> {
  GeneralViewModelList(
      {this.list = const [],
      this.totalRows = 0,
      this.totalPages = 0,
      this.sizePage = 0,
      this.pageIndex = 0,
      this.take = 0,
      this.message = "",
      this.status = StatusViewModel.none,
      this.listCurrent = const []});

  /// Estado actual del objeto [GeneralViewModelList].
  StatusViewModel status;

  /// Cantidad total de filas del conjunto de elementos.
  int totalRows;

  /// Cantidad total de páginas del conjunto de elementos.
  int totalPages;

  /// Cantidad de elementos por página.
  int sizePage;

  /// Número de página actual.
  int pageIndex;

  /// Cantidad de elementos que se tomarán.
  int take;

  /// Mensaje informativo que describe la acción realizada sobre el conjunto de elementos.
  String message;

  /// Lista de objetos del modelo T que representa el conjunto de elementos a manejar.
  List<T> list;

  /// Lista actual de elementos del modelo T.
  List<T> listCurrent;
}

class GeneralViewModelListLight<T> {
  GeneralViewModelListLight({this.list = const [], this.rowsTable = 0});

  /// Cantidad de filas de la tabla que se están mostrando.
  int rowsTable;

  /// Lista de objetos del modelo T que representa el conjunto de elementos a manejar.
  List<T> list;
}
