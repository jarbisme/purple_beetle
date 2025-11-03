import 'package:flutter/material.dart';
import 'package:purple_beetle/features/calculator/domain/entities/expression.dart';

@immutable
abstract class CalculatorEvent {
  const CalculatorEvent();

  List<Object> get props => [];
}

/// Event for when a number, operator, or parenthesis key is pressed
class CalculatorKeyPressed extends CalculatorEvent {
  final ExpressionToken key;

  const CalculatorKeyPressed(this.key);

  @override
  List<Object> get props => [key];
}

/// Event for when the '=' key is pressed to evaluate the expression
class Evaluate extends CalculatorEvent {}

/// Event for when the 'AC' (All Clear) key is pressed to clear the expression
class ClearExpression extends CalculatorEvent {}

/// Event for when the 'DEL' (Backspace) key is pressed to remove the last token
class Backspace extends CalculatorEvent {}
