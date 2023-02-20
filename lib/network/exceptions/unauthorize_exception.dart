import 'dart:io';

import 'package:marvel_app/network/exceptions/base_api_exception.dart';

///Clase en Dart que extiende de BaseApiException y se utiliza para representar una excepción de autenticación no autorizada en la aplicación.
class UnauthorizedException extends BaseApiException {
  UnauthorizedException(String message)
      : super(httpCode: HttpStatus.unauthorized, message: message, status: "unauthorized");
}
