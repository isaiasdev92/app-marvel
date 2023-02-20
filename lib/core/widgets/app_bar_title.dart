import 'package:flutter/material.dart';

import '../values/app_colors.dart';

/// Widget que muestra un título en la barra de la aplicación.
///
/// Recibe un parámetro de tipo String que representa el texto que se mostrará como título.
///
/// Retorna un widget Text con el estilo personalizado para la barra de la aplicación.
class AppBarTitle extends StatelessWidget {
  final String text;

  const AppBarTitle({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, height: 1.15, color: AppColors.appBarTextColor),
      textAlign: TextAlign.center,
    );
  }
}
