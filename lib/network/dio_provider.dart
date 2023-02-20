import 'package:dio/dio.dart';

/// Clase DioProvider
class DioProvider {
  /// Una variable privada estática para almacenar una única instancia de Dio.
  static Dio? _instance;

  /// Una función privada que devuelve una instancia de Dio si no existe una instancia,
  /// y si ya existe una instancia, la limpia y la devuelve.
  static Dio get _httpDio {
    if (_instance == null) {
      _instance = Dio();

      return _instance!;
    } else {
      _instance!.interceptors.clear();

      return _instance!;
    }
  }

  /// Una función pública que devuelve una instancia de Dio con los interceptores agregados.
  static Dio get instance {
    _addInterceptors();

    return _instance!;
  }

  /// Una función privada que agrega los interceptores a la instancia de Dio.
  static _addInterceptors() {
    _instance ??= _httpDio;

    _instance?.options.contentType = "application/json";
    _instance!.interceptors.clear();
  }
}
