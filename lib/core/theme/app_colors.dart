import 'package:flutter/material.dart';

/// Semantic color slots that remain consistent across themes
enum VariableColorSlot {
  accent1,
  accent2,
  accent3,
  accent4,
  accent5,
  accent6,
  accent7,
  accent8,
  accent9,
  accent10,
  accent11,
  accent12;

  static VariableColorSlot fromIndex(int index) => VariableColorSlot.values[index];
}

/// A color palettte for variables in a specific theme
class VariableColorPalette {
  final String name;
  final Map<VariableColorSlot, Color> colors;

  VariableColorPalette({required this.name, required this.colors});

  Color getColor(VariableColorSlot slot) => colors[slot]!;
}

/// Defines all available color palettes for different themes
class AppColorPalettes {
  static final lightPalette = VariableColorPalette(
    name: 'Light Palette',
    colors: {
      VariableColorSlot.accent1: Colors.red.shade300,
      VariableColorSlot.accent2: Colors.orange.shade300,
      VariableColorSlot.accent3: Colors.yellow.shade300,
      VariableColorSlot.accent4: Colors.green.shade300,
      VariableColorSlot.accent5: Colors.blue.shade300,
      VariableColorSlot.accent6: Colors.indigo.shade300,
      VariableColorSlot.accent7: Colors.purple.shade300,
      VariableColorSlot.accent8: Colors.pink.shade300,
      VariableColorSlot.accent9: Colors.teal.shade300,
      VariableColorSlot.accent10: Colors.cyan.shade300,
      VariableColorSlot.accent11: Colors.lime.shade300,
      VariableColorSlot.accent12: Colors.amber.shade300,
    },
  );

  static final darkPalette = VariableColorPalette(
    name: 'Dark Palette',
    colors: {
      VariableColorSlot.accent1: Colors.red.shade700,
      VariableColorSlot.accent2: Colors.orange.shade700,
      VariableColorSlot.accent3: Colors.yellow.shade700,
      VariableColorSlot.accent4: Colors.green.shade700,
      VariableColorSlot.accent5: Colors.blue.shade700,
      VariableColorSlot.accent6: Colors.indigo.shade700,
      VariableColorSlot.accent7: Colors.purple.shade700,
      VariableColorSlot.accent8: Colors.pink.shade700,
      VariableColorSlot.accent9: Colors.teal.shade700,
      VariableColorSlot.accent10: Colors.cyan.shade700,
      VariableColorSlot.accent11: Colors.lime.shade700,
      VariableColorSlot.accent12: Colors.amber.shade700,
    },
  );

  // List of all available palettes
  static final List<VariableColorPalette> allPalettes = [lightPalette, darkPalette];

  // Default palette
  static final VariableColorPalette defaultPalette = lightPalette;
}
