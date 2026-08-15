import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

class VistoneMark extends StatelessWidget {
  final double size;
  final bool inverted;

  const VistoneMark({super.key, this.size = 44, this.inverted = false});

  @override
  Widget build(BuildContext context) {
    final base = inverted ? AppColors.textInverse : AppColors.forest;
    final foreground = inverted ? AppColors.forestDeep : AppColors.textInverse;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: base,
        borderRadius: BorderRadius.circular(size * .34),
        boxShadow: inverted
            ? null
            : [
                BoxShadow(
                  color: AppColors.forest.withValues(alpha: .2),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ],
      ),
      child: Text(
        'V',
        style: GoogleFonts.dmSerifDisplay(
          fontSize: size * .62,
          height: .9,
          color: foreground,
        ),
      ),
    );
  }
}
