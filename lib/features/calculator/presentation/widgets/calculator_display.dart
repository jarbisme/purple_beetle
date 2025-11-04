import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:purple_beetle/core/theme/theme_util.dart';
import 'package:purple_beetle/features/calculator/domain/entities/expression.dart';
import 'package:purple_beetle/features/calculator/presentation/bloc/calculator_bloc.dart';
import 'package:purple_beetle/features/calculator/presentation/bloc/calculator_state.dart';

class CalculatorDisplay extends StatelessWidget {
  const CalculatorDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<CalculatorBloc, CalculatorState>(
      builder: (context, state) {
        return Expanded(
          child: Container(
            alignment: Alignment.bottomRight,
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IntrinsicWidth(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Opacity(opacity: 0.3, child: Text('= ', style: theme.textTheme.displayLarge)),
                          const SizedBox(height: 3.5),
                        ],
                      ),
                    ),
                    IntrinsicWidth(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('76,512', style: theme.textTheme.displayLarge),
                          Container(
                            height: 3.5,
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // Expression display area
                SizedBox(
                  height: 40,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.expression.tokens.length,
                      scrollDirection: Axis.horizontal,
                      // reverse: true,
                      itemBuilder: (context, index) {
                        final token = state.expression.tokens[index];
                        Widget? tokenWidget;
                        if (token is DigitToken) {
                          tokenWidget = Text(token.value.toString(), style: theme.textTheme.headlineMedium);
                        } else if (token is OperatorToken) {
                          if (token.operator == '*') {
                            tokenWidget = const Icon(LucideIcons.x, size: 20);
                          } else if (token.operator == '/') {
                            tokenWidget = const Icon(LucideIcons.divide, size: 20);
                          } else if (token.operator == '%') {
                            tokenWidget = const Icon(LucideIcons.percent, size: 20);
                          } else if (token.operator == '+') {
                            tokenWidget = const Icon(LucideIcons.plus, size: 20);
                          } else if (token.operator == '-') {
                            tokenWidget = const Icon(LucideIcons.minus, size: 20);
                          } else {
                            tokenWidget = const SizedBox.shrink();
                          }
                          // add padding around operators
                          tokenWidget = Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: tokenWidget,
                          );
                        } else if (token is ParenthesisToken) {
                          // add padding around parentheses
                          tokenWidget = Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Transform.translate(
                              offset: const Offset(0, -3.0), // Nudge the parenthesis up
                              child: Text(
                                token.parenthesis,
                                style: theme.textTheme.headlineMedium?.copyWith(color: AppTheme.primaryColor),
                              ),
                            ),
                          );
                        } else if (token is DecimalPointToken) {
                          tokenWidget = Text('.', style: theme.textTheme.headlineMedium);
                        } else {
                          tokenWidget = const SizedBox.shrink();
                        }
                        return Center(child: tokenWidget);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
