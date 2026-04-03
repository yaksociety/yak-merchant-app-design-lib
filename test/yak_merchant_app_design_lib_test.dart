import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yak_merchant_app_design_lib/yak_merchant_app_design_lib.dart';

void main() {
  group('YakButton - primary', () {
    testWidgets('renders with text', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: YakButton(
              text: 'Test Button',
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('Test Button'), findsOneWidget);
    });

    testWidgets('calls onPressed when tapped', (WidgetTester tester) async {
      bool pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: YakButton(
              text: 'Test Button',
              onPressed: () {
                pressed = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Test Button'));
      expect(pressed, true);
    });

    testWidgets('is disabled when disabled is true', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: YakButton(
              text: 'Test Button',
              disabled: true,
            ),
          ),
        ),
      );

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('shows loading indicator when isLoading is true', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: YakButton(
              text: 'Test Button',
              isLoading: true,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Test Button'), findsNothing);
    });

    testWidgets('renders with left and right icons', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: YakButton(
              text: 'Test Button',
              leftIcon: const Icon(Icons.check),
              rightIcon: const Icon(Icons.arrow_forward),
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.check), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
      expect(find.text('Test Button'), findsOneWidget);
    });
  });

  group('YakButton - secondary & ghost', () {
    testWidgets('secondary renders as OutlinedButton', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: YakButton(
              text: 'Secondary',
              variant: YakButtonVariant.secondary,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('Secondary'), findsOneWidget);
      expect(find.byType(OutlinedButton), findsOneWidget);
    });

    testWidgets('ghost renders as TextButton', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: YakButton(
              text: 'Ghost',
              variant: YakButtonVariant.ghost,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('Ghost'), findsOneWidget);
      expect(find.byType(TextButton), findsOneWidget);
    });
  });

  group('YakButton - icon', () {
    testWidgets('renders icon-only button', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: YakButton(
              text: '',
              icon: Icons.favorite,
              variant: YakButtonVariant.icon,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.favorite), findsOneWidget);
    });
  });

  group('YakButton - floating', () {
    testWidgets('renders regular FAB with icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            floatingActionButton: YakButton(
              text: '',
              icon: Icons.add,
              variant: YakButtonVariant.floating,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('renders extended FAB with label', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            floatingActionButton: YakButton(
              text: 'Edit',
              icon: Icons.edit,
              variant: YakButtonVariant.floating,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('Edit'), findsOneWidget);
      expect(find.byIcon(Icons.edit), findsOneWidget);
    });
  });

  group('YakToggleButton', () {
    testWidgets('renders with initial value', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: YakToggleButton(
              value: false,
              onChanged: (value) {},
            ),
          ),
        ),
      );

      expect(find.byType(Switch), findsOneWidget);
    });

    testWidgets('calls onChanged when toggled', (WidgetTester tester) async {
      bool toggleValue = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return YakToggleButton(
                  value: toggleValue,
                  onChanged: (value) {
                    setState(() {
                      toggleValue = value;
                    });
                  },
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      expect(toggleValue, true);
    });

    testWidgets('calls onChanged when label is tapped', (WidgetTester tester) async {
      bool toggleValue = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return YakToggleButton(
                  value: toggleValue,
                  label: 'Notifications',
                  onChanged: (value) {
                    setState(() {
                      toggleValue = value;
                    });
                  },
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Notifications'));
      await tester.pumpAndSettle();

      expect(toggleValue, true);
    });
  });
}

