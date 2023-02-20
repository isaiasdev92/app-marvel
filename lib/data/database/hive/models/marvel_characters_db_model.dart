import 'package:marvel_app/data/database/db_provider.dart';

part 'marvel_characters_db_model.g.dart';

/// Un widget que envuelve el [child] con una [InkWell] para producir un efecto de ondulación cuando se toca el widget.
@HiveType(typeId: 1)
class MarvelCharacterDbModel extends HiveObject {
  static String tableName = 'Character';
  static String tableNameTest = 'CharacterTest';
  static String columnId = 'Id';
  static String columnName = 'Name';
  static String columnDescription = 'Description';
  static String columnModified = 'Modified';
  static String columnThumbnailUrl = 'ThumbnailUrl';

  @HiveField(0)
  int id;
  @HiveField(1)
  String name;
  @HiveField(2)
  String description;
  @HiveField(3)
  String modified;
  @HiveField(4)
  String thumbnailUrl;

  /// Constructor de la clase MarvelCharacterDbModel.
  ///
  /// El parámetro `id` es requerido, mientras que los otros parámetros son opcionales y tienen valores predeterminados en forma de cadena vacía.
  MarvelCharacterDbModel(
      {required this.id, this.name = "", this.description = "", this.modified = "", this.thumbnailUrl = ""});

  /// Crea una instancia de MarvelCharacterDbModel a partir de un mapa JSON.
  factory MarvelCharacterDbModel.fromJson(Map<String, dynamic> json) => MarvelCharacterDbModel(
        id: json[columnId],
        name: json[columnName],
        description: json[columnDescription],
        modified: json[columnModified],
        thumbnailUrl: json[columnThumbnailUrl],
      );

  /// Convierte esta instancia de MarvelCharacterDbModel en un mapa JSON.
  Map<String, dynamic> toJson() => {
        columnId: id,
        columnName: name,
        columnDescription: description,
        columnModified: modified,
        columnThumbnailUrl: thumbnailUrl
      };
}
