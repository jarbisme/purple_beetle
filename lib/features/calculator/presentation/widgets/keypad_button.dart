import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purple_beetle/core/theme/theme_util.dart';
import 'package:purple_beetle/features/calculator/domain/entities/expression.dart';
import 'package:purple_beetle/features/calculator/presentation/bloc/calculator_bloc.dart';
import 'package:purple_beetle/features/calculator/presentation/bloc/calculator_event.dart';

/// Basic button widget for the calculator keypad
class KeypadButton extends StatelessWidget {
  const KeypadButton({
    super.key,
    required this.child,
    this.flex = 1,
    this.padding,
    this.color,
    this.backgroundColor,
    required this.onPressed,
  });

  final Widget child;
  final int flex;
  final EdgeInsets? padding;
  final Color? color;
  final Color? backgroundColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: padding ?? const EdgeInsets.all(4.0),
        child: SizedBox(
          height: 55,
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: backgroundColor ?? Colors.transparent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.borderRadius)),
            ),
            onPressed: onPressed,
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Text button for the calculator keypad that dispatches an event on press
class TextKeypadButton extends StatelessWidget {
  const TextKeypadButton({
    super.key,
    required this.number,
    this.token,
    this.color,
    this.backgroundColor,
    this.onPressed,
    this.flex = 1,
    this.padding,
  });

  final String number;
  final Color? color;
  final Color? backgroundColor;
  final ExpressionToken? token;
  final int flex;
  final EdgeInsets? padding;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return KeypadButton(
      flex: flex,
      padding: padding,
      backgroundColor: backgroundColor,
      onPressed: () {
        // if onPressed is provided, call it; otherwise, dispatch the event with the provided token
        if (onPressed != null) {
          onPressed!();
        } else if (token != null) {
          context.read<CalculatorBloc>().add(InsertToken(token!));
        }
      },
      child: Text(number, style: TextStyle(color: color ?? Theme.of(context).colorScheme.primary)),
    );
  }
}

/// Icon button for the calculator keypad that dispatches an event on press
class IconKeypadButton extends StatelessWidget {
  const IconKeypadButton({
    super.key,
    required this.icon,
    // this.color,
    this.backgroundColor,
    this.token,
    this.flex = 1,
    this.padding,
    this.onPressed,
  });

  final Icon icon;
  // final Color? color;
  final Color? backgroundColor;
  final ExpressionToken? token;
  final int flex;
  final EdgeInsets? padding;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    return KeypadButton(
      flex: flex,
      padding: padding,
      backgroundColor: backgroundColor,
      onPressed: () {
        // if onPressed is provided, call it; otherwise, dispatch the event with the provided token
        if (onPressed != null) {
          onPressed!();
        } else if (token != null) {
          context.read<CalculatorBloc>().add(InsertToken(token!));
        }
      },
      child: icon,
    );
  }
}
