import 'package:marvel_app/network/exceptions/base_exception.dart';

///Clase se llama TimeoutException y extiende de BaseException. Esta excepción se lanza cuando se produce un tiempo de espera
///de una operación en la aplicación. Toma un argumento message que es una descripción de la excepción.
class TimeoutException extends BaseException {
  TimeoutException(String message) : super(message: message);
}
