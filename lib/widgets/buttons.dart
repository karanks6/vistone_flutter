import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_radii.dart';
import '../core/theme/app_shadows.dart';

enum AppButtonVariant { filled, tonal, outlined, text }

/// Flexible button retained for secondary actions. The main flow uses
/// [AppPrimaryButton], while this gives settings and small controls a coherent
/// visual treatment.
class AppButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? icon;
  final bool isLoading;
  final bool isExpanded;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.filled,
    this.icon,
    this.isLoading = false,
    this.isExpanded = false,
  });

  const AppButton.tonal({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isExpanded = false,
  }) : variant = AppButtonVariant.tonal;

  const AppButton.outlined({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isExpanded = false,
  }) : variant = AppButtonVariant.outlined;

  const AppButton.text({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isExpanded = false,
  }) : variant = AppButtonVariant.text;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final disabled = widget.onPressed == null || widget.isLoading;
    final Color foreground;
    final Color background;
    final BorderSide? border;

    switch (widget.variant) {
      case AppButtonVariant.filled:
        foreground = AppColors.textInverse;
        background = AppColors.forest;
        border = null;
      case AppButtonVariant.tonal:
        foreground = dark ? AppColors.sage : AppColors.forest;
        background = dark ? AppColors.nightSurfaceRaised : AppColors.surfaceSage;
        border = null;
      case AppButtonVariant.outlined:
        foreground = dark ? AppColors.nightText : AppColors.ink;
        background = Colors.transparent;
        border = BorderSide(color: dark ? AppColors.nightLine : AppColors.lineStrong);
      case AppButtonVariant.text:
        foreground = dark ? AppColors.sage : AppColors.forest;
        background = Colors.transparent;
        border = null;
    }

    return GestureDetector(
      onTapDown: disabled ? null : (_) => setState(() => _pressed = true),
      onTapCancel: disabled ? null : () => setState(() => _pressed = false),
      onTapUp: disabled
          ? null
          : (_) {
              setState(() => _pressed = false);
              widget.onPressed?.call();
            },
      child: AnimatedScale(
        scale: _pressed ? .97 : 1,
        duration: const Duration(milliseconds: 120),
        child: AnimatedOpacity(
          opacity: disabled ? .45 : 1,
          duration: const Duration(milliseconds: 150),
          child: Container(
            width: widget.isExpanded ? double.infinity : null,
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(AppRadii.pill),
              border: border == null ? null : Border.fromBorderSide(border),
              boxShadow: widget.variant == AppButtonVariant.filled && !disabled
                  ? AppShadows.card
                  : null,
            ),
            child: Row(
              mainAxisSize: widget.isExpanded ? MainAxisSize.max : MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.isLoading)
                  SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2, color: foreground),
                  )
                else if (widget.icon != null)
                  Icon(widget.icon, size: 18, color: foreground),
                if (widget.isLoading || widget.icon != null) const SizedBox(width: 8),
                Text(
                  widget.label,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(color: foreground),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
