import 'package:equatable/equatable.dart';
import 'package:purple_beetle/features/calculator/domain/entities/expression.dart';

class CalculatorState extends Equatable {
  /// The list of tokens representing the current mathematical expression.
  final Expression expression;

  /// The position of the cursor in the expression.
  final int cursorIndex;

  /// The final calculated result to be displayed. Null if not calculated.
  final String? result;

  /// An error message to be displayed. Null if there is no error.
  final String? error;

  const CalculatorState({this.expression = const Expression([]), this.cursorIndex = 0, this.result, this.error});

  /// Creates a copy of the current state with updated values.
  CalculatorState copyWith({
    Expression? expression,
    int? cursorIndex,
    String? result,
    String? error,
    bool clearResult = false,
    bool clearError = false,
  }) {
    return CalculatorState(
      expression: expression ?? this.expression,
      cursorIndex: cursorIndex ?? this.cursorIndex,
      result: clearResult ? null : result ?? this.result,
      error: clearError ? null : error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [expression, cursorIndex, result, error];
}
