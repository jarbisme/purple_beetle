import 'package:purple_beetle/features/variables/domain/repositories/variables_repository.dart';
import 'package:purple_beetle/features/variables/domain/entities/variable.dart';

/// In-memory implementation of VariablesRepository
class InMemoryVariablesRepository extends VariablesRepository {
  final Map<String, Variable> _variables = {};

  @override
  Future<List<Variable>> getAllVariables() async {
    return _variables.values.toList();
  }

  @override
  Future<Variable?> getVariableById(String id) async {
    return _variables[id];
  }

  @override
  Future<Variable?> createVariable(Variable newVariable) async {
    _variables[newVariable.id] = newVariable;
    return newVariable;
  }

  @override
  Future<void> upsertVariable(Variable variable) async {
    _variables[variable.id] = variable;
  }

  @override
  Future<void> deleteVariable(String id) async {
    _variables.remove(id);
  }
}
