import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'theme_util.dart';

/// Manages the current theme and color palette
class ThemeProvider extends ChangeNotifier {
  VariableColorPalette _currentPalette = AppColorPalettes.defaultPalette;

  VariableColorPalette get currentPalette => _currentPalette;

  ThemeData get themeData {
    // Map palette to ThemeData
    // For now, return default theme, but you can expand this
    return AppTheme.lightTheme;
  }

  void setTheme(VariableColorPalette palette) {
    _currentPalette = palette;
    notifyListeners();
  }

  // Get color for a variable's slot
  Color getVariableColor(VariableColorSlot slot) {
    return _currentPalette.getColor(slot);
  }
}
