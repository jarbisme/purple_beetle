import 'package:flutter_test/flutter_test.dart';
import 'package:purple_beetle/features/calculator/domain/entities/expression.dart';
import 'package:purple_beetle/features/calculator/domain/usecases/evaluate_expression.dart';

void main() {
  late EvaluateExpression evaluateExpression;

  setUp(() {
    evaluateExpression = EvaluateExpression();
  });

  group('EvaluateExpression -', () {
    group('Percentage Operations -', () {
      test('multiplication with percentage (2*50%) should return 1', () {
        // Arrange
        final expression = Expression([
          DigitToken(2),
          OperatorToken('*'),
          DigitToken(5),
          DigitToken(0),
          OperatorToken('%'),
        ]);

        // Act
        final result = evaluateExpression(expression: expression);

        // Assert
        expect(result, '1');
      });

      test('subtraction with percentage (200-10%) should return 180', () {
        final expression = Expression([
          DigitToken(2),
          DigitToken(0),
          DigitToken(0),
          OperatorToken('-'),
          DigitToken(1),
          DigitToken(0),
          OperatorToken('%'),
        ]);

        final result = evaluateExpression(expression: expression);

        expect(result, '180');
      });

      test('complex expression (100-2*50%) should return 99', () {
        final expression = Expression([
          DigitToken(1),
          DigitToken(0),
          DigitToken(0),
          OperatorToken('-'),
          DigitToken(2),
          OperatorToken('*'),
          DigitToken(5),
          DigitToken(0),
          OperatorToken('%'),
        ]);

        final result = evaluateExpression(expression: expression);

        expect(result, '99');
      });

      test('Another more complex expression (100-2*50%+15%) should return 113.85', () {
        final expression = Expression([
          DigitToken(1),
          DigitToken(0),
          DigitToken(0),
          OperatorToken('-'),
          DigitToken(2),
          OperatorToken('*'),
          DigitToken(5),
          DigitToken(0),
          OperatorToken('%'),
          OperatorToken('+'),
          DigitToken(1),
          DigitToken(5),
          OperatorToken('%'),
        ]);

        final result = evaluateExpression(expression: expression);

        expect(result, '113.85');
      });
    });

    group('Basic Operations -', () {
      test('simple addition (2+3) should return 5', () {
        final expression = Expression([DigitToken(2), OperatorToken('+'), DigitToken(3)]);

        final result = evaluateExpression(expression: expression);

        expect(result, '5');
      });

      test('implicit multiplication 5(2+3) should return 25', () {
        final expression = Expression([
          DigitToken(5),
          ParenthesisToken('('),
          DigitToken(2),
          OperatorToken('+'),
          DigitToken(3),
          ParenthesisToken(')'),
        ]);

        final result = evaluateExpression(expression: expression);

        expect(result, '25');
      });

      test('nested parentheses ((1+2)*(3+4)) should return 21', () {
        final expression = Expression([
          ParenthesisToken('('),
          ParenthesisToken('('),
          DigitToken(1),
          OperatorToken('+'),
          DigitToken(2),
          ParenthesisToken(')'),
          OperatorToken('*'),
          ParenthesisToken('('),
          DigitToken(3),
          OperatorToken('+'),
          DigitToken(4),
          ParenthesisToken(')'),
          ParenthesisToken(')'),
        ]);

        final result = evaluateExpression(expression: expression);

        expect(result, '21');
      });
    });

    group('Paranthesis Handling -', () {
      test('unmatched opening parenthesis (2+3 should return 5', () {
        final expression = Expression([ParenthesisToken('('), DigitToken(2), OperatorToken('+'), DigitToken(3)]);

        final result = evaluateExpression(expression: expression);

        expect(result, '5');
      });

      test('unmatched closing parenthesis 2+3) should return 5', () {
        final expression = Expression([DigitToken(2), OperatorToken('+'), DigitToken(3), ParenthesisToken(')')]);

        final result = evaluateExpression(expression: expression);

        expect(result, '5');
      });

      test('unbalanced nested parentheses should be balanced and evaluated. ((1+2)*3', () {
        final expression = Expression([
          ParenthesisToken('('),
          ParenthesisToken('('),
          DigitToken(1),
          OperatorToken('+'),
          DigitToken(2),
          ParenthesisToken(')'),
          OperatorToken('*'),
          DigitToken(3),
        ]);

        final result = evaluateExpression(expression: expression);

        expect(result, '9');
      });

      test('more complex unbalanced nested parentheses should be balanced and evaluated. (2+(3*4', () {
        final expression = Expression([
          ParenthesisToken('('),
          DigitToken(2),
          OperatorToken('+'),
          ParenthesisToken('('),
          DigitToken(3),
          OperatorToken('*'),
          DigitToken(4),
        ]);

        final result = evaluateExpression(expression: expression);

        expect(result, '14');
      });
    });

    group('Edge Cases -', () {
      test('empty expression should return 0', () {
        final expression = Expression([]);

        final result = evaluateExpression(expression: expression);

        expect(result, '0');
      });

      test('trailing operator should be removed', () {
        final expression = Expression([DigitToken(1), DigitToken(2), OperatorToken('+')]);

        final result = evaluateExpression(expression: expression);

        expect(result, '12');
      });

      test('division by zero should return Error', () {
        final expression = Expression([DigitToken(1), OperatorToken('/'), DigitToken(0)]);

        final result = evaluateExpression(expression: expression);

        expect(result, 'Error');
      });
    });
  });
}
