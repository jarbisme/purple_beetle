import 'package:flutter/material.dart';
import 'package:purple_beetle/features/calculator/domain/entities/expression.dart';

@immutable
abstract class CalculatorEvent {
  const CalculatorEvent();

  List<Object> get props => [];
}

/// Event for when a number, operator, or parenthesis key is pressed
class InsertToken extends CalculatorEvent {
  final ExpressionToken token;
  const InsertToken(this.token);

  @override
  List<Object> get props => [token];
}

/// Event for when the 'DEL' (Backspace) key is pressed to remove the token before the cursor
class Backspace extends CalculatorEvent {}

/// Event for moving the cursor to a new index in the expression
class MoveCursor extends CalculatorEvent {
  final int newIndex;
  const MoveCursor(this.newIndex);

  @override
  List<Object> get props => [newIndex];
}

/// Event for when the '=' key is pressed to evaluate the expression
class Evaluate extends CalculatorEvent {}

/// Event for when the 'AC' (All Clear) key is pressed to clear the expression
class ClearExpression extends CalculatorEvent {}
