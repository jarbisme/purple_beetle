import 'package:flutter/widgets.dart';
import 'package:purple_beetle/features/variables/domain/entities/variable.dart';

@immutable
abstract class VariablesEvent {
  const VariablesEvent();

  List<Object> get props => [];
}

/// Event to load all variables. This could be triggered when the screen loads.
class LoadVariables extends VariablesEvent {}

/// Event to create a new variable with a name, value, and color.
class CreateVariable extends VariablesEvent {
  final String name;
  final double value;
  final Color color;

  const CreateVariable({required this.name, required this.value, required this.color});

  @override
  List<Object> get props => [name, value, color];
}

/// Event to select a variable for editing or using its value.
class SelectVariable extends VariablesEvent {
  final Variable variable;

  const SelectVariable(this.variable);

  @override
  List<Object> get props => [variable];
}

/// Event to delete a variable by its identifier.
class DeleteVariable extends VariablesEvent {
  final String variableId;

  const DeleteVariable(this.variableId);

  @override
  List<Object> get props => [variableId];
}
