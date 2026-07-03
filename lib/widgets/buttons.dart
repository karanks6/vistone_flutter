import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'design_system.dart';

enum AppButtonVariant { filled, tonal, outlined, text }

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

class _AppButtonState extends State<AppButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      reverseDuration: const Duration(milliseconds: 150),
    );
    // Base scale is 1.0. Hover: 1.01. Pressed: 0.98.
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
      _controller.forward();
      HapticFeedback.lightImpact();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
      _controller.reverse();
    }
  }

  void _handleTapCancel() {
    if (widget.onPressed != null && !widget.isLoading) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isDisabled = widget.onPressed == null || widget.isLoading;

    Color bg;
    Color fg;
    BorderSide? border;

    switch (widget.variant) {
      case AppButtonVariant.filled:
        bg = theme.colorScheme.primary;
        fg = isDark ? AppColors.bgDark : Colors.white;
        break;
      case AppButtonVariant.tonal:
        bg = isDark ? AppColors.surfaceDark : AppColors.gray100;
        fg = theme.colorScheme.primary;
        break;
      case AppButtonVariant.outlined:
        bg = Colors.transparent;
        fg = theme.textTheme.bodyLarge?.color ?? AppColors.gray900;
        border = BorderSide(color: isDark ? AppColors.gray700 : AppColors.gray300);
        break;
      case AppButtonVariant.text:
        bg = Colors.transparent;
        fg = theme.colorScheme.primary;
        break;
    }

    if (isDisabled) {
      bg = widget.variant == AppButtonVariant.outlined || widget.variant == AppButtonVariant.text
          ? Colors.transparent
          : (isDark ? AppColors.gray800 : AppColors.gray200);
      fg = isDark ? AppColors.gray600 : AppColors.gray400;
      border = widget.variant == AppButtonVariant.outlined
          ? BorderSide(color: isDark ? AppColors.gray800 : AppColors.gray200)
          : null;
    }

    Widget child = Row(
      mainAxisSize: widget.isExpanded ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.isLoading) ...[
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(fg),
            ),
          ),
          const SizedBox(width: AppSpacing.s8),
        ] else if (widget.icon != null) ...[
          Icon(widget.icon, size: 20, color: fg),
          const SizedBox(width: AppSpacing.s8),
        ],
        Text(
          widget.label,
          style: theme.textTheme.labelLarge?.copyWith(color: fg),
        ),
      ],
    );

    Widget buttonNode = MouseRegion(
      onEnter: (_) {
        if (!isDisabled) setState(() => _isHovered = true);
      },
      onExit: (_) {
        if (!isDisabled) setState(() => _isHovered = false);
      },
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: widget.isLoading ? null : widget.onPressed,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          padding: AppSpacing.buttonPadding,
          decoration: BoxDecoration(
            color: _isHovered && widget.variant == AppButtonVariant.text
                ? fg.withValues(alpha: 0.08)
                : bg,
            borderRadius: AppShapes.button,
            border: border != null ? Border.fromBorderSide(border) : null,
            boxShadow: _isHovered && widget.variant == AppButtonVariant.filled && !isDisabled
                ? AppElevations.level1(isDark)
                : null,
          ),
          child: child,
        ),
      ),
    );

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        // Apply hover scale if not pressed, pressed scale if pressed.
        double scale = _scaleAnimation.value;
        if (scale == 1.0 && _isHovered && !isDisabled) {
          scale = 1.01;
        }
        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
      child: buttonNode,
    );
  }
}
