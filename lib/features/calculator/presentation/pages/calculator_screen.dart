import 'package:flutter/material.dart';
import 'package:purple_beetle/features/calculator/presentation/widgets/keypad.dart';

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      // appBar: AppBar(title: const Text('Calculation Screen')),
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(24.0),
              child: Text('0', style: theme.textTheme.displayLarge),
            ),
          ),
          Divider(),
          Keypad(),
        ],
      ),
    );
  }
}
