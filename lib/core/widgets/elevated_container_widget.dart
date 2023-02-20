import 'package:flutter/material.dart';
import 'package:marvel_app/core/values/app_colors.dart';
import 'package:marvel_app/core/values/app_values.dart';

/// Un widget que representa un contenedor elevado con bordes redondeados y un color de fondo personalizado.
///
/// Puede ajustar el color de fondo, el relleno, el radio de los bordes y el widget hijo.
///
class ElevatedContainerWidget extends StatelessWidget {
  final Widget child;
  final Color bgColor;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;

  const ElevatedContainerWidget({
    Key? key,
    required this.child,
    this.bgColor = AppColors.pageBackground,
    this.padding,
    this.borderRadius = AppValues.smallRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: AppColors.elevatedContainerColorOpacity,
            width: 0.5,
          ),
          color: AppColors.pageBackground),
      child: child,
    );
  }
}
