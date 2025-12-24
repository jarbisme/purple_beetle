import 'package:flutter/material.dart';
import 'package:purple_beetle/features/calculator/domain/entities/expression.dart';

@immutable
abstract class CalculatorEvent {
  const CalculatorEvent();

  List<Object> get props => [];
}

/// Event for when a number, operator, or parenthesis key is pressed
class InsertTokenEvent extends CalculatorEvent {
  final ExpressionToken token;
  const InsertTokenEvent(this.token);

  @override
  List<Object> get props => [token];
}

/// Event for when the 'DEL' (Backspace) key is pressed to remove the token before the cursor
class BackspaceEvent extends CalculatorEvent {}

/// Event for moving the cursor to a new index in the expression
class MoveCursorEvent extends CalculatorEvent {
  final int newIndex;
  const MoveCursorEvent(this.newIndex);

  @override
  List<Object> get props => [newIndex];
}

/// Event for when the '=' key is pressed to evaluate the expression
class EvaluateEvent extends CalculatorEvent {}

/// Event for when the 'AC' (All Clear) key is pressed to clear the expression
class ClearExpressionEvent extends CalculatorEvent {}
