import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purple_beetle/features/variables/presentation/bloc/variables_bloc.dart';
import 'package:purple_beetle/features/variables/presentation/pages/variable_editor_sheet.dart';

/// The static button to add a new variable, shown as the first item in the VariablesBar.
class AddVariableButton extends StatelessWidget {
  const AddVariableButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: SizedBox(
        // height: 50,
        child: TextButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              builder: (_) {
                return BlocProvider.value(
                  value: BlocProvider.of<VariablesBloc>(context),
                  child: const VariableEditorSheet(),
                );
              },
              isScrollControlled: true,
              isDismissible: true,
              useSafeArea: true,
            );
          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.transparent,

            padding: EdgeInsets.symmetric(horizontal: 16.0),
            shape: RoundedRectangleBorder(
              side: BorderSide(color: theme.colorScheme.primary, width: 2),
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Text(
            'var',
            style: theme.textButtonTheme.style?.textStyle
                ?.resolve({})
                ?.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
