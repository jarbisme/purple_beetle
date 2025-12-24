import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purple_beetle/features/calculator/domain/entities/expression.dart';
import 'package:purple_beetle/features/calculator/domain/usecases/add_token.dart';
import 'package:purple_beetle/features/calculator/domain/usecases/evaluate_expression.dart';
import 'package:purple_beetle/features/calculator/presentation/bloc/calculator_event.dart';
import 'package:purple_beetle/features/calculator/presentation/bloc/calculator_state.dart';

class CalculatorBloc extends Bloc<CalculatorEvent, CalculatorState> {
  final AddToken _addToken;
  final EvaluateExpression _evaluateExpression;

  CalculatorBloc({required AddToken addToken, required EvaluateExpression evaluateExpression})
    : _addToken = addToken,
      _evaluateExpression = evaluateExpression,
      super(CalculatorState()) {
    on<InsertTokenEvent>(_handleInsertToken);

    on<BackspaceEvent>(_handleBackspace);

    on<MoveCursorEvent>((event, emit) {
      emit(state.copyWith(cursorIndex: event.newIndex));
    });

    on<ClearExpressionEvent>((event, emit) {
      emit(CalculatorState(expression: Expression([]), cursorIndex: 0));
    });

    on<EvaluateEvent>(_handleEvaluate);
  }

  // #region  ============ Event Handlers ============

  // Handles the backspace event to delete the token before the cursor
  void _handleBackspace(BackspaceEvent event, Emitter<CalculatorState> emit) async {
    final currentState = state;

    if (currentState.cursorIndex == 0) return; // Nothing to delete

    // Update the expression
    var currentExpression = currentState.expression;
    final updatedTokens = List<ExpressionToken>.from(currentExpression.tokens);
    updatedTokens.removeAt(currentState.cursorIndex - 1);
    currentExpression = Expression(updatedTokens);
    final newCursorIndex = currentState.cursorIndex - 1;

    final result = await _tryEvaluate(currentExpression);

    // If evaluation fails, return error state
    if (result == null && currentExpression.tokens.isNotEmpty) {
      emit(currentState.copyWith(error: 'Error', expression: currentExpression, cursorIndex: newCursorIndex));
      return;
    }

    emit(CalculatorState(expression: currentExpression, cursorIndex: newCursorIndex, result: result));
  }

  // Handles the evaluate event to compute the result of the current expression
  void _handleEvaluate(EvaluateEvent event, Emitter<CalculatorState> emit) async {
    // evaluates the expression, saves it to the history, and set the current expression as the result
    final result = await _evaluateExpression.call(expression: state.expression);

    if (result == null) {
      // Handle evaluation error (e.g., emit an error state or keep the current state)
      emit(state.copyWith(error: 'Error', clearResult: true));
      return;
    }

    final newExpression = _parseResultToExpression(result);

    emit(CalculatorState(expression: newExpression, result: result, cursorIndex: newExpression.tokens.length));
  }

  // Handles the insert token event to add a new token at the cursor position
  void _handleInsertToken(InsertTokenEvent event, Emitter<CalculatorState> emit) async {
    final tokenAdditionResult = _addToken.call(
      currentExpression: state.expression,
      tokenToAdd: event.token,
      cursorIndex: state.cursorIndex,
    );

    final expressionResult = await _tryEvaluate(tokenAdditionResult.expression);

    // If evaluation fails, return error state
    if (expressionResult == null) {
      emit(
        state.copyWith(
          error: 'Error',
          expression: tokenAdditionResult.expression,
          cursorIndex: tokenAdditionResult.newCursorIndex,
        ),
      );
    } else {
      emit(
        CalculatorState(
          expression: tokenAdditionResult.expression,
          cursorIndex: tokenAdditionResult.newCursorIndex,
          result: expressionResult,
        ),
      );
    }
  }
  //#endregion

  // #region  ============ Helper Methods ============

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

  Future<String?> _tryEvaluate(Expression expression) async {
    if (expression.tokens.isEmpty) {
      return '0';
    }

    final stopwatch = Stopwatch()..start();
    try {
      final result = await _evaluateExpression.call(expression: expression);
      stopwatch.stop();
      // print('Evaluation took: ${stopwatch.elapsedMilliseconds} ms');
      return result;
    } catch (e) {
      stopwatch.stop();
      // print('Evaluation failed after: ${stopwatch.elapsedMilliseconds} ms');
      return null;
    }
  }

  //#endregion
}
