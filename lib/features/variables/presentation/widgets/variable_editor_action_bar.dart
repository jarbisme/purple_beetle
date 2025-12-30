import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// The action bar for the variable editor sheet, containing buttons for deleting,
/// picking color, and saving/creating the variable.
class VariableEditorActionBar extends StatelessWidget {
  const VariableEditorActionBar({
    super.key,
    required GlobalKey<FormState> formKey,
    required this.isEditing,
    required this.onSave,
    required this.onDelete,
  });

  final bool isEditing;
  final VoidCallback onSave;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return SafeArea(
      top: false,
      bottom: false,
      child: Container(
        height: 80,
        padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
        child: Row(
          children: [
            SizedBox(
              height: 50,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                  padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                ),
                onPressed: onDelete,
                child: Icon(LucideIcons.trash2, color: theme.iconTheme.color, size: 28),
              ),
            ),
            SizedBox(width: 8),
            // TextButton(
            //   // round button with color picker,
            //   style: TextButton.styleFrom(
            //     shape: CircleBorder(side: BorderSide(color: theme.colorScheme.primary, width: 2)),
            //     padding: EdgeInsets.all(5.0),
            //   ),
            //   onPressed: () {},
            //   child: Container(
            //     width: 40,
            //     height: 40,
            //     // margin: EdgeInsets.all(5),
            //     decoration: BoxDecoration(shape: BoxShape.circle, color: theme.colorScheme.secondary),
            //   ),
            // ),
            Spacer(),
            SizedBox(
              height: 50,
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: theme.colorScheme.primary,
                  padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                ),
                onPressed: onSave,
                child: Text(
                  isEditing ? 'Save' : 'Create',
                  style: theme.textButtonTheme.style?.textStyle
                      ?.resolve({})
                      ?.copyWith(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
