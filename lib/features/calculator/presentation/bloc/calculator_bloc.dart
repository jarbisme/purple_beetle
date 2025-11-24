import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purple_beetle/features/calculator/domain/entities/expression.dart';
import 'package:purple_beetle/features/calculator/domain/usecases/add_token.dart';
import 'package:purple_beetle/features/calculator/domain/usecases/evaluate_expression.dart';
import 'package:purple_beetle/features/calculator/presentation/bloc/calculator_event.dart';
import 'package:purple_beetle/features/calculator/presentation/bloc/calculator_state.dart';

class CalculatorBloc extends Bloc<CalculatorEvent, CalculatorState> {
  final AddToken _addToken;
  final EvaluateExpression _evaluateExpression;

  CalculatorBloc({AddToken? addToken, EvaluateExpression? evaluateExpression})
    : _addToken = addToken ?? AddToken(),
      _evaluateExpression = evaluateExpression ?? EvaluateExpression(),
      super(CalculatorState()) {
    on<InsertToken>(_handleInsertToken);

    on<Backspace>((event, emit) {
      final currentState = state;

      if (currentState.cursorIndex == 0) return; // Nothing to delete

      // Update the expression
      var currentExpression = currentState.expression;
      final updatedTokens = List<ExpressionToken>.from(currentExpression.tokens);
      updatedTokens.removeAt(currentState.cursorIndex - 1);
      currentExpression = Expression(updatedTokens);
      final newCursorIndex = currentState.cursorIndex - 1;

      final result = _tryEvaluate(currentExpression);

      emit(CalculatorState(expression: currentExpression, cursorIndex: newCursorIndex, result: result));
    });

    on<MoveCursor>((event, emit) {
      emit(state.copyWith(cursorIndex: event.newIndex));
    });

    on<ClearExpression>((event, emit) {
      emit(CalculatorState(expression: Expression([]), cursorIndex: 0));
    });

    on<Evaluate>((event, emit) {
      // evaluates the expression, saves it to the history, and set the current expression as the result
      final result = _evaluateExpression.call(expression: state.expression);

      // TODO: Parse result to list of ExpressionTokens

      if (result == null) {
        // Handle evaluation error (e.g., emit an error state or keep the current state)
        return;
      }

      final newExpression = _parseResultToExpression(result);

      emit(CalculatorState(expression: newExpression, result: result, cursorIndex: newExpression.tokens.length));
    });
  }

  void _handleInsertToken(InsertToken event, Emitter<CalculatorState> emit) {
    final result = _addToken.call(
      currentExpression: state.expression,
      tokenToAdd: event.token,
      cursorIndex: state.cursorIndex,
    );

    final expressionResult = _tryEvaluate(result.expression);

    emit(CalculatorState(expression: result.expression, cursorIndex: result.newCursorIndex, result: expressionResult));
  }

  Expression _parseResultToExpression(String result) {
    final tokens = <ExpressionToken>[];

    for (int i = 0; i < result.length; i++) {
      final char = result[i];
      if (RegExp(r'\d').hasMatch(char)) {
        tokens.add(DigitToken(int.parse(char)));
      } else if (char == '.') {
        tokens.add(DecimalPointToken());
      } else if ('+-*/'.contains(char)) {
        tokens.add(OperatorToken(char));
      } else if ('()'.contains(char)) {
        tokens.add(ParenthesisToken(char));
      } else {
        throw Exception('Unrecognized character in result: $char');
      }
    }

    return Expression(tokens);
  }

  String _tryEvaluate(Expression expression) {
    if (expression.tokens.isEmpty) {
      return '0';
    }

    final stopwatch = Stopwatch()..start();
    try {
      final result = _evaluateExpression.call(expression: expression);
      stopwatch.stop();
      print('Evaluation took: ${stopwatch.elapsedMilliseconds} ms');
      return result ?? 'Error';
    } catch (e) {
      stopwatch.stop();
      print('Evaluation failed after: ${stopwatch.elapsedMilliseconds} ms');
      return 'Error';
    }
  }
}
