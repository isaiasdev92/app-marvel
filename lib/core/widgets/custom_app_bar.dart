import 'package:flutter/material.dart';
import 'package:marvel_app/core/values/app_colors.dart';
import 'app_bar_title.dart';

/// Esta clase representa una AppBar personalizada que contiene un título, acciones opcionales y un botón de retroceso opcional.
/// Implementa el PreferredSizeWidget para que se pueda utilizar como el tamaño preferido de la AppBar del Scaffold.
class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  final String appBarTitleText;
  final List<Widget>? actions;
  final bool isBackButtonEnabled;

  CustomAppBar({
    Key? key,
    required this.appBarTitleText,
    this.actions,
    this.isBackButtonEnabled = true,
  }) : super(key: key);

  @override
  Size get preferredSize => AppBar().preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      elevation: 0,
      automaticallyImplyLeading: isBackButtonEnabled,
      actions: actions,
      iconTheme: const IconThemeData(color: AppColors.pageBackground),
      title: AppBarTitle(text: appBarTitleText),
    );
  }
}
