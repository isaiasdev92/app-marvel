class CharactersListUiModel {
  CharactersListUiModel({
    this.offset,
    this.limit,
    this.total,
    this.count,
    this.results,
  });

  final int? offset;
  final int? limit;
  final int? total;
  final int? count;
  final List<ItemListUiModel>? results;
}

class ItemListUiModel {
  ItemListUiModel({
    this.id = 0,
    this.name = "",
    this.description = "",
    this.thumbnailUrl = "",
  });

  final int id;
  final String name;
  final String description;
  final String thumbnailUrl;
}
