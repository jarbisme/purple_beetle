import 'package:purple_beetle/features/variables/domain/entities/variable.dart';
import 'package:purple_beetle/features/variables/domain/repositories/variables_repository.dart';
import 'package:uuid/uuid.dart';

/// Use case for creating a new variable
class CreateVariable {
  final VariablesRepository variablesRepository;

  CreateVariable({required this.variablesRepository});

  Future<Variable?> call({required String name, required double value, required int color}) async {
    final newVariable = Variable(id: _uniqueKey(), name: name, value: value, color: color);

    final result = await variablesRepository.createVariable(newVariable);

    return result;
  }

  String _uniqueKey() {
    // Create a unique key UUID generator
    var uuid = Uuid();
    return uuid.v4();
  }
}
