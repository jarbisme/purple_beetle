import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:purple_beetle/features/calculator/presentation/bloc/calculator_bloc.dart';
import 'package:purple_beetle/features/calculator/presentation/bloc/calculator_state.dart';
import 'package:purple_beetle/features/calculator/presentation/widgets/expression_editor.dart';

/// Widget to display the current result and expression in the calculator
class CalculatorDisplay extends StatelessWidget {
  const CalculatorDisplay({super.key});

  // Format the result with commas and limit digits
  String _formatResult(String? result) {
    if (result == null || result.isEmpty) return '0';

    try {
      final number = double.parse(result);

      // Limit to 12 significant digits for display
      final formatter = NumberFormat('#,##0.##########', 'en_US');
      String formatted = formatter.format(number);

      // Ensure max length (including commas)
      if (formatted.length > 15) {
        // Switch to scientific notation for very large/small numbers
        return number.toStringAsExponential(6);
      }

      return formatted;
    } catch (e) {
      return result; // Return original if parsing fails
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<CalculatorBloc, CalculatorState>(
      builder: (context, state) {
        return Expanded(
          child: Container(
            alignment: Alignment.bottomRight,
            // padding: const EdgeInsets.only(right: 16.0, left: 16.0, top: 12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: Row(
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
                      Flexible(
                        child: IntrinsicWidth(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerRight,
                                child: Text(
                                  _formatResult(state.result),
                                  style: state.error != null
                                      ? theme.textTheme.displayLarge?.copyWith(
                                          color: theme.colorScheme.primary.withValues(alpha: 0.7),
                                        )
                                      : theme.textTheme.displayLarge?.copyWith(
                                          // fontWeight: FontWeight.normal,
                                          // color: theme.colorScheme.secondary,
                                        ),
                                ),
                              ),
                              Container(
                                height: 3.5,
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Expression display area
                ExpressionEditor(),
              ],
            ),
          ),
        );
      },
    );
  }
}
