import 'package:math_expressions/math_expressions.dart' as math;
import 'package:purple_beetle/features/calculator/domain/entities/expression.dart';

class EvaluateExpression {
  String? call({required expression}) {
    try {
      // Phase 1: Token Preprocessing
      List<ExpressionToken> tokens = _preprocessTokens(expression.tokens);

      // Phase 2: Token to String Conversion
      String strExpression = _tokensToString(tokens);

      // Phase 3: String-level Transformations
      strExpression = _handlePercentage(strExpression);

      if (strExpression.isEmpty) {
        return '0';
      }

      print('Cleaned expression: $strExpression');

      // Phase 4: Evaluation
      return _evaluateExpression(strExpression);
    } catch (e) {
      return 'Error';
    }
  }

  //#region  ============ Phase 1: Token Preprocessing ============

  /// Processes the list of ExpressionTokens to handle implicit multiplication,
  /// balance parentheses, and clean up trailing operators or decimal points
  List<ExpressionToken> _preprocessTokens(List<ExpressionToken> tokens) {
    if (tokens.isEmpty) return tokens;

    tokens = _addImplicitMultiplication(tokens);
    tokens = _balanceParentheses(tokens);
    tokens = _removeTrailingOperator(tokens);
    tokens = _handleTrailingDecimalPoint(tokens);

    return tokens;
  }

  /// Adds implicit multiplication where necessary
  /// e.g., 5(2+3) -> 5*(2+3)
  List<ExpressionToken> _addImplicitMultiplication(List<ExpressionToken> tokens) {
    final result = <ExpressionToken>[tokens.first];

    for (int i = 1; i < tokens.length; i++) {
      final prev = tokens[i - 1];
      final current = tokens[i];

      // Add * between: number( or )(
      if ((prev is DigitToken || (prev is ParenthesisToken && prev.parenthesis == ')')) &&
          (current is ParenthesisToken && current.parenthesis == '(')) {
        result.add(OperatorToken('*'));
      }
      result.add(current);
    }

    return result;
  }

  /// Balances open and close parentheses by adding missing closing parentheses at the end
  /// e.g., (2+3 -> (2+3)
  // TODO: Verify if this covers nested parentheses correctly
  List<ExpressionToken> _balanceParentheses(List<ExpressionToken> tokens) {
    int openCount = 0;

    for (final token in tokens) {
      if (token is ParenthesisToken) {
        openCount += token.parenthesis == '(' ? 1 : -1;
      }
    }

    final result = List<ExpressionToken>.from(tokens);
    for (int i = 0; i < openCount; i++) {
      result.add(ParenthesisToken(')'));
    }

    return result;
  }

  /// Removes trailing operators (except %)
  /// e.g., 12+8- -> 12+8
  List<ExpressionToken> _removeTrailingOperator(List<ExpressionToken> tokens) {
    if (tokens.isEmpty) return tokens;

    final result = List<ExpressionToken>.from(tokens);

    // Remove trailing operators (except %)
    while (result.isNotEmpty && result.last is OperatorToken && (result.last as OperatorToken).operator != '%') {
      result.removeLast();
    }

    return result;
  }

  /// Removes decimal points that are not followed by a digit
  /// e.g., "12." becomes "12", but "12.3" remains "12.3"
  List<ExpressionToken> _handleTrailingDecimalPoint(List<ExpressionToken> tokens) {
    if (tokens.isEmpty) return tokens;

    final result = <ExpressionToken>[];

    for (int i = 0; i < tokens.length; i++) {
      // If current token is a decimal point
      if (tokens[i] is DecimalPointToken) {
        // Check if next token is a digit
        final isLastToken = i == tokens.length - 1;
        final nextIsDigit = !isLastToken && tokens[i + 1] is DigitToken;

        // Only add the decimal point if it's followed by a digit
        if (nextIsDigit) {
          result.add(tokens[i]);
        }
        // Otherwise, skip it (don't add it to result)
      } else {
        result.add(tokens[i]);
      }
    }

    return result;
  }

  //#endregion

  //#region  ============ Phase 2: Token to String Conversion ============

  /// Converts a list of ExpressionTokens to a string expression
  String _tokensToString(List<ExpressionToken> tokens) {
    final buffer = StringBuffer();

    for (final token in tokens) {
      if (token is DigitToken) {
        buffer.write(token.value);
      } else if (token is DecimalPointToken) {
        buffer.write('.');
      } else if (token is OperatorToken) {
        buffer.write(token.operator);
      } else if (token is ParenthesisToken) {
        buffer.write(token.parenthesis);
      } else {
        throw Exception('Unrecognized token: $token');
      }
    }

    return buffer.toString();
  }

  //#endregion

  //#region  ============ Phase 3: String-level Transformations ============

  /// Transforms percentage expressions into equivalent mathematical expressions
  /// Handles operator precedence: * and / convert to decimal, + and - apply percentage to left operand
  String _handlePercentage(String expression) {
    while (expression.contains('%')) {
      final percentIndex = expression.indexOf('%');

      // Find the number before %
      int percentStart = percentIndex - 1;
      while (percentStart >= 0 && _isDigitOrDot(expression[percentStart])) {
        percentStart--;
      }
      percentStart++;

      final percentValue = expression.substring(percentStart, percentIndex);

      // Find the operator before the percentage
      int operatorIndex = percentStart - 1;
      while (operatorIndex >= 0 && expression[operatorIndex] == ' ') {
        operatorIndex--;
      }

      if (operatorIndex >= 0 && _isOperator(expression[operatorIndex])) {
        final operator = expression[operatorIndex];
        final before = expression.substring(0, percentStart);
        final after = expression.substring(percentIndex + 1);

        if (operator == '*' || operator == '/') {
          // For multiplication/division, just convert to decimal
          expression = '$before($percentValue/100)$after';
        } else {
          // For addition/subtraction, need to find the left operand
          final baseValue = expression.substring(0, operatorIndex).trim();
          final base = baseValue.isEmpty ? '0' : baseValue;
          expression = '($base)$operator(($base)*$percentValue/100)$after';
        }
      } else {
        // No operator, simple percentage: 10% -> 10/100
        final before = expression.substring(0, percentStart);
        final after = expression.substring(percentIndex + 1);
        expression = '$before($percentValue/100)$after';
      }
    }

    return expression;
  }

  //#endregion

  //#region  ============ Phase 4: Evaluation ============

  /// Evaluates the mathematical expression string and returns the result as a string
  String _evaluateExpression(String expression) {
    final parser = math.GrammarParser();
    final exp = parser.parse(expression);
    final evaluator = math.RealEvaluator();
    final result = evaluator.evaluate(exp);

    if (result.isNaN || result.isInfinite) {
      return 'Error';
    }

    if (result % 1 == 0) {
      return result.toInt().toString();
    }

    return double.parse(result.toStringAsFixed(10)).toString();
  }

  //#endregion

  //#region  ============ Helper Methods ============

  bool _isDigitOrDot(String char) {
    return char.contains(RegExp(r'[0-9.]'));
  }

  bool _isOperator(String char) {
    return ['+', '-', '*', '/'].contains(char);
  }

  //#endregion
}
