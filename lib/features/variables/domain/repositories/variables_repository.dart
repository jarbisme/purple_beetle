import 'package:purple_beetle/features/variables/domain/entities/variable.dart';

/// Repository interface for managing variables.
abstract class VariablesRepository {
  /// Fetches all stored variables.
  Future<List<Variable>> getAllVariables();

  /// Fetches a variable by its ID.
  Future<Variable?> getVariableById(String id);

  /// Creates a new variable with the given name.
  Future<Variable?> createVariable(Variable newVariable);

  /// Adds or updates a variable.
  Future<void> upsertVariable(Variable variable);

  /// Deletes a variable by its ID.
  Future<void> deleteVariable(String id);
}
