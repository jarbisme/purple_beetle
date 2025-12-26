import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purple_beetle/features/calculator/presentation/bloc/calculator_bloc.dart';
import 'package:purple_beetle/features/calculator/presentation/bloc/calculator_state.dart';
import 'package:purple_beetle/features/calculator/presentation/widgets/blinking_cursor.dart';
import 'package:purple_beetle/features/calculator/presentation/widgets/expression_token_item.dart';

/// Widget to visualize and edit the current expression with tokens and cursor
class ExpressionEditor extends StatefulWidget {
  const ExpressionEditor({super.key});

  @override
  State<ExpressionEditor> createState() => _ExpressionEditorState();
}

class _ExpressionEditorState extends State<ExpressionEditor> {
  // GlobalKey to manage cursor positions
  final GlobalKey _cursorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CalculatorBloc, CalculatorState>(
      listener: (BuildContext context, CalculatorState state) {
        _scrollToCursor(state.cursorIndex, state.expression.tokens.length);
      },
      builder: (context, state) {
        return SizedBox(
          height: 40,
          child: Align(
            alignment: Alignment.centerRight,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SizedBox(width: 8.0),
                  for (
                    int index = 0;
                    index < (state.expression.tokens.isEmpty ? 1 : state.expression.tokens.length);
                    index++
                  ) ...[
                    // Case 1: the expression is empty, just draw the cursor
                    if (state.expression.tokens.isEmpty)
                      Padding(
                        key: _cursorKey,
                        padding: const EdgeInsets.only(top: 3, bottom: 3, right: 4),
                        child: const BlinkingCursor(),
                      )
                    else
                      // Case 2: We are building a token widget
                      ExpressionTokenItem(
                        token: state.expression.tokens[index],
                        tokenIndex: index,
                        cursorPosition: _getCursorPosition(index, state.cursorIndex),
                        cursorKey: _cursorKey,
                      ),
                  ],
                  SizedBox(width: 8.0),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Scrolls the expression editor to ensure the cursor is visible
  void _scrollToCursor(int cursorIndex, int tokenCount) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_cursorKey.currentContext == null) return;

      // Get the cursor's render box to check its position
      final RenderBox cursorBox = _cursorKey.currentContext!.findRenderObject() as RenderBox;
      final cursorPosition = cursorBox.localToGlobal(Offset.zero);

      // Get the ListView's render box to check viewport bounds
      final RenderBox? listViewBox = context.findRenderObject() as RenderBox?;
      if (listViewBox == null) return;

      final listViewPosition = listViewBox.localToGlobal(Offset.zero);
      final viewportLeft = listViewPosition.dx;
      final viewportRight = listViewPosition.dx + listViewBox.size.width;

      final cursorLeft = cursorPosition.dx;
      final cursorRight = cursorPosition.dx + cursorBox.size.width;

      // Determine alignment and policy based on where cursor is
      double alignment;
      ScrollPositionAlignmentPolicy policy;

      if (cursorRight > viewportRight) {
        // Cursor is off-screen to the right - bring it back
        alignment = 0.97;
        policy = ScrollPositionAlignmentPolicy.explicit;
      } else if (cursorLeft < viewportLeft) {
        // Cursor is off-screen to the left - bring it back
        alignment = 0.03;
        policy = ScrollPositionAlignmentPolicy.explicit;
      } else {
        // Cursor is visible - keep it at end to prevent push-out
        alignment = 0.97;
        policy = ScrollPositionAlignmentPolicy.keepVisibleAtEnd;
      }

      // Scroll to the cursor position
      Scrollable.ensureVisible(
        _cursorKey.currentContext!,
        duration: const Duration(milliseconds: 100),
        alignment: alignment,
        alignmentPolicy: policy,
        curve: Curves.easeInOut,
      );
    });
  }

  /// Determines the cursor position relative to a token
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
