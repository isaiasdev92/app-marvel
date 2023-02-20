import 'package:marvel_app/network/exceptions/base_exception.dart';

/// La clase AppException extiende de BaseException y es utilizada para lanzar excepciones generales de la aplicación.
/// Recibe un argumento opcional message que se puede utilizar para proporcionar información adicional sobre la excepción.
class AppException extends BaseException {
  AppException({
    String message = "",
  }) : super(message: message);
}
