import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:marvel_app/network/dio_provider.dart';
import 'package:marvel_app/network/errors_handlers.dart';
import 'package:marvel_app/network/exceptions/base_exception.dart';

/// Clase abstracta para la fuente de datos remota base.
abstract class BaseRemoteSource {
  /// Obtiene el cliente Dio.
  Dio get dioClient => DioProvider.instance;

  /// Llama a una API con un analizador de errores.
  Future<Response<T>> callApiWithErrorParser<T>(Future<Response<T>> api) async {
    try {
      Response<T> response = await api;

      if (response.statusCode != HttpStatus.ok ||
          (response.data as Map<String, dynamic>)['statusCode'] != HttpStatus.ok) {}

      return response;
    } on DioError catch (dioError) {
      Exception exception = handleDioError(dioError);
      debugPrint("Throwing error from repository: >>>>>>> $exception : ${(exception as BaseException).message}");
      throw exception;
    } catch (error) {
      debugPrint("Generic error: >>>>>>> $error");

      if (error is BaseException) {
        rethrow;
      }

      throw handleError("$error");
    }
  }
}
