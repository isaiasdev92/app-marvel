import 'package:marvel_app/network/exceptions/app_exception.dart';

/// Clase abstracta que extiende de AppException.
/// Define una excepción base para errores que pueden ocurrir en las solicitudes a una API.
abstract class BaseApiException extends AppException {
  final int httpCode;
  final String status;

  BaseApiException({this.httpCode = -1, this.status = "", String message = ""}) : super(message: message);
}
