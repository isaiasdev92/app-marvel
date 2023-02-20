class CharacterDetailsModel {
  CharacterDetailsModel({this.id = 0, this.name = "", this.description = "", this.thumbnailUrl = "", this.modified});

  final int id;
  final String name;
  final String description;
  final String thumbnailUrl;
  final DateTime? modified;
}
