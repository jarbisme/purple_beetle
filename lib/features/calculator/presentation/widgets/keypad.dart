import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:purple_beetle/core/theme/theme_util.dart';
import 'package:purple_beetle/features/calculator/domain/entities/expression.dart';
import 'package:purple_beetle/features/calculator/presentation/bloc/calculator_bloc.dart';
import 'package:purple_beetle/features/calculator/presentation/bloc/calculator_event.dart';
import 'package:purple_beetle/features/calculator/presentation/widgets/keypad_button.dart';

class Keypad extends StatelessWidget {
  const Keypad({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                        TextKeypadButton(
                          number: 'AC',
                          flex: 2,
                          backgroundColor: theme.colorScheme.secondary.withValues(alpha: 0.1),
                          onPressed: () {
                            // Handle clear expression action
                            context.read<CalculatorBloc>().add(ClearExpressionEvent());
                          },
                        ),
                        TextKeypadButton(number: '-/+', color: theme.colorScheme.secondary),
                      ],
                    ),
                    Row(
                      children: [
                        TextKeypadButton(
                          number: '(',
                          color: theme.colorScheme.secondary,
                          token: ParenthesisToken(('(')),
                        ),
                        TextKeypadButton(
                          number: ')',
                          color: theme.colorScheme.secondary,
                          token: ParenthesisToken((')')),
                        ),
                        IconKeypadButton(
                          icon: Icon(
                            LucideIcons.percent,
                            color: theme.colorScheme.secondary,
                            size: theme.iconTheme.size,
                          ),
                          token: OperatorToken(('%')),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        TextKeypadButton(number: '7', token: DigitToken(7)),
                        TextKeypadButton(number: '8', token: DigitToken(8)),
                        TextKeypadButton(number: '9', token: DigitToken(9)),
                      ],
                    ),
                    Row(
                      children: [
                        TextKeypadButton(number: '4', token: DigitToken(4)),
                        TextKeypadButton(number: '5', token: DigitToken(5)),
                        TextKeypadButton(number: '6', token: DigitToken(6)),
                      ],
                    ),
                    Row(
                      children: [
                        TextKeypadButton(number: '1', token: DigitToken(1)),
                        TextKeypadButton(number: '2', token: DigitToken(2)),
                        TextKeypadButton(number: '3', token: DigitToken(3)),
                      ],
                    ),
                    Row(
                      children: [
                        TextKeypadButton(
                          number: 'fn',
                          backgroundColor: theme.colorScheme.secondary.withValues(alpha: 0.1),
                        ),
                        TextKeypadButton(number: '0', token: DigitToken(0)),
                        TextKeypadButton(number: '.', token: DecimalPointToken()),
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
                    color: theme.colorScheme.secondary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      IconKeypadButton(
                        icon: Icon(LucideIcons.delete, color: theme.iconTheme.color, size: theme.iconTheme.size),
                        padding: const EdgeInsets.all(0),
                        onPressed: () {
                          // Handle backspace action
                          context.read<CalculatorBloc>().add(BackspaceEvent());
                        },
                      ),
                      const SizedBox(height: 8),
                      IconKeypadButton(
                        icon: Icon(LucideIcons.divide, color: theme.iconTheme.color, size: theme.iconTheme.size),
                        padding: const EdgeInsets.all(0),
                        token: OperatorToken(('/')),
                      ),
                      const SizedBox(height: 8),
                      IconKeypadButton(
                        icon: Icon(LucideIcons.x, color: theme.iconTheme.color, size: theme.iconTheme.size),
                        padding: const EdgeInsets.all(0),
                        token: OperatorToken(('*')),
                      ),
                      const SizedBox(height: 8),
                      IconKeypadButton(
                        icon: Icon(LucideIcons.minus, color: theme.iconTheme.color, size: theme.iconTheme.size),
                        padding: const EdgeInsets.all(0),
                        token: OperatorToken(('-')),
                      ),
                      const SizedBox(height: 8),
                      IconKeypadButton(
                        icon: Icon(LucideIcons.plus, color: theme.iconTheme.color, size: theme.iconTheme.size),
                        padding: const EdgeInsets.all(0),
                        token: OperatorToken(('+')),
                      ),
                      const SizedBox(height: 8),
                      TextKeypadButton(
                        number: '=',
                        padding: const EdgeInsets.all(0),
                        color: Colors.white,
                        backgroundColor: theme.colorScheme.primary,
                        onPressed: () {
                          context.read<CalculatorBloc>().add(EvaluateEvent());
                        },
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

  // Widget _buildButton(
  //   String text, {
  //   // ExpressionToken token,
  //   int flex = 1,
  //   EdgeInsets? padding,
  //   Color? color,
  //   Color? backgroundColor,
  // }) {
  //   return KeypadButton(child: ,);
  // }
}
