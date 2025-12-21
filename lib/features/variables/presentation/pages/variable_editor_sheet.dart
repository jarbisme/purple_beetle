import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purple_beetle/features/variables/presentation/bloc/variables_bloc.dart';
import 'package:purple_beetle/features/variables/presentation/bloc/variables_event.dart';
import 'package:purple_beetle/features/variables/presentation/bloc/variables_state.dart';
import 'package:purple_beetle/features/variables/presentation/widgets/variable_editor_action_bar.dart';
import 'package:purple_beetle/features/variables/presentation/widgets/variable_editor_form.dart';

/// A bottom sheet widget for creating or editing a variable.
class VariableEditorSheet extends StatefulWidget {
  const VariableEditorSheet({super.key});

  @override
  State<VariableEditorSheet> createState() => _VariableEditorSheetState();
}

class _VariableEditorSheetState extends State<VariableEditorSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _valueController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _valueController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<VariablesBloc, VariablesState>(
      builder: (context, state) {
        final isEditing = state.selectedVariable != null;

        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              padding: EdgeInsets.all(0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Divider(
                        thickness: 5,
                        color: theme.colorScheme.primary.withValues(alpha: 0.3),
                        indent: 160,
                        endIndent: 160,
                        radius: BorderRadius.circular(3),
                      ),
                    ),
                    VariableEditorForm(
                      isEditing: isEditing,
                      nameController: _nameController,
                      valueController: _valueController,
                    ),
                    SizedBox(height: 16),
                    VariableEditorActionBar(
                      formKey: _formKey,
                      isEditing: isEditing,
                      onSave: () {
                        if (_formKey.currentState!.validate()) {
                          // Save variable logic here
                          final name = _nameController.text.trim();
                          final value = double.tryParse(_valueController.text.trim()) ?? 0;

                          context.read<VariablesBloc>().add(
                            CreateVariable(name: name, value: value, color: Colors.blue),
                          );
                          Navigator.of(context).pop();
                        }
                      },
                      onDelete: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
