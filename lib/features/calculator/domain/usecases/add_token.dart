import 'package:purple_beetle/features/calculator/domain/entities/add_token_result.dart';
import 'package:purple_beetle/features/calculator/domain/entities/expression.dart';

class AddToken {
  AddTokenResult call({
    required Expression currentExpression,
    required ExpressionToken tokenToAdd,
    required int cursorIndex,
  }) {
    final tokens = List<ExpressionToken>.from(currentExpression.tokens);

    // Rule: Prevent two operators in a row
    if (tokenToAdd is OperatorToken) {
      if (cursorIndex > 0 &&
          tokens[cursorIndex - 1] is OperatorToken &&
          (tokens[cursorIndex - 1] as OperatorToken).operator != '%') {
        // Replace the previous operator, cursor does not move
        tokens[cursorIndex - 1] = tokenToAdd;
        return AddTokenResult(expression: Expression(tokens), newCursorIndex: cursorIndex);
      }
    }

    // Rule: Prevent multiple decimal points in the same number
    // TODO: Confirm if this is necesary. Perhaps it can be simplified to not allow 2 decimal points in a row
    if (tokenToAdd is DecimalPointToken) {
      int numberStartIndex = cursorIndex - 1;
      while (numberStartIndex >= 0 && tokens[numberStartIndex] is! OperatorToken) {
        if (tokens[numberStartIndex] is DecimalPointToken) {
          // Do not add another decimal point, expression and cursor are unchanged
          return AddTokenResult(expression: currentExpression, newCursorIndex: cursorIndex);
        }
        numberStartIndex--;
      }
      numberStartIndex = cursorIndex;
      while (numberStartIndex <= tokens.length - 1 && tokens[numberStartIndex] is! OperatorToken) {
        if (tokens[numberStartIndex] is DecimalPointToken) {
          // Do not add another decimal point, expression and cursor are unchanged
          return AddTokenResult(expression: currentExpression, newCursorIndex: cursorIndex);
        }
        numberStartIndex++;
      }
    }

    // TODO: Add rules for variables

    // If validation passes, insert the token and advance the cursor
    tokens.insert(cursorIndex, tokenToAdd);
    return AddTokenResult(expression: Expression(tokens), newCursorIndex: cursorIndex + 1);
  }
}
