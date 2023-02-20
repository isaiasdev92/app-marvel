import 'dart:io';

import 'package:marvel_app/network/exceptions/base_api_exception.dart';

///Clase ServiceUnavailableException es una subclase de BaseApiException.
///Esta clase representa una excepción que se produce cuando un servicio no está disponible temporalmente.
///Tiene un constructor que toma una cadena message y llama al constructor de la superclase BaseApiException con los valores httpCode,
///message y status correspondientes al error 503 de HTTP que representa la indisponibilidad del servicio.
class ServiceUnavailableException extends BaseApiException {
  ServiceUnavailableException(String message)
      : super(httpCode: HttpStatus.serviceUnavailable, message: message, status: "");
}
