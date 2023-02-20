import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marvel_app/core/values/app_assets.dart';
import 'package:marvel_app/core/values/app_colors.dart';
import 'package:marvel_app/core/values/app_values.dart';
import 'package:marvel_app/core/widgets/elevated_container_widget.dart';
import 'package:marvel_app/core/widgets/ripple_widget.dart';
import 'package:marvel_app/modules/home/models/characters_list_ui_model.dart';
import 'package:marvel_app/routes/app_routes.dart';

///Clase ItemCharacter es un widget que se utiliza para mostrar información de un personaje en la lista de personajes.
class ItemCharacter extends StatelessWidget {
  final ItemListUiModel dataModel;

  const ItemCharacter({
    Key? key,
    required this.dataModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedContainerWidget(
      child: RippleWidget(
        onTap: _onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppValues.padding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundImage: const AssetImage(AppAssets.noImage),
                foregroundImage: NetworkImage(dataModel.thumbnailUrl),
                radius: AppValues.circularImageSize_40,
                onBackgroundImageError: (object, stack) => Image.asset(
                  AppAssets.noImage,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: AppValues.margin_10),
              _getDetailsView(),
            ],
          ),
        ),
      ),
    );
  }

  ///función auxiliar que devuelve la vista con los detalles del personaje.
  Widget _getDetailsView() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            dataModel.name,
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.w500, height: 1.2, color: AppColors.textColorPrimary),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          const SizedBox(height: AppValues.margin_4),
          Text(
            dataModel.description,
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.w500, height: 1.2, color: AppColors.textColorGreyLight),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppValues.margin_4),
        ],
      ),
    );
  }

  ///función que se ejecuta cuando se toca el widget ItemCharacter. Lleva al usuario a la pantalla de detalles del personaje.
  void _onTap() {
    Get.toNamed(RoutesApp.characterDetails, arguments: dataModel);
  }
}
