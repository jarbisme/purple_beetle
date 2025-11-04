import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purple_beetle/features/calculator/domain/entities/expression.dart';
import 'package:purple_beetle/features/calculator/presentation/bloc/calculator_event.dart';
import 'package:purple_beetle/features/calculator/presentation/bloc/calculator_state.dart';

class CalculatorBloc extends Bloc<CalculatorEvent, CalculatorState> {
  CalculatorBloc() : super(CalculatorInitialState()) {
    on<InsertToken>((event, emit) {
      final currentState = state;

      if (currentState is BuildingExpressionState) {
        // Update the expression
        var currentExpression = currentState.expression;

        // if the last token is a number and the new token is also a number, we should combine them
        if (currentExpression.tokens.isNotEmpty) {
          final lastToken = currentExpression.tokens.last;
          if (lastToken is DigitToken && event.token is DigitToken) {
            final combinedValue = int.parse('${lastToken.value}${(event.token as DigitToken).value}');
            currentExpression.tokens.removeLast();
            currentExpression.tokens.add(DigitToken(combinedValue));
          } else if (lastToken is OperatorToken && event.token is OperatorToken) {
            // If the last token is an operator and the new token is also an operator, we should replace it
            currentExpression.tokens.removeLast();
            currentExpression.tokens.add(event.token);
          } else {
            currentExpression.tokens.add(event.token);
          }
        } else {
          currentExpression.tokens.add(event.token);
        }

        // TODO: try to evaluate the expression here and emit appropriate state
        final result = '...'; // Placeholder for evaluation result

        emit(BuildingExpressionState(expression: currentExpression, displayValue: result));
      } else {
        // Start a new expression
        final newExpression = Expression([event.token]);
        emit(BuildingExpressionState(expression: newExpression, displayValue: newExpression.toString()));
      }

      printExpression(
        state is BuildingExpressionState || state is EvaluationSuccess || state is EvaluationError
            ? (state as BuildingExpressionState).expression
            : Expression([]),
      );
    });
  }
}

void printExpression(Expression expression) {
  var tokenTypes = <String>[];
  for (var token in expression.tokens) {
    if (token is DigitToken) {
      tokenTypes.add(token.value.toString());
    } else if (token is OperatorToken) {
      tokenTypes.add(token.operator);
    } else if (token is ParenthesisToken) {
      tokenTypes.add(token.parenthesis);
    } else if (token is DecimalPointToken) {
      tokenTypes.add('.');
    }
  }
  print('Expression Tokens: ${tokenTypes.join('')}');
}
