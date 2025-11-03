import 'package:flutter/foundation.dart';
import 'package:purple_beetle/features/calculator/domain/entities/expression.dart';

@immutable
abstract class CalculatorState {
  final String displayValue;

  const CalculatorState({required this.displayValue});

  List<Object> get props => [displayValue];
}

/// Initial state of the calculator
class CalculatorInitialState extends CalculatorState {
  const CalculatorInitialState() : super(displayValue: '0');
}

/// State when the user is building the expression
class BuildingExpressionState extends CalculatorState {
  final Expression expression;

  const BuildingExpressionState({required this.expression, required super.displayValue});

  @override
  List<Object> get props => [expression, displayValue];
}

/// State representing the result of a successful evaluation
class EvaluationSuccess extends CalculatorState {
  final Expression expression;

  const EvaluationSuccess({required this.expression, required super.displayValue});

  @override
  List<Object> get props => [expression, displayValue];
}

/// State representing an evaluation error
class EvaluationError extends CalculatorState {
  final Expression expression;

  const EvaluationError({required this.expression, required super.displayValue});

  @override
  List<Object> get props => [expression, displayValue];
}
