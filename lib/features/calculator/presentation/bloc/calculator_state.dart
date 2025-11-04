import 'package:flutter/foundation.dart';
import 'package:purple_beetle/features/calculator/domain/entities/expression.dart';

@immutable
abstract class CalculatorState {
  final String displayValue;
  final Expression expression;

  const CalculatorState({required this.displayValue, required this.expression});

  List<Object> get props => [displayValue, expression];
}

/// Initial state of the calculator
class CalculatorInitialState extends CalculatorState {
  CalculatorInitialState() : super(displayValue: '0', expression: Expression([]));
}

/// State when the user is building the expression
class BuildingExpressionState extends CalculatorState {
  final int cursorIndex;

  const BuildingExpressionState({required super.expression, this.cursorIndex = 0, required super.displayValue});

  @override
  List<Object> get props => [expression, cursorIndex, displayValue];
}

/// State representing the result of a successful evaluation
class EvaluationSuccess extends CalculatorState {
  const EvaluationSuccess({required super.expression, required super.displayValue});

  @override
  List<Object> get props => [expression, displayValue];
}

/// State representing an evaluation error
class EvaluationError extends CalculatorState {
  const EvaluationError({required super.expression, required super.displayValue});

  @override
  List<Object> get props => [expression, displayValue];
}
