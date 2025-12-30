import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purple_beetle/core/theme/app_colors.dart';
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
  VariableColorSlot? _selectedColorSlot;
  bool _initialized = false;

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
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return BlocBuilder<VariablesBloc, VariablesState>(
      builder: (context, state) {
        final isEditing = state.selectedVariable != null;

        // Initialize the color slot once
        if (!_initialized) {
          if (isEditing) {
            _selectedColorSlot = VariableColorSlot.fromIndex(state.selectedVariable!.color);
            _nameController.text = state.selectedVariable!.name;
            _valueController.text = state.selectedVariable!.value.toString();
          } else {
            _selectedColorSlot = VariableColorSlot.accent1;
          }
          _initialized = true;
        }

        return SafeArea(
          // bottom: false,
          child: Container(
            margin: EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8 + keyboardHeight),
            decoration: BoxDecoration(color: theme.colorScheme.surface, borderRadius: BorderRadius.circular(30)),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
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
                      selectedColorSlot: _selectedColorSlot!,
                      onColorSlotChanged: (slot) {
                        setState(() {
                          _selectedColorSlot = slot;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    Divider(),
                    VariableEditorActionBar(
                      formKey: _formKey,
                      isEditing: isEditing,
                      onSave: () {
                        if (_formKey.currentState!.validate()) {
                          final name = _nameController.text.trim();
                          final value = double.tryParse(_valueController.text.trim()) ?? 0;

                          context.read<VariablesBloc>().add(
                            CreateVariableEvent(name: name, value: value, color: _selectedColorSlot!),
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
