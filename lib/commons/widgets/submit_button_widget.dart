import 'package:bloc_chatapp/commons/export_commons.dart';
import 'package:flutter/material.dart';
import 'package:mesh_gradient/mesh_gradient.dart';

class SubmitButton extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;
  final double width;
  final double height;
  final List<Color> colors;

  const SubmitButton({
    super.key,
    required this.onTap,
    required this.child,
    this.width = double.infinity,
    this.height = AppStyles.heightXLarge,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 0.5),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      clipBehavior: Clip.hardEdge,
      child: AnimatedMeshGradient(
        colors: colors,
        options: AnimatedMeshGradientOptions(),
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          ),
          child: child,
        ),
      ),
    );
  }
}
