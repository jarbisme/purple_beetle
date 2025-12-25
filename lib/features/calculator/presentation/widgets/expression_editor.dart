import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purple_beetle/features/calculator/presentation/bloc/calculator_bloc.dart';
import 'package:purple_beetle/features/calculator/presentation/bloc/calculator_state.dart';
import 'package:purple_beetle/features/calculator/presentation/widgets/blinking_cursor.dart';
import 'package:purple_beetle/features/calculator/presentation/widgets/expression_token_item.dart';

/// Widget to visualize and edit the current expression with tokens and cursor
class ExpressionEditor extends StatelessWidget {
  const ExpressionEditor({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalculatorBloc, CalculatorState>(
      builder: (context, state) {
        return SizedBox(
          height: 40,
          child: Align(
            alignment: Alignment.centerRight,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: state.expression.tokens.isEmpty ? 1 : state.expression.tokens.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                // Case 1: the expression is empty, just draw the cursor
                if (state.expression.tokens.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 3, bottom: 3, right: 4),
                    child: const BlinkingCursor(),
                  );
                }

                // Case 2: We are building a token widget
                final token = state.expression.tokens[index];
                final CursorPosition cursorPosition = _getCursorPosition(index, state.cursorIndex);
                final isFirst = index == 0;
                final isLast = index == state.expression.tokens.length - 1;

                return ExpressionTokenItem(
                  token: token,
                  tokenIndex: index,
                  cursorPosition: cursorPosition,
                  isFirst: isFirst,
                  isLast: isLast,
                );
              },
            ),
          ),
        );
      },
    );
  }

  CursorPosition _getCursorPosition(int tokenIndex, int cursorIndex) {
    if (tokenIndex == 0 && cursorIndex == 0) {
      return CursorPosition.before;
    } else if (cursorIndex == tokenIndex + 1) {
      return CursorPosition.after;
    } else {
      return CursorPosition.none;
    }
  }
}
