import 'package:flutter/material.dart';
import 'package:purple_beetle/features/calculator/presentation/widgets/calculator_display.dart';
import 'package:purple_beetle/features/calculator/presentation/widgets/keypad.dart';
import 'package:purple_beetle/features/variables/presentation/widgets/variables_bar.dart';

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(children: [CalculatorDisplay(), Divider(height: 24.0), VariablesBar(), Keypad()]),
    );
  }
}
