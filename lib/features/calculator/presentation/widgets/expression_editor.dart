import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:purple_beetle/features/calculator/domain/entities/expression.dart';
import 'package:purple_beetle/features/calculator/presentation/bloc/calculator_bloc.dart';
import 'package:purple_beetle/features/calculator/presentation/bloc/calculator_event.dart';
import 'package:purple_beetle/features/calculator/presentation/bloc/calculator_state.dart';
import 'package:purple_beetle/features/calculator/presentation/widgets/blinking_cursor.dart';
import 'package:purple_beetle/features/variables/domain/entities/variable.dart';
import 'package:purple_beetle/features/variables/presentation/bloc/variables_bloc.dart';
import 'package:purple_beetle/features/variables/presentation/bloc/variables_state.dart';

/// Widget to visualize and edit the current expression with tokens and cursor
class ExpressionEditor extends StatelessWidget {
  const ExpressionEditor({super.key});

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
                        context.read<CalculatorBloc>().add(MoveCursorEvent(newPosition));
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

// Helper to build the widget for each token type
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
  } else if (token is VariableToken) {
    // Fetch variable details from VariablesBloc
    tokenWidget = BlocBuilder<VariablesBloc, VariablesState>(
      builder: (context, variablesState) {
        final variable = variablesState.variables.firstWhere(
          (varItem) => varItem.id == token.variableId,
          orElse: () => Variable(id: token.variableId, name: 'unknown', value: 0, color: Colors.grey.toARGB32()),
        );

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 3.0),
          decoration: BoxDecoration(
            color: Color(variable.color).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(7.0),
          ),
          child: Text(variable.name, style: theme.textTheme.bodyLarge?.copyWith(color: Color(variable.color))),
        );
      },
    );
  } else {
    tokenWidget = const SizedBox.shrink();
  }
  return tokenWidget;
}
