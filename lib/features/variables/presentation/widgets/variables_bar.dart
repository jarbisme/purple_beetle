import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purple_beetle/features/variables/presentation/bloc/variables_bloc.dart';
import 'package:purple_beetle/features/variables/presentation/bloc/variables_state.dart';
import 'package:purple_beetle/features/variables/presentation/widgets/add_variable_button.dart';
import 'package:purple_beetle/features/variables/presentation/widgets/variable_button.dart';

/// A horizontal bar displaying variable buttons and an add variable button.
/// Allows users to access and manage their variables.
class VariablesBar extends StatelessWidget {
  const VariablesBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VariablesBloc, VariablesState>(
      builder: (context, state) {
        return SizedBox(
          height: 50,
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, index) {
              // First item is the add variable button
              if (index == 0) {
                return AddVariableButton();
              }

              // Subsequent items are variable buttons
              final variable = state.variables[index - 1];
              return VariableButton(variable: variable);
            },
            scrollDirection: Axis.horizontal,
            itemCount: state.variables.length + 1,
          ),
        );
      },
    );
  }
}
