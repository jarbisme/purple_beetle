import 'package:equatable/equatable.dart';
import 'package:purple_beetle/features/variables/domain/entities/variable.dart';

class VariablesState extends Equatable {
  const VariablesState({this.variables = const [], this.selectedVariable, this.error});

  final List<Variable> variables;
  final Variable? selectedVariable;
  final String? error;

  VariablesState copyWith({List<Variable>? variables, Variable? selectedVariable, String? error}) {
    return VariablesState(
      variables: variables ?? this.variables,
      selectedVariable: selectedVariable ?? this.selectedVariable,
      error: error ?? this.error,
    );
  }

  @override
  List<Object> get props => [variables, selectedVariable ?? '', error ?? ''];
}
