import 'package:flutter/material.dart';
import 'package:marvel_app/core/values/app_colors.dart';

import '../values/app_values.dart';

/// Un widget que envuelve el [child] con una [InkWell] para producir un efecto de ondulación cuando se toca el widget.
class RippleWidget extends StatelessWidget {
  final Function()? onTap;
  final Widget? child;
  final Color rippleColor;
  final double rippleRadius;

  const RippleWidget({
    Key? key,
    this.child,
    required this.onTap,
    this.rippleColor = AppColors.defaultRippleColor,
    this.rippleRadius = AppValues.smallRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(rippleRadius),
        highlightColor: rippleColor,
        onTap: onTap,
        child: child,
      ),
    );
  }
}
