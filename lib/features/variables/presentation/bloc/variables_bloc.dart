import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purple_beetle/features/variables/domain/entities/variable.dart';
import 'package:purple_beetle/features/variables/presentation/bloc/variables_event.dart';
import 'package:purple_beetle/features/variables/presentation/bloc/variables_state.dart';
import 'package:uuid/uuid.dart';

class VariablesBloc extends Bloc<VariablesEvent, VariablesState> {
  VariablesBloc() : super(VariablesState()) {
    on<LoadVariables>((event, emit) {
      // Handle loading variables logic here
      emit(VariablesState(variables: []));
    });
    on<SelectVariable>((event, emit) {
      // Handle selecting a variable logic here
      emit(state.copyWith(selectedVariable: event.variable));
    });
    on<CreateVariable>((event, emit) {
      // Handle creating a variable logic here
      final newVariable = Variable(id: uniqueKey(), name: event.name, value: event.value, color: event.color);

      // Handle adding a variable logic here
      emit(state.copyWith(variables: List.from(state.variables)..add(newVariable)));
    });
  }

  String uniqueKey() {
    // Create a unique key UUID generator
    var uuid = Uuid();
    return uuid.v4();
  }
}
