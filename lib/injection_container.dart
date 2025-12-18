import 'package:get_it/get_it.dart';
import 'package:purple_beetle/features/calculator/domain/usecases/add_token.dart';
import 'package:purple_beetle/features/calculator/domain/usecases/evaluate_expression.dart';
import 'package:purple_beetle/features/calculator/presentation/bloc/calculator_bloc.dart';
import 'package:purple_beetle/features/variables/presentation/bloc/variables_bloc.dart';

final sl = GetIt.instance;

void setupInjectionContainer() {
  // Register use cases
  sl.registerFactory<AddToken>(() => AddToken());
  sl.registerFactory<EvaluateExpression>(() => EvaluateExpression());

  // Register BLoCs
  sl.registerFactory<CalculatorBloc>(
    () => CalculatorBloc(addToken: sl<AddToken>(), evaluateExpression: sl<EvaluateExpression>()),
  );
  sl.registerFactory<VariablesBloc>(() => VariablesBloc());
}
