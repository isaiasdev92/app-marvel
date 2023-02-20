///Clase BaseException es una clase abstracta que implementa la interfaz Exception.
///Tiene una variable de instancia message que almacena un mensaje de error opcional.
///La clase es abstracta, lo que significa que no puede ser instanciada directamente,
///sino que debe ser heredada por otra clase para ser utilizada.
abstract class BaseException implements Exception {
  final String message;

  BaseException({this.message = ""});
}
