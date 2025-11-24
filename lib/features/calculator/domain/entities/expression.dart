/// Represents a mathematical expression composed of tokens.
class Expression {
  final List<ExpressionToken> tokens;
  const Expression(this.tokens);
}

/// Abstract class representing a token in the expression.
abstract class ExpressionToken {}

/// Represents a single digit (0-9) in the expression
class DigitToken extends ExpressionToken {
  final int value;
  DigitToken(this.value);
}

/// Represents a decimal point in the expression
class DecimalPointToken extends ExpressionToken {}

/// Represents an operator (+, -, *, /, %) in the expression
class OperatorToken extends ExpressionToken {
  final String operator;
  OperatorToken(this.operator);
}

/// Represents a parenthesis '(' or ')' in the expression
class ParenthesisToken extends ExpressionToken {
  final String parenthesis;
  ParenthesisToken(this.parenthesis);
}
