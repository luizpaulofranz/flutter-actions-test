import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration/home_screen.dart';
import 'package:integration/main.dart' as app;
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // Helper function to wait for elements
  Future<void> waitFor(Finder finder, WidgetTester tester) async {
    final stopwatch = Stopwatch()..start();
    while (stopwatch.elapsed < const Duration(seconds: 10)) {
      await tester.pump(const Duration(milliseconds: 200));
      if (finder.evaluate().isNotEmpty) return;
    }
    throw Exception('Element not found: $finder');
  }

  group('end to end test', () {
    testWidgets('verify login screen with correct username and password',
        (tester) async {
      await tester.runAsync(() async {
        // Launch app
        app.main();
        await tester.pumpAndSettle(const Duration(seconds: 5));

        // Verify initial state
        await waitFor(find.text('Login'), tester);

        // Enter credentials - using keys instead of byType
        final usernameField = find.byKey(const Key('username-field'));
        final passwordField = find.byKey(const Key('password-field'));
        final loginButton = find.byKey(const Key('login-button'));

        await tester.enterText(usernameField, 'username');
        await tester.testTextInput.receiveAction(TextInputAction.next);
        await tester.pump();

        await tester.enterText(passwordField, 'password');
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pump();

        // Submit form
        await tester.tap(loginButton);
        await tester.pumpAndSettle(const Duration(seconds: 5));

        // Verify navigation
        await waitFor(find.byType(HomeScreen), tester);
      });
    });

    testWidgets('verify login screen with incorrect username and password',
        (tester) async {
      await tester.runAsync(() async {
        app.main();
        await tester.pumpAndSettle(const Duration(seconds: 5));

        final usernameField = find.byKey(const Key('username-field'));
        final passwordField = find.byKey(const Key('password-field'));
        final loginButton = find.byKey(const Key('login-button'));

        await tester.enterText(usernameField, 'wronguser');
        await tester.testTextInput.receiveAction(TextInputAction.next);
        await tester.pump();

        await tester.enterText(passwordField, 'invalidpass');
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pump();

        await tester.tap(loginButton);
        await tester.pumpAndSettle(const Duration(seconds: 5));

        await waitFor(find.text('Invalid username or password'), tester);
      });
    });
  });
}
