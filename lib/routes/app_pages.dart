import 'package:marvel_app/modules/home/views/list_characters_view.dart';
import 'package:marvel_app/routes/app_routes.dart';

import 'package:get/get.dart';

import '../modules/character_details/bindings/character_details_binding.dart';
import '../modules/character_details/views/character_details_view.dart';
import '../modules/home/bindings/main_binding.dart';

class AppPages {
  static const initial = RoutesApp.main;

  static final routes = [
    GetPage(
      name: RoutesApp.main,
      page: () => ListCharactersView(),
      binding: MainBinding(),
    ),
    GetPage(
      name: RoutesApp.characterDetails,
      page: () => CharacterDetailsView(),
      binding: CharacterDetailsBinding(),
    ),
  ];
}
