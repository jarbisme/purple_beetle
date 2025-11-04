import 'package:flutter/material.dart';
import 'package:purple_beetle/features/calculator/presentation/widgets/calculator_display.dart';
import 'package:purple_beetle/features/calculator/presentation/widgets/keypad.dart';

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('Calculation Screen')),
      body: Column(children: [CalculatorDisplay(), Divider(), Keypad()]),
    );
  }
}
