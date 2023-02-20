import 'package:marvel_app/network/exceptions/base_exception.dart';

///lase NetworkException es una subclase de BaseException y representa una excepción que puede ser lanzada cuando se produce un error en la comunicación de red.
class NetworkException extends BaseException {
  NetworkException(String message) : super(message: message);
}
