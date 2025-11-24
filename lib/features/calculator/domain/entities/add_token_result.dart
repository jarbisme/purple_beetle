import 'package:purple_beetle/features/calculator/domain/entities/expression.dart';

class AddTokenResult {
  final Expression expression;
  final int newCursorIndex;

  AddTokenResult({required this.expression, required this.newCursorIndex});
}
