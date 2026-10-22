import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carijob/app.dart';
import 'package:carijob/core/app_state.dart';
import 'package:carijob/data/job_repository.dart';
import 'package:carijob/data/models.dart';

void defineAppTests() {
  test('Search combines keyword, type, location, category and period', () {
    final repository = JobRepository();
    expect(
      repository
          .search(
            'design',
            const JobFilter(type: 'Full-Time', location: 'United States'),
          )
          .map((j) => j.id),
      ['pinterest'],
    );
    expect(repository.search('', const JobFilter(category: 'Music')).length, 2);
    expect(
      repository.search('', const JobFilter(period: 'Past 24 Hours')).single.id,
      'google',
    );
    expect(repository.search('astronaut', const JobFilter()), isEmpty);
  });
  test('Profile, bookmarks and applications survive a restart; no duplicate applications', () async {
    SharedPreferences.setMockInitialValues({});
    final state = await AppState.load();
    state.signedIn = true;
    state.updateProfile({'Name': 'Alex Chen'});
    state.toggleSaved('spotify');
    await state.apply(
      'spotify',
      email: 'alex@example.com',
      phone: '+12345678900',
      resumeName: 'Resume.pdf',
      coverLetter: 'Hello Spotify',
    );
    await state.apply('spotify');
    await state.save();
    final restored = await AppState.load();
    expect(restored.name, 'Alex Chen');
    expect(restored.signedIn, isTrue);
    expect(restored.saved, contains('spotify'));
    expect(restored.applications.where((a) => a.jobId == 'spotify').length, 1);
    final application = restored.applications.first;
    expect(application.resumeName, 'Resume.pdf');
    expect(application.email, 'alex@example.com');
    expect(application.coverLetter, 'Hello Spotify');
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('carijob.v1'), isNot(contains('password')));
  });
  test('Corrupt local JSON falls back to demo data', () async {
    SharedPreferences.setMockInitialValues({'carijob.v1': 'broken'});
    expect((await AppState.load()).name, 'Matt Murdock');
  });
  testWidgets('Sign in validates inputs then opens the home page', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      CarijobApp(state: AppState(), initialRoute: '/sign-in'),
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Sign In'));
    await tester.pumpAndSettle();
    expect(find.text('Please enter Email'), findsOneWidget);
    await tester.enterText(
      find.byType(TextFormField).at(0),
      'alex@example.com',
    );
    await tester.enterText(find.byType(TextFormField).at(1), 'demo123');
    await tester.tap(find.widgetWithText(FilledButton, 'Sign In'));
    await tester.pumpAndSettle();
    expect(find.text('Recommended'), findsOneWidget);
  });
  testWidgets('Apply requires a resume and records a submitted application', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final state = AppState();
    await tester.pumpWidget(CarijobApp(state: state, initialRoute: '/apply'));
    await tester.tap(find.widgetWithText(FilledButton, 'Apply'));
    await tester.pumpAndSettle();
    expect(state.hasApplied('spotify'), isFalse);
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Use demo resume'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Use demo resume'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Apply'));
    await tester.pumpAndSettle();
    expect(state.hasApplied('spotify'), isTrue);
    expect(find.text('Applied Successfully!'), findsOneWidget);
  });
  testWidgets('Browse jobs exits the empty saved list', (tester) async {
    await tester.pumpWidget(
      CarijobApp(state: AppState(), initialRoute: '/saved'),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Browse jobs'));
    await tester.pumpAndSettle();
    expect(find.text('Search Job'), findsOneWidget);
    expect(find.text('No saved jobs yet'), findsNothing);
  });
}
