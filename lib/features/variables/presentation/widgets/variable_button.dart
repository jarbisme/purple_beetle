import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purple_beetle/features/calculator/domain/entities/expression.dart';
import 'package:purple_beetle/features/calculator/presentation/bloc/calculator_bloc.dart';
import 'package:purple_beetle/features/calculator/presentation/bloc/calculator_event.dart';
import 'package:purple_beetle/features/variables/domain/entities/variable.dart';

/// A button widget that displays a variable's name and value.
/// Allows interation to insert the variable in the expression, and to select it for editing on long press.
class VariableButton extends StatelessWidget {
  const VariableButton({super.key, required this.variable});

  final Variable variable;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: TextButton(
        onPressed: () {
          // Insert variable into expression
          context.read<CalculatorBloc>().add(InsertTokenEvent(VariableToken(variable.id)));
        },
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          backgroundColor: Color(variable.color),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              variable.name,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white70),
            ),
            Text('${variable.value}', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
