import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purple_beetle/features/calculator/domain/entities/expression.dart';
import 'package:purple_beetle/features/calculator/presentation/bloc/calculator_event.dart';
import 'package:purple_beetle/features/calculator/presentation/bloc/calculator_state.dart';

class CalculatorBloc extends Bloc<CalculatorEvent, CalculatorState> {
  CalculatorBloc() : super(CalculatorInitialState()) {
    on<CalculatorKeyPressed>((event, emit) {
      // Handle key press event
      final currentState = state;
      if (currentState is BuildingExpressionState) {
        // Update the expression
        currentState.expression.tokens.add(event.key);
        final newExpression = currentState.expression;

        // TODO: try to evaluate the expression here and emit appropriate state
        final result = '...'; // Placeholder for evaluation result

        emit(BuildingExpressionState(expression: newExpression, displayValue: result));
      } else {
        // Start a new expression
        final newExpression = Expression([]);
        emit(BuildingExpressionState(expression: newExpression, displayValue: newExpression.toString()));
      }
    });
  }
}
