import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:purple_beetle/core/theme/app_colors.dart';
import 'package:purple_beetle/core/theme/theme_provider.dart';

class VariableColorPicker extends StatelessWidget {
  final VariableColorSlot selectedColorSlot;
  final ValueChanged<VariableColorSlot> onColorSlotChanged;

  const VariableColorPicker({super.key, required this.selectedColorSlot, required this.onColorSlotChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.all(16.0),
      // // margin: EdgeInsets.symmetric(horizontal: 16.0),
      // decoration: BoxDecoration(
      //   color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
      //   borderRadius: BorderRadius.circular(10.0),
      // ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final colors = VariableColorSlot.values;
          final halfLength = (colors.length / 2).ceil();
          final firstRow = colors.take(halfLength).toList();
          final secondRow = colors.skip(halfLength).toList();

          return Column(
            children: [
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: firstRow
                    .map((slot) => _buildColorButton(context, slot, constraints.maxWidth, firstRow.length))
                    .toList(),
              ),
              SizedBox(height: 12),
              Row(
                children: secondRow
                    .map((slot) => _buildColorButton(context, slot, constraints.maxWidth, secondRow.length))
                    .toList(),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildColorButton(BuildContext context, VariableColorSlot slot, double containerWidth, int itemsInRow) {
    // TODO: Refactor to avoid duplicating themeProvider code
    final themeProvider = ThemeProvider();
    final palette = themeProvider.currentPalette;
    final color = palette.getColor(slot);
    final isSelected = slot == selectedColorSlot;
    final spacing = 12.0;
    final totalSpacing = spacing * (itemsInRow - 1);
    final buttonSize = (containerWidth - totalSpacing) / itemsInRow;

    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(right: 0),
        child: GestureDetector(
          onTap: () => onColorSlotChanged(slot),
          child: Container(
            height: buttonSize,
            padding: EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              // color: color,
              color: Colors.transparent,
              shape: BoxShape.circle,
              border: isSelected ? Border.all(color: color, width: 3) : null,
              // boxShadow: isSelected
              //     ? [BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: 8, spreadRadius: 2)]
              //     : null,
            ),
            child: Container(
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              // child: isSelected ? Icon(LucideIcons.check, color: Colors.white, size: buttonSize * 0.5) : null,
            ),
          ),
        ),
      ),
    );
  }
}
