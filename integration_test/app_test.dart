import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration/home_screen.dart';
import 'package:integration/main.dart' as app;
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group(
    'end to end test',
    () {
      testWidgets(
        'verify login screen with correct username and password',
        (tester) async {
          app.main();
          await tester.pumpAndSettle();
          await Future.delayed(const Duration(seconds: 2));
          await tester.enterText(find.byType(TextFormField).at(0), 'username');
          await Future.delayed(const Duration(seconds: 2));
          await tester.enterText(find.byType(TextFormField).at(1), 'password');
          await Future.delayed(const Duration(seconds: 2));
          await tester.tap(find.byType(ElevatedButton));
          await Future.delayed(const Duration(seconds: 2));
          await tester.pumpAndSettle();

          await Future.delayed(const Duration(seconds: 2));
          expect(find.byType(HomeScreen), findsOneWidget);
        },
      );

      testWidgets(
        'verify login screen with incorrect username and password',
        (tester) async {
          app.main();
          await tester.pumpAndSettle();
          await Future.delayed(const Duration(seconds: 2));
          await tester.enterText(find.byType(TextFormField).at(0), 'wronguser');
          await Future.delayed(const Duration(seconds: 2));
          await tester.enterText(
              find.byType(TextFormField).at(1), 'invalidpass');
          await Future.delayed(const Duration(seconds: 2));
          await tester.tap(find.byType(ElevatedButton));
          await Future.delayed(const Duration(seconds: 2));
          await tester.pumpAndSettle();

          await Future.delayed(const Duration(seconds: 2));
          expect(find.text('Invalid username or password'), findsOneWidget);
        },
      );

      // testWidgets(
      //   'FAILING TEST - to see the output',
      //   (tester) async {
      //     app.main();
      //     await tester.pumpAndSettle();
      //     await Future.delayed(const Duration(seconds: 2));
      //     await tester.enterText(find.byType(TextFormField).at(0), 'wronguser');
      //     await Future.delayed(const Duration(seconds: 2));
      //     await tester.enterText(
      //         find.byType(TextFormField).at(1), 'invalidpass');
      //     await Future.delayed(const Duration(seconds: 2));
      //     await tester.tap(find.byType(ElevatedButton));
      //     await Future.delayed(const Duration(seconds: 2));
      //     await tester.pumpAndSettle();

      //     await Future.delayed(const Duration(seconds: 2));
      //     expect(find.byType(HomeScreen), findsOneWidget);
      //   },
      // );
    },
  );
}
