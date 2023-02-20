import 'package:marvel_app/core/values/app_values.dart';

/// Configuración de URL y parámetros para servicios web
class ServicesUrlSettings {
  String url; // URL base para el servicio
  String apiKey; // API key para autenticación
  String timestamp; // Marca de tiempo para autenticación
  String hashValue; // Valor de hash para autenticación
  int perPage; // Número de resultados por página
  int pageNumber; // Número de página

  ServicesUrlSettings({
    required this.url,
    required this.apiKey,
    required this.timestamp,
    required this.hashValue,
    this.perPage = AppValues.defaultPageSize,
    this.pageNumber = AppValues.defaultPageNumber,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['apikey'] = apiKey;
    data['ts'] = timestamp;
    data['hash'] = hashValue;

    data['limit'] = perPage;
    data['offset'] = pageNumber;

    return data;
  }
}
