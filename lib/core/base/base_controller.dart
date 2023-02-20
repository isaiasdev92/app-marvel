import 'package:flutter_config/flutter_config.dart';
import 'package:get/get.dart';

import 'package:marvel_app/core/model/page_state.dart';
import 'package:marvel_app/network/exceptions/api_exception.dart';
import 'package:marvel_app/network/exceptions/app_exception.dart';
import 'package:marvel_app/network/exceptions/json_format_exception.dart';
import 'package:marvel_app/network/exceptions/network_exception.dart';
import 'package:marvel_app/network/exceptions/not_found_exception.dart';
import 'package:marvel_app/network/exceptions/service_unavailable_exception.dart';
import 'package:marvel_app/network/exceptions/timeout_exception.dart';
import 'package:marvel_app/network/exceptions/unauthorize_exception.dart';

/// Esta clase es la base de todos los controladores en la aplicación.
/// Proporciona algunos métodos útiles para llamar a servicios web, gestionar el estado de la página y manejar excepciones.
abstract class BaseController extends GetxController {
  final String baseUrl = FlutterConfig.get('API_URL');

  final _pageStateController = PageState.defaultInitial.obs;

  PageState get pageState => _pageStateController.value;

  _updatePageState(PageState state) => _pageStateController(state);

  _resetPageState() => _pageStateController(PageState.defaultInitial);

  showLoading() => _updatePageState(PageState.loading);

  hideLoading() => _resetPageState();

  final _errorMessageController = ''.obs;

  String get errorMessage => _errorMessageController.value;

  showErrorMessage(String msg) {
    _errorMessageController(msg);
  }

  /// Este método es el método principal para llamar a servicios web.
  /// Recibe una [Future] que representa la llamada al servicio web.
  /// Tiene varios argumentos opcionales:
  /// - onError: una función que se ejecutará cuando ocurra una excepción.
  /// - onSuccess: una función que se ejecutará cuando se obtenga una respuesta exitosa.
  /// - onStart: una función que se ejecutará al principio de la llamada al servicio web.
  /// - onComplete: una función que se ejecutará al final de la llamada al servicio web.
  dynamic callDataService<T>(
    Future<T> future, {
    Function(Exception exception)? onError,
    Function(T response)? onSuccess,
    Function? onStart,
    Function? onComplete,
  }) async {
    Exception? exceptionData;

    onStart == null ? showLoading() : onStart();

    try {
      final T response = await future;

      if (onSuccess != null) onSuccess(response);

      onComplete == null ? hideLoading() : onComplete();

      return response;
    } on ServiceUnavailableException catch (exception) {
      exceptionData = exception;
      showErrorMessage(exception.message);
    } on UnauthorizedException catch (exception) {
      exceptionData = exception;
      showErrorMessage(exception.message);
    } on TimeoutException catch (exception) {
      exceptionData = exception;
      showErrorMessage(exception.message);
    } on NetworkException catch (exception) {
      exceptionData = exception;
      showErrorMessage(exception.message);
    } on JsonFormatException catch (exception) {
      exceptionData = exception;
      showErrorMessage(exception.message);
    } on NotFoundException catch (exception) {
      exceptionData = exception;
      showErrorMessage(exception.message);
    } on ApiException catch (exception) {
      exceptionData = exception;
    } on AppException catch (exception) {
      exceptionData = exception;
      showErrorMessage(exception.message);
    } catch (error) {
      exceptionData = AppException(message: "$error");
      showErrorMessage("Error desconocido");
    }

    if (onError != null) onError(exceptionData);

    onComplete == null ? hideLoading() : onComplete();
  }

  /// Este método es el método principal para llamar a los servicios de la base de datos
  /// Recibe una [Future] que representa la llamada a la base de datos.
  /// Tiene varios argumentos opcionales:
  /// - onError: una función que se ejecutará cuando ocurra una excepción.
  /// - onSuccess: una función que se ejecutará cuando se obtenga una respuesta exitosa.
  /// - onStart: una función que se ejecutará al principio de la llamada de los servicios de base de datos.
  /// - onComplete: una función que se ejecutará al final de la llamada de los servicios de base de datos
  dynamic callDataServiceDatabase<T>(
    Future<T> future, {
    Function(Exception exception)? onError,
    Function(T response)? onSuccess,
    Function? onStart,
    Function? onComplete,
  }) async {
    Exception? exceptionData;

    onStart == null ? showLoading() : onStart();

    try {
      final T response = await future;

      if (onSuccess != null) onSuccess(response);

      onComplete == null ? hideLoading() : onComplete();

      return response;
    } catch (error) {
      exceptionData = AppException(message: "$error");
      showErrorMessage("Error desconocido");
    }

    if (onError != null) onError(exceptionData);

    onComplete == null ? hideLoading() : onComplete();
  }

  /// Permite llamar a un servicio web de forma asíncrona utilizando un Future.
  /// La función acepta varias funciones de callback que se ejecutarán en diferentes momentos del proceso,
  /// tales como en el inicio, éxito, error y finalización.
  ///
  /// future: Un objeto Future que representa la respuesta del servicio web.
  /// onError: Una función de callback que se ejecuta en caso de que se produzca un error durante la llamada al servicio.
  /// onSuccess: Una función de callback que se ejecuta si la llamada al servicio fue exitosa. Esta función también acepta argumentos adicionales que se pueden pasar mediante el parámetro argsOnSuccess.
  /// argsOnSuccess: Un parámetro opcional que se puede utilizar para pasar argumentos adicionales a la función de callback onSuccess.
  static dynamic callDataServiceIsolate<T>(Future<T> future,
      {Function(Exception exception)? onError,
      Function(T response, dynamic argsOnSuccess)? onSuccess,
      dynamic argsOnSuccess}) async {
    Exception? exceptionData;

    try {
      final T response = await future;

      if (onSuccess != null) onSuccess(response, argsOnSuccess);

      return response;
    } on ServiceUnavailableException catch (exception) {
      exceptionData = exception;
    } on UnauthorizedException catch (exception) {
      exceptionData = exception;
    } on TimeoutException catch (exception) {
      exceptionData = exception;
    } on NetworkException catch (exception) {
      exceptionData = exception;
    } on JsonFormatException catch (exception) {
      exceptionData = exception;
    } on NotFoundException catch (exception) {
      exceptionData = exception;
    } on ApiException catch (exception) {
      exceptionData = exception;
    } on AppException catch (exception) {
      exceptionData = exception;
    } catch (error) {
      exceptionData = AppException(message: "$error");
    }

    if (onError != null) onError(exceptionData);
  }

  /// Este método se llama cuando se cierra el controlador de estado de la página.
  /// Se encarga de cerrar el stream controller `_pageStateController`
  /// y luego llama a la implementación base de `onClose`.
  @override
  void onClose() {
    _pageStateController.close();
    super.onClose();
  }
}
