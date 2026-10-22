import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carijob/app.dart';
import 'package:carijob/core/app_state.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Search, filter, bookmark, apply and edit profile on Android', (
    tester,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final state = AppState(preferences: prefs);
    await tester.pumpWidget(CarijobApp(state: state, initialRoute: '/sign-in'));
    await tester.pumpAndSettle();
    await binding.convertFlutterSurfaceToImage();
    await tester.pump();
    Future<void> capture(String name) async {
      await tester.pumpAndSettle();
      await binding.takeScreenshot(name);
    }

    await capture('01-sign-in');
    await tester.ensureVisible(find.text('Explore Demo'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Explore Demo'));
    await tester.pumpAndSettle();
    expect(find.text('Recommended'), findsOneWidget);
    await capture('02-home');
    await tester.tap(find.byKey(const ValueKey('tab-1')));
    await tester.pumpAndSettle();
    await capture('03-explore');
    await tester.tap(find.widgetWithText(FilledButton, 'Search Job'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Filter'));
    await tester.pumpAndSettle();
    await capture('04-filter');
    await tester.tap(find.text('Part-Time'));
    await tester.tap(find.text('Apply Filter'));
    await tester.pumpAndSettle();
    expect(find.text('Brand Strategist'), findsOneWidget);
    await capture('05-results');
    await tester.tap(find.text('Brand Strategist'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Save job'));
    await tester.pumpAndSettle();
    expect(state.saved, contains('twitter'));
    await capture('06-details');
    await tester.tap(find.widgetWithText(FilledButton, 'Apply'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Use demo resume'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Use demo resume'));
    await tester.pumpAndSettle();
    await capture('07-apply');
    await tester.tap(find.widgetWithText(FilledButton, 'Apply'));
    await tester.pumpAndSettle();
    expect(find.text('Applied Successfully!'), findsOneWidget);
    await capture('08-success');
    await tester.tap(find.text('View My Application'));
    await tester.pumpAndSettle();
    expect(find.text('Brand Strategist'), findsOneWidget);
    await capture('09-my-jobs');
    await tester.tap(find.byKey(const ValueKey('tab-3')));
    await tester.pumpAndSettle();
    await capture('10-profile');
    await tester.tap(find.text('See Full Profile'));
    await tester.pumpAndSettle();
    await capture('11-full-profile');
    await tester.tap(find.byTooltip('Edit Profile'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, 'Alex Chen');
    await tester.tap(find.text('Save Changes'));
    await tester.pumpAndSettle();
    expect(state.name, 'Alex Chen');
    await state.save();
    final restored = await AppState.load();
    expect(restored.name, 'Alex Chen');
    expect(restored.signedIn, isTrue);
    expect(restored.saved, contains('twitter'));
    expect(restored.hasApplied('twitter'), isTrue);
    expect(tester.takeException(), isNull);
    state.name = 'Matt Murdock';
    await state.save();
  });
}
