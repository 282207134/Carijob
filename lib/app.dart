import 'package:flutter/material.dart';

import 'core/app_state.dart';
import 'core/theme.dart';
import 'data/job_repository.dart';
import 'data/models.dart';
import 'features/auth.dart';
import 'features/discovery.dart';
import 'features/jobs.dart';
import 'features/profile.dart';
import 'features/shell.dart';
import 'shared/widgets.dart';

class CarijobApp extends StatelessWidget {
  const CarijobApp({super.key, required this.state, this.initialRoute});
  final AppState state;
  final String? initialRoute;
  @override
  Widget build(BuildContext context) => AppScope(
    state: state,
    child: MaterialApp(
      title: 'Carijob',
      debugShowCheckedModeBanner: false,
      theme: appTheme(),
      builder: (context, child) {
        final media = MediaQuery.of(context);
        return Container(
          color: Palette.background,
          alignment: Alignment.center,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: MediaQuery(
              data: media.copyWith(
                size: Size(
                  media.size.width.clamp(0.0, 600.0),
                  media.size.height,
                ),
              ),
              child: child!,
            ),
          ),
        );
      },
      initialRoute: initialRoute ?? (state.signedIn ? '/home' : '/onboarding'),
      onGenerateInitialRoutes: (route) => [_route(RouteSettings(name: route))],
      onGenerateRoute: _route,
    ),
  );
  Route<dynamic> _route(RouteSettings settings) {
    final path = settings.name ?? '/home';
    final args = settings.arguments;
    final job = args is Job ? args : JobRepository.jobs[1];
    final page = switch (path) {
      '/splash' => const _SplashPage(),
      '/onboarding' => const OnboardingPage(),
      '/onboarding/2' => const OnboardingPage(step: 1),
      '/onboarding/3' => const OnboardingPage(step: 2),
      '/onboarding/4' => const OnboardingPage(step: 3),
      '/sign-in' ||
      '/sign-up' ||
      '/forgot-password' ||
      '/verify' ||
      '/reset-password' => AuthPage(mode: path.substring(1)),
      '/categories' => const SelectionPage(kind: 'categories'),
      '/experience' => const SelectionPage(kind: 'experience'),
      '/skills' || '/personal-skills' => const SelectionPage(kind: 'skills'),
      '/home' => const AppShell(),
      '/explore' => const AppShell(initialIndex: 1),
      '/my-jobs' => const AppShell(initialIndex: 2),
      '/rejected' => const AppShell(initialIndex: 2, rejected: true),
      '/profile' => const AppShell(initialIndex: 3),
      '/notifications' => const NotificationsPage(),
      '/recommended' => const ResultsPage(title: 'Recommended Job'),
      '/saved' => const ResultsPage(title: 'Saved Jobs'),
      '/results' => ResultsPage(
        query: args is SearchRequest ? args.query : args as String? ?? '',
        filter: args is SearchRequest ? args.filter : const JobFilter(),
      ),
      '/empty-results' => const ResultsPage(query: 'Astronaut'),
      '/details' => JobDetailsPage(job: job),
      '/apply' => ApplyPage(job: job),
      '/apply-full' => ApplyPage(job: job, full: true),
      '/success' => SuccessPage(job: job),
      '/application-details' => ApplicationDetailsPage(
        application: args is Application
            ? args
            : state.applications.isNotEmpty
            ? state.applications.first
            : Application('spotify', 0, DateTime.now()),
      ),
      '/opportunities' => ResultsPage(
        query: args as String? ?? 'Spotify',
        title: 'Opportunities',
      ),
      '/complete-profile' => const CompleteProfilePage(),
      '/full-profile' => const FullProfilePage(),
      '/edit-profile' => const ProfileFormPage(),
      '/identity' => const ProfileFormPage(kind: 'identity'),
      '/work-experience' => const ProfileFormPage(kind: 'work'),
      '/education' => const ProfileFormPage(kind: 'education'),
      '/edit-experience' => const ProfileFormPage(kind: 'experiences'),
      '/language' => const LanguagePage(),
      '/security' => const SecurityPage(),
      '/about' => const AboutPage(),
      '/faq' => const FaqPage(),
      _ => const AppShell(),
    };
    return MaterialPageRoute<void>(settings: settings, builder: (_) => page);
  }
}

class _SplashPage extends StatelessWidget {
  const _SplashPage();
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Palette.blue,
    body: InkWell(
      onTap: () => home(context, '/onboarding'),
      child: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Art('carijob-logo', size: 92),
            SizedBox(height: 18),
            Text('Carijob', style: TextStyle(fontSize: 48, letterSpacing: -2)),
            Text(
              'Your next chapter starts here.',
              style: TextStyle(color: Palette.body),
            ),
          ],
        ),
      ),
    ),
  );
}
