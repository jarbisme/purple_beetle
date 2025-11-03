import 'package:flutter/material.dart';
import 'package:purple_beetle/core/theme/theme_util.dart';

class Keypad extends StatelessWidget {
  const Keypad({super.key});

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(8.0),
      // color: Theme.of(context).colorScheme.background,
      child: SafeArea(
        top: false,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        _buildButton('AC', flex: 2, backgroundColor: AppTheme.secondaryColor.withValues(alpha: 0.1)),
                        _buildButton('-/+', color: AppTheme.secondaryColor),
                      ],
                    ),
                    Row(
                      children: [
                        _buildButton('(', color: AppTheme.secondaryColor),
                        _buildButton(')', color: AppTheme.secondaryColor),
                        _buildButton('%', color: AppTheme.secondaryColor),
                      ],
                    ),
                    Row(children: [_buildButton('7'), _buildButton('8'), _buildButton('9')]),
                    Row(children: [_buildButton('4'), _buildButton('5'), _buildButton('6')]),
                    Row(children: [_buildButton('1'), _buildButton('2'), _buildButton('3')]),
                    Row(
                      children: [
                        _buildButton('fn', backgroundColor: AppTheme.secondaryColor.withValues(alpha: 0.1)),
                        _buildButton('0'),
                        _buildButton('.'),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  margin: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    color: AppTheme.secondaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildButton('<', padding: const EdgeInsets.all(0)),
                      const SizedBox(height: 8),
                      _buildButton('/', padding: const EdgeInsets.all(0)),
                      const SizedBox(height: 8),
                      _buildButton('x', padding: const EdgeInsets.all(0)),
                      const SizedBox(height: 8),
                      _buildButton('-', padding: const EdgeInsets.all(0)),
                      const SizedBox(height: 8),
                      _buildButton('+', padding: const EdgeInsets.all(0)),
                      const SizedBox(height: 8),
                      _buildButton(
                        '=',
                        padding: const EdgeInsets.all(0),
                        color: Colors.white,
                        backgroundColor: AppTheme.primaryColor,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(String text, {int flex = 1, EdgeInsets? padding, Color? color, Color? backgroundColor}) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: padding ?? const EdgeInsets.all(4.0),
        // The button's style and radius are now set by the theme
        child: SizedBox(
          height: 55,
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: backgroundColor ?? Colors.transparent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.borderRadius)),
            ),
            onPressed: () {},
            child: Text(text, style: TextStyle(color: color ?? AppTheme.primaryColor)),
          ),
        ),
      ),
    );
  }
}
