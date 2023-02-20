import 'package:marvel_app/network/exceptions/base_api_exception.dart';

/// Esta es una clase que representa una excepción específica de una API. Extiende de la clase BaseApiException,
/// y recibe como parámetros el código HTTP, el estado y un mensaje opcional. Al crear una instancia de esta clase,
/// se llama al constructor de la clase base para inicializar los campos heredados y propios de la clase.
class ApiException extends BaseApiException {
  ApiException({
    required int httpCode,
    required String status,
    String message = "",
  }) : super(httpCode: httpCode, status: status, message: message);
}
