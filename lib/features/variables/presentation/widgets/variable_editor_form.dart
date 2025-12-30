import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:purple_beetle/core/theme/app_colors.dart';
import 'package:purple_beetle/features/variables/presentation/widgets/variable_color_picker.dart';

/// The form widget for creating or editing a variable, including fields for name and value.
class VariableEditorForm extends StatelessWidget {
  const VariableEditorForm({
    super.key,
    required this.isEditing,
    required TextEditingController nameController,
    required TextEditingController valueController,
    required this.selectedColorSlot,
    required this.onColorSlotChanged,
  }) : _nameController = nameController,
       _valueController = valueController;

  final bool isEditing;
  final TextEditingController _nameController;
  final TextEditingController _valueController;
  final VariableColorSlot selectedColorSlot;
  final ValueChanged<VariableColorSlot> onColorSlotChanged;

  @override
  Widget build(BuildContext context) {
    // final themeProvider = ThemeProvider();
    // final palette = themeProvider.currentPalette;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            isEditing ? 'Edit Variable' : 'Create New Variable',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Name'),
            // TODO: improve input formatters and validation
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9_]')),
              LengthLimitingTextInputFormatter(32),
            ],
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Name is required';
              }
              if (!RegExp(r'^[a-zA-Z][a-zA-Z0-9_]*$').hasMatch(value)) {
                return 'Name must start with a letter';
              }
              if (value.length > 32) {
                return 'Name must be 32 characters or less';
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: _valueController,
            decoration: InputDecoration(labelText: 'Value. E.g., 42, 3.14, -7'),
            keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
            // TODO: improve input formatters and validation
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.\-]'))],
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Value is required';
              }
              if (double.tryParse(value.trim()) == null) {
                return 'Please enter a valid number';
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          VariableColorPicker(selectedColorSlot: selectedColorSlot, onColorSlotChanged: onColorSlotChanged),
        ],
      ),
    );
  }
}
