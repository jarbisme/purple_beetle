import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:purple_beetle/core/theme/app_colors.dart';
import 'package:purple_beetle/core/theme/theme_provider.dart';
import 'package:purple_beetle/features/calculator/domain/entities/expression.dart';
import 'package:purple_beetle/features/calculator/presentation/bloc/calculator_bloc.dart';
import 'package:purple_beetle/features/calculator/presentation/bloc/calculator_event.dart';
import 'package:purple_beetle/features/calculator/presentation/widgets/blinking_cursor.dart';
import 'package:purple_beetle/features/variables/domain/entities/variable.dart';
import 'package:purple_beetle/features/variables/presentation/bloc/variables_bloc.dart';
import 'package:purple_beetle/features/variables/presentation/bloc/variables_state.dart';

/// Represents where the cursor should be positioned relative to a token
/// [none] means no cursor at this token
/// [before] means cursor before this token
/// [after] means cursor after this token
enum CursorPosition { none, before, after }

/// Widget to display a single token in the expression editor, with optional cursor overlay
/// [tokenIndex] is the index of this token in the expression
/// [token] is the expression token to display
/// [cursorPosition] indicates where to draw the cursor relative to the token
/// [cursorKey] is used to identify the cursor widget for scrolling purposes
class ExpressionTokenItem extends StatelessWidget {
  final ExpressionToken token;
  final int tokenIndex;
  final CursorPosition cursorPosition;
  final GlobalKey? cursorKey;

  const ExpressionTokenItem({
    super.key,
    required this.token,
    required this.tokenIndex,
    required this.cursorPosition,
    this.cursorKey,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Widget tokenWidget = _buildTokenWidget(token, theme);

    tokenWidget = Center(child: tokenWidget);

    // Overlay the blinking cursor if needed
    if (cursorPosition != CursorPosition.none) {
      tokenWidget = Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          tokenWidget,
          Positioned(
            left: cursorPosition == CursorPosition.before ? 0 : null,
            right: cursorPosition == CursorPosition.after ? 0 : null,
            child: BlinkingCursor(key: cursorKey),
          ),
        ],
      );
    }

    // Wrap with GestureDetector to handle taps for moving the cursor
    return Builder(
      builder: (context) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapUp: (details) {
            // Get the local position of the tap
            final RenderBox box = context.findRenderObject() as RenderBox;
            final localDx = box.globalToLocal(details.globalPosition).dx;

            // Decide position based on tap location
            final newPosition = (localDx < box.size.width / 2) ? tokenIndex : tokenIndex + 1;
            context.read<CalculatorBloc>().add(MoveCursorEvent(newPosition));
          },
          child: tokenWidget,
        );
      },
    );
  }
}

// Helper to build the widget for each token type
Widget _buildTokenWidget(ExpressionToken token, ThemeData theme) {
  if (token is DigitToken) {
    return Transform.translate(
      offset: const Offset(0, 1.0),
      child: Text(token.value.toString(), style: theme.textTheme.headlineMedium),
    );
  }

  if (token is OperatorToken) {
    Widget icon;
    switch (token.operator) {
      case '*':
        icon = const Icon(LucideIcons.x, size: 20);
        break;
      case '/':
        icon = const Icon(LucideIcons.divide, size: 20);
        break;
      case '%':
        icon = const Icon(LucideIcons.percent, size: 20);
        break;
      case '+':
        icon = const Icon(LucideIcons.plus, size: 20);
        break;
      case '-':
        icon = const Icon(LucideIcons.minus, size: 20);
        break;
      default:
        return const SizedBox.shrink();
    }
    // add padding around operators
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Transform.translate(offset: const Offset(0, 0), child: icon),
    );
  }

  if (token is ParenthesisToken) {
    // add padding around parentheses
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Transform.translate(
        offset: const Offset(0, -1), // Nudge the parenthesis up
        child: Text(
          token.parenthesis,
          style: theme.textTheme.headlineMedium?.copyWith(color: theme.colorScheme.primary),
        ),
      ),
    );
  }

  if (token is DecimalPointToken) {
    return Text('.', style: theme.textTheme.headlineMedium);
  }

  if (token is VariableToken) {
    // TODO: Refactor to avoid duplicating themeProvider code
    final ThemeProvider themeProvider = ThemeProvider();
    final palette = themeProvider.currentPalette;

    // Fetch variable details from VariablesBloc
    return BlocBuilder<VariablesBloc, VariablesState>(
      builder: (context, variablesState) {
        final variable = variablesState.variables.firstWhere(
          (varItem) => varItem.id == token.variableId,
          orElse: () => Variable(id: token.variableId, name: 'unknown', value: 0, color: Colors.grey.toARGB32()),
        );

        final variableColor = palette.getColor(VariableColorSlot.values[variable.color]);

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 3.0),
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          decoration: BoxDecoration(
            color: variableColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(7.0),
          ),
          child: Text(
            variable.name,
            style: theme.textTheme.titleMedium?.copyWith(color: variableColor, fontWeight: FontWeight.bold),
          ),
        );
      },
    );
  }

  return const SizedBox.shrink();
}
