import 'app_cases.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:carijob/app.dart';
import 'package:carijob/core/app_state.dart';
import 'package:carijob/data/models.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    final font = FontLoader('Archivo')
      ..addFont(rootBundle.load('assets/fonts/Archivo.ttf'));
    final icons = FontLoader('MaterialIcons')
      ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
    await font.load();
    await icons.load();
  });
  defineAppTests();
  const routes = [
    'splash',
    'onboarding',
    'onboarding/2',
    'onboarding/3',
    'onboarding/4',
    'sign-in',
    'sign-up',
    'categories',
    'experience',
    'skills',
    'forgot-password',
    'verify',
    'reset-password',
    'home',
    'explore',
    'notifications',
    'results',
    'company-results',
    'empty-results',
    'filter',
    'recommended',
    'details',
    'details-more',
    'apply',
    'apply-full',
    'success',
    'opportunities',
    'complete-profile',
    'identity',
    'work-experience',
    'education',
    'personal-skills',
    'my-jobs',
    'rejected',
    'empty-jobs',
    'profile',
    'full-profile',
    'full-profile-more',
    'edit-profile',
    'edit-experience',
    'edit-experience-more',
    'language',
    'security',
    'about',
    'faq',
    'sign-out',
    'saved',
    'empty-saved',
  ];
  for (final route in routes) {
    testWidgets('Screenshot $route', (tester) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final state = AppState()..saved.add('spotify');
      if (route == 'empty-jobs') state.applications.clear();
      if (route == 'empty-saved') state.saved.clear();
      final path = switch (route) {
        'filter' || 'company-results' => 'results',
        'sign-out' => 'profile',
        'empty-jobs' => 'my-jobs',
        'empty-saved' => 'saved',
        _ => route.replaceAll('-more', ''),
      };
      // Warm images before mounting pages, so no pending image Future is
      // shared between the fake test clock and runAsync's real clock.
      await tester.pumpWidget(const MaterialApp(home: SizedBox()));
      PaintingBinding.instance.imageCache.clear();
      PaintingBinding.instance.imageCache.clearLiveImages();
      await tester.runAsync(() async {
        final context = tester.element(find.byType(MaterialApp));
        final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
        for (final asset in manifest.listAssets().where(
          (p) => p.startsWith('assets/images/'),
        )) {
          await precacheImage(AssetImage(asset), context);
        }
      });
      await tester.pumpAndSettle();
      await tester.pumpWidget(
        RepaintBoundary(
          key: const ValueKey('screen'),
          child: CarijobApp(state: state, initialRoute: '/$path'),
        ),
      );
      await tester.pumpAndSettle();
      if (route == 'filter') {
        await tester.tap(find.text('Filter'));
        await tester.pumpAndSettle();
      }
      if (route == 'sign-out') {
        await tester.tap(find.text('Sign Out'));
        await tester.pumpAndSettle();
      }
      if (route == 'company-results') {
        await tester.tap(find.text('Company'));
        await tester.pumpAndSettle();
      }
      if (route.endsWith('-more')) {
        await tester.drag(find.byType(ListView).first, const Offset(0, -1000));
        await tester.pumpAndSettle();
      }
      expect(
        tester.takeException(),
        isNull,
        reason: 'Layout failure on $route',
      );
      await expectLater(
        find.byKey(const ValueKey('screen')),
        matchesGoldenFile(
          '../docs/screenshots/${route.replaceAll('/', '-')}.png',
        ),
      );
    });
  }
  for (final stage in [-1, 0, 1, 2, 3]) {
    testWidgets('Screenshot application stage $stage', (tester) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        RepaintBoundary(
          key: const ValueKey('screen'),
          child: CarijobApp(state: AppState(), initialRoute: '/home'),
        ),
      );
      await tester.pumpAndSettle();
      tester
          .state<NavigatorState>(find.byType(Navigator))
          .pushNamed(
            '/application-details',
            arguments: Application(
              'spotify-product',
              stage < 0 ? 0 : stage,
              DateTime(2026, 10, 6),
              rejected: stage < 0,
            ),
          );
      await tester.pumpAndSettle();
      await tester.runAsync(() async {
        await precacheImage(
          const AssetImage('assets/images/spotify.png'),
          tester.element(find.byType(MaterialApp)),
        );
      });
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await expectLater(
        find.byKey(const ValueKey('screen')),
        matchesGoldenFile('../docs/screenshots/application-$stage.png'),
      );
    });
  }
}
