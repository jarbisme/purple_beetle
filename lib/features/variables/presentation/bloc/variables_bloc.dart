import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purple_beetle/features/variables/domain/usecases/create_variable.dart';
import 'package:purple_beetle/features/variables/presentation/bloc/variables_event.dart';
import 'package:purple_beetle/features/variables/presentation/bloc/variables_state.dart';

class VariablesBloc extends Bloc<VariablesEvent, VariablesState> {
  final CreateVariable _createVariable;

  VariablesBloc({required CreateVariable createVariable}) : _createVariable = createVariable, super(VariablesState()) {
    on<LoadVariables>((event, emit) {
      // Handle loading variables logic here
      emit(VariablesState(variables: []));
    });
    on<SelectVariableEvent>((event, emit) {
      // Handle selecting a variable logic here
      emit(state.copyWith(selectedVariable: event.variable));
    });
    on<CreateVariableEvent>((event, emit) async {
      // Handle creating a variable logic here
      final result = await _createVariable.call(name: event.name, value: event.value, color: event.color.index);

      if (result == null) {
        // Handle error case if needed
        return;
      }

      // TODO: Revise the way to update the state after creating a variable
      // Should ideally fetch the updated list from a repository or data source

      // Handle adding a variable logic here
      emit(state.copyWith(variables: List.from(state.variables)..add(result)));
    });
  }
}
