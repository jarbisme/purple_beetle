import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:purple_beetle/features/calculator/domain/entities/expression.dart';
import 'package:purple_beetle/features/calculator/presentation/bloc/calculator_bloc.dart';
import 'package:purple_beetle/features/calculator/presentation/bloc/calculator_event.dart';
import 'package:purple_beetle/features/calculator/presentation/bloc/calculator_state.dart';
import 'package:purple_beetle/features/calculator/presentation/widgets/blinking_cursor.dart';

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
                          Text(
                            state.result ?? '0',
                            style: state.error != null
                                ? theme.textTheme.displayLarge?.copyWith(
                                    color: theme.colorScheme.primary.withValues(alpha: 0.7),
                                  )
                                : theme.textTheme.displayLarge,
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
                  ],
                ),
                // Expression display area
                ExpressionVisualizer(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ExpressionVisualizer extends StatelessWidget {
  const ExpressionVisualizer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<CalculatorBloc, CalculatorState>(
      builder: (context, state) {
        return SizedBox(
          height: 40,
          child: Align(
            alignment: Alignment.centerRight,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: state.expression.tokens.length + 1,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                // Case 1: The cursor is at the end of the expression, just draw it
                if (index == state.expression.tokens.length) {
                  return state.cursorIndex == index
                      ? Padding(padding: const EdgeInsets.symmetric(vertical: 3.0), child: const BlinkingCursor())
                      : const SizedBox(width: 2);
                }

                // Case 2: We are building a token widget
                final token = state.expression.tokens[index];
                final tokenWidget = _buildTokenWidget(token, theme);

                Widget finalWidget = Center(child: tokenWidget);

                // If the cursor is before this token, wrap it in a Stack
                if (index == state.cursorIndex) {
                  finalWidget = Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      tokenWidget,
                      const Positioned(left: -2, child: BlinkingCursor()),
                    ],
                  );
                }

                // The Builder must be the parent to provide the correct context to the GestureDetector.
                return Builder(
                  builder: (context) {
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTapUp: (details) {
                        // This context is now correct because the GestureDetector is inside the Builder.
                        final RenderBox box = context.findRenderObject() as RenderBox;
                        final localDx = box.globalToLocal(details.globalPosition).dx;

                        // Decide position based on tap location
                        final newPosition = (localDx < box.size.width / 2) ? index : index + 1;
                        context.read<CalculatorBloc>().add(MoveCursor(newPosition));
                      },
                      child: finalWidget,
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}

Widget _buildTokenWidget(ExpressionToken token, ThemeData theme) {
  Widget? tokenWidget;
  if (token is DigitToken) {
    tokenWidget = Transform.translate(
      offset: const Offset(0, 1.0),
      child: Text(token.value.toString(), style: theme.textTheme.headlineMedium),
    );
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
      child: Transform.translate(offset: const Offset(0, 0), child: tokenWidget),
    );
  } else if (token is ParenthesisToken) {
    // add padding around parentheses
    tokenWidget = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Transform.translate(
        offset: const Offset(0, -1), // Nudge the parenthesis up
        child: Text(
          token.parenthesis,
          style: theme.textTheme.headlineMedium?.copyWith(color: theme.colorScheme.primary),
        ),
      ),
    );
  } else if (token is DecimalPointToken) {
    tokenWidget = Text('.', style: theme.textTheme.headlineMedium);
  } else {
    tokenWidget = const SizedBox.shrink();
  }
  return tokenWidget;
}
