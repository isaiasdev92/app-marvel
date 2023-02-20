import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marvel_app/core/base/base_view.dart';
import 'package:marvel_app/core/values/app_assets.dart';
import 'package:marvel_app/core/values/app_colors.dart';
import 'package:marvel_app/core/values/app_values.dart';
import 'package:marvel_app/core/widgets/custom_app_bar.dart';
import 'package:marvel_app/modules/character_details/controllers/character_details_controller.dart';

/// Clase que define la vista de la pantalla de detalles de un personaje, hereda de [BaseView] que se encarga de gestionar el controlador.
/// La vista contiene un [CustomAppBar] personalizado y un [Scaffold] que muestra el cuerpo de la pantalla.
/// El cuerpo contiene una vista desplazable con una columna que contiene los siguientes elementos:
/// - Texto "Marvel".
/// - Imagen cargada a través de [FadeInImage] con la imagen en miniatura del personaje y un mensaje de error en caso de que la imagen no se cargue.
/// - Nombre del personaje centrado en la pantalla.
/// - Fecha de última actualización del personaje.
/// - Descripción del personaje.
class CharacterDetailsView extends BaseView<CharacterDetailsController> {
  CharacterDetailsView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return CustomAppBar(
      appBarTitleText: 'Detalles del personaje',
      isBackButtonEnabled: true,
    );
  }

  @override
  Widget body(BuildContext context) {
    return Scaffold(body: Obx(() => _getView()));
  }

  /// Método privado que devuelve la vista desplazable con una columna que contiene los siguientes elementos:
  /// - Texto "Marvel".
  /// - Imagen cargada a través de [FadeInImage] con la imagen en miniatura del personaje y un mensaje de error en caso de que la imagen no se cargue.
  /// - Nombre del personaje centrado en la pantalla.
  /// - Fecha de última actualización del personaje.
  /// - Descripción del personaje.
  Widget _getView() {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.all(AppValues.margin_20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Marvel",
              style:
                  TextStyle(fontSize: 20, fontWeight: FontWeight.w500, height: 1.2, color: AppColors.textColorPrimary),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            const SizedBox(height: AppValues.margin_20),
            _loadImage(),
            const SizedBox(height: AppValues.margin_4),
            _getAvatarInfo(),
            const SizedBox(height: AppValues.margin_4),
            _setModified(),
            const SizedBox(height: AppValues.margin_20),
            _getDescription()
          ],
        ),
      ),
    );
  }

  /// Método privado que devuelve un [Text] con la fecha de última actualización del personaje.
  Widget _setModified() {
    return Text(
      "Última actualización: ${controller.characterDetailsUiData.modified.toString()}",
      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400, height: 1.2, color: AppColors.textColorCyan),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  /// Método privado que devuelve la imagen cargada a través de [FadeInImage] con la imagen en miniatura del personaje.
  Center _loadImage() {
    return Center(
      child: FadeInImage(
        width: 300,
        height: 300,
        placeholder: const AssetImage(AppAssets.noImage),
        imageErrorBuilder: (context, error, stackTrace) {
          return Image.asset(AppAssets.noImage);
        },
        image: NetworkImage(controller.characterDetailsUiData.thumbnailUrl),
      ),
    );
  }

  /// Retorna un widget con el nombre del personaje.
  Widget _getAvatarInfo() {
    return Center(
      child: Text(
        controller.characterDetailsUiData.name,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, height: 1.2, color: AppColors.textColorCyan),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  /// Retorna un widget con la descripción del personaje.
  Widget _getDescription() {
    return Text(controller.characterDetailsUiData.description,
        style: const TextStyle(
          fontSize: 16,
        ));
  }
}
