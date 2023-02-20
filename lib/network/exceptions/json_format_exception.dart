import 'package:marvel_app/network/exceptions/base_exception.dart';

///Clase JsonFormatException es una subclase de BaseException y se utiliza para indicar una excepción relacionada con el formato de JSON.
/// Toma un argumento message de tipo String en su constructor y lo pasa al constructor de la clase base.
class JsonFormatException extends BaseException {
  JsonFormatException(String message) : super(message: message);
}
