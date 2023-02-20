import 'package:flutter/material.dart';
import 'package:marvel_app/core/values/app_colors.dart';
import 'package:marvel_app/core/values/app_values.dart';
import 'package:marvel_app/core/widgets/elevated_container_widget.dart';

/// Widget que muestra un indicador de carga (circular) centrado en la pantalla, dentro de un contenedor elevado con borde y fondo de color por defecto.
///
/// Puede personalizarse el tamaño del padding, el color del indicador de carga y el color del borde del contenedor.
class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: ElevatedContainerWidget(
        padding: EdgeInsets.all(AppValues.margin),
        child: CircularProgressIndicator(
          color: AppColors.colorPrimary,
        ),
      ),
    );
  }
}
