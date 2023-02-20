import 'dart:io';

import 'package:marvel_app/network/exceptions/api_exception.dart';

///Clase NotFoundException extiende de ApiException y se utiliza para indicar que el recurso solicitado no fue encontrado.
///Toma dos parámetros en su constructor: message y status. Luego, llama al constructor de la clase ApiException,
///pasando el código de estado HTTP 404 (que representa la respuesta de "no encontrado"),
///el estado y el mensaje proporcionado en los parámetros.
class NotFoundException extends ApiException {
  NotFoundException(String message, String status)
      : super(httpCode: HttpStatus.notFound, status: status, message: message);
}
