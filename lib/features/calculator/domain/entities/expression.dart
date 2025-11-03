/// Represents a mathematical expression composed of tokens.
class Expression {
  final List<ExpressionToken> tokens;

  Expression(this.tokens);
}

abstract class ExpressionToken {}

class NumberToken extends ExpressionToken {
  final double value;

  NumberToken(this.value);
}

class OperatorToken extends ExpressionToken {
  final String operator;

  OperatorToken(this.operator);
}

class ParenthesisToken extends ExpressionToken {
  final String parenthesis; // '(' or ')'

  ParenthesisToken(this.parenthesis);
}
