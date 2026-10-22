import 'package:flutter/material.dart';

import '../core/app_state.dart';
import '../core/theme.dart';
import '../shared/widgets.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key, this.step = 0});
  final int step;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 30, 10, 12),
                child: Column(
                  children: [
                    SizedBox(
                      height: constraints.maxHeight * .65,
                      child: _OnboardingArt(step: step),
                    ),
                    const Divider(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '(0${step + 1})',
                          style: const TextStyle(color: Palette.muted),
                        ),
                        const SizedBox(width: 68),
                        Expanded(
                          child: Text(
                            [
                              'Discover opportunities that fit your skills, your ambition and your next chapter.',
                              'Connect with inspiring teams and find a role where you can make a difference.',
                              'Build your profile, show your strengths and move your career forward.',
                              'Your next opportunity starts here. Let’s find it together.',
                            ][step],
                            style: const TextStyle(color: Palette.body),
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                    const SizedBox(height: 26),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () => home(context, '/sign-in'),
                          child: const Text(
                            'Skip',
                            style: TextStyle(color: Palette.muted),
                          ),
                        ),
                        Row(
                          children: List.generate(
                            4,
                            (i) => Container(
                              width: i == step ? 22 : 8,
                              height: 8,
                              margin: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: i == step ? Palette.ink : Palette.line,
                                borderRadius: BorderRadius.circular(9),
                              ),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () => step == 3
                              ? home(context, '/sign-in')
                              : Navigator.pushReplacementNamed(
                                  context,
                                  '/onboarding/${step + 2}',
                                ),
                          child: Text(step == 3 ? 'Start' : 'Next'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _OnboardingArt extends StatelessWidget {
  const _OnboardingArt({required this.step});
  final int step;
  @override
  Widget build(BuildContext context) {
    const titleStyle = TextStyle(fontSize: 58, height: 1.12, letterSpacing: -2);
    return Stack(
      children: [
        if (step == 0) ...[
          const Positioned(
            left: 100,
            top: 12,
            child: Text('Best\nPlatform', style: titleStyle),
          ),
          const Positioned(
            left: 65,
            top: 165,
            child: Art('onboarding-phone', size: 145),
          ),
          const Positioned(
            left: 0,
            top: 280,
            child: Text('for Job', style: titleStyle),
          ),
          Positioned(
            right: 0,
            top: 320,
            child: _icon(Icons.thumb_up_alt_outlined),
          ),
          const Positioned(
            left: 100,
            top: 347,
            child: Text('Hunter', style: titleStyle),
          ),
        ],
        if (step == 1) ...[
          const Positioned(
            left: 0,
            top: 12,
            child: Text('Find Your\nDream Job', style: titleStyle),
          ),
          const Positioned(
            left: 0,
            top: 165,
            child: Image(
              image: AssetImage('assets/images/onboarding-jobs.png'),
              width: 275,
              height: 145,
            ),
          ),
          Positioned(left: 0, top: 322, child: _icon(Icons.work_outline)),
          const Positioned(
            right: 0,
            top: 325,
            child: Text('Right\nHere.', style: titleStyle),
          ),
        ],
        if (step == 2) ...[
          const Positioned(
            left: 0,
            top: 12,
            child: Text('Chase\na Perfect\nCareer\nPath', style: titleStyle),
          ),
          Positioned(right: 0, top: 165, child: _icon(Icons.trending_up)),
          const Positioned(
            right: 0,
            top: 325,
            child: Image(
              image: AssetImage('assets/images/onboarding-career.png'),
              width: 253,
              height: 145,
            ),
          ),
        ],
        if (step == 3) ...[
          const Positioned(
            left: 0,
            top: 12,
            child: Text('Let’s Start\nYour Journey', style: titleStyle),
          ),
          const Positioned(
            left: 0,
            right: 0,
            top: 140,
            child: Art('onboarding-start', size: 340),
          ),
        ],
      ],
    );
  }

  Widget _icon(IconData icon) => Container(
    width: 145,
    height: 145,
    decoration: BoxDecoration(
      color: Palette.green,
      borderRadius: BorderRadius.circular(22),
    ),
    child: Icon(icon, size: 58),
  );
}

class AuthPage extends StatefulWidget {
  const AuthPage({super.key, this.mode = 'sign-in'});
  final String mode;
  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final form = GlobalKey<FormState>();
  final name = TextEditingController(),
      email = TextEditingController(),
      password = TextEditingController(),
      confirm = TextEditingController(),
      code = TextEditingController();
  @override
  void dispose() {
    for (final c in [name, email, password, confirm, code]) {
      c.dispose();
    }
    super.dispose();
  }

  void submit() {
    if (!form.currentState!.validate()) return;
    final mode = widget.mode;
    if (mode == 'forgot-password') {
      go(context, '/verify');
      return;
    }
    if (mode == 'verify') {
      if (code.text != '123456') {
        toast(context, 'Use demo verification code 123456.');
        return;
      }
      go(context, '/reset-password');
      return;
    }
    if (mode == 'reset-password') {
      if (password.text != confirm.text) {
        toast(context, 'Passwords do not match.');
        return;
      }
      toast(context, 'Demo reset completed. No server password was changed.');
      home(context, '/sign-in');
      return;
    }
    final state = AppScope.of(context);
    state.signedIn = true;
    if (mode == 'sign-up') {
      state.updateProfile({
        'Name': name.text.trim(),
        'Email': email.text.trim(),
      });
      state.save();
      home(context, '/categories');
    } else {
      state.email = email.text.trim();
      state.save();
      home(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mode = widget.mode;
    final signin = mode == 'sign-in', signup = mode == 'sign-up';
    final isPassword = signin || signup || mode == 'reset-password';
    final title = switch (mode) {
      'sign-up' => 'Create an account',
      'forgot-password' => 'Forgot Password?',
      'verify' => 'Email Verification',
      'reset-password' => 'Reset Password',
      _ => 'Welcome back!',
    };
    final description = switch (mode) {
      'sign-up' => 'Let’s get you ready for your next opportunity.',
      'forgot-password' => 'Enter your email to start the demo password reset.',
      'verify' => 'Enter the 6-digit code. Demo code: 123456',
      'reset-password' => 'Create a new password for your account.',
      _ => 'Login with your data entered while sign up',
    };
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, c) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: c.maxHeight),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 26),
                child: Form(
                  key: form,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 120,
                        child: Stack(
                          children: [
                            Positioned(
                              right: -20,
                              top: -75,
                              child: Container(
                                width: 140,
                                height: 140,
                                decoration: BoxDecoration(
                                  color: Palette.background,
                                  border: Border.all(
                                    width: 16,
                                    color: Palette.blue,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            Positioned(
                              right: 165,
                              top: -50,
                              child: Container(
                                width: 100,
                                height: 90,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Palette.sand,
                                    width: 10,
                                  ),
                                ),
                              ),
                            ),
                            if (!signin)
                              Positioned(
                                left: 0,
                                top: 15,
                                child: IconButton(
                                  tooltip: 'Back',
                                  onPressed: () => Navigator.canPop(context)
                                      ? Navigator.pop(context)
                                      : home(context, '/sign-in'),
                                  icon: const Icon(Icons.arrow_back),
                                ),
                              ),
                          ],
                        ),
                      ),
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 38,
                          height: 1.15,
                          letterSpacing: -1,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        description,
                        style: const TextStyle(color: Palette.body),
                      ),
                      const SizedBox(height: 38),
                      if (signup) FormFieldTile('Name', controller: name),
                      if (signin || signup || mode == 'forgot-password')
                        FormFieldTile('Email', controller: email, email: true),
                      if (mode == 'verify')
                        TextFormField(
                          controller: code,
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                          style: const TextStyle(
                            fontSize: 28,
                            letterSpacing: 14,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Verification code',
                          ),
                          validator: (v) =>
                              v?.length == 6 ? null : 'Enter all 6 digits',
                        ),
                      if (isPassword)
                        FormFieldTile(
                          mode == 'reset-password'
                              ? 'New Password'
                              : 'Password',
                          controller: password,
                          password: true,
                        ),
                      if (mode == 'reset-password')
                        FormFieldTile(
                          'Confirm Password',
                          controller: confirm,
                          password: true,
                        ),
                      const SizedBox(height: 8),
                      FilledButton(
                        onPressed: submit,
                        child: Text(switch (mode) {
                          'sign-up' => 'Sign Up',
                          'forgot-password' => 'Send Code',
                          'verify' => 'Verify',
                          'reset-password' => 'Reset Password',
                          _ => 'Sign In',
                        }),
                      ),
                      if (signin)
                        Center(
                          child: TextButton(
                            onPressed: () => go(context, '/forgot-password'),
                            child: const Text('Forgot Password?'),
                          ),
                        ),
                      if (mode == 'verify')
                        Center(
                          child: TextButton(
                            onPressed: () => toast(
                              context,
                              'Demo code: 123456. No email has been sent.',
                            ),
                            child: const Text('Resend Code'),
                          ),
                        ),
                      if (signin || signup) ...[
                        const SizedBox(height: 54),
                        const Row(
                          children: [
                            Expanded(child: Divider()),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                'or',
                                style: TextStyle(color: Palette.muted),
                              ),
                            ),
                            Expanded(child: Divider()),
                          ],
                        ),
                        const SizedBox(height: 8),
                        OutlinedButton(
                          onPressed: () => showDialog<void>(
                            context: context,
                            builder: (c) => AlertDialog(
                              title: const Text('Google Sign In'),
                              content: const Text(
                                'This build uses local demo data. Google sign-in requires an OAuth client and a connected backend. Use the demo account to explore the app.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(c),
                                  child: const Text('Close'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(c);
                                    AppScope.of(context)
                                      ..signedIn = true
                                      ..save();
                                    home(context);
                                  },
                                  child: const Text('Try Demo'),
                                ),
                              ],
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Art('google', size: 20),
                              SizedBox(width: 10),
                              Text(
                                'Sign In with Google',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Center(
                          child: TextButton(
                            onPressed: () =>
                                go(context, signin ? '/sign-up' : '/sign-in'),
                            child: Text(
                              signin
                                  ? 'Don’t have an account? Sign Up'
                                  : 'Already have an account? Sign In',
                            ),
                          ),
                        ),
                        Center(
                          child: TextButton(
                            onPressed: () {
                              AppScope.of(context)
                                ..signedIn = true
                                ..save();
                              home(context);
                            },
                            child: const Text(
                              'Explore Demo',
                              style: TextStyle(
                                color: Palette.muted,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SelectionPage extends StatefulWidget {
  const SelectionPage({super.key, required this.kind});
  final String kind;
  @override
  State<SelectionPage> createState() => _SelectionPageState();
}

class _SelectionPageState extends State<SelectionPage> {
  final selected = <String>{};
  bool initialized = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!initialized) {
      final state = AppScope.of(context);
      selected.addAll(
        widget.kind == 'categories'
            ? state.categories
            : widget.kind == 'experience'
            ? {state.level}
            : state.skills,
      );
      initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final kind = widget.kind;
    final experience = kind == 'experience';
    final categories = kind == 'categories';
    final choices = categories
        ? [
            'Design',
            'Technology',
            'Marketing',
            'Finance',
            'Music',
            'Food & Drink',
            'Education',
            'Health',
            'Business',
            'Engineering',
          ]
        : experience
        ? ['Fresh Graduate', 'Junior', 'Intermediate', 'Senior', 'Expert']
        : [
            'Design',
            'Marketing',
            'Layout',
            'Painting',
            'Figma',
            'Flutter',
            'Communication',
            'Prototyping',
            'Research',
            'Leadership',
            'Typography',
            'Illustration',
          ];
    return PageFrame(
      title: categories
          ? 'Select Job Categories'
          : experience
          ? 'Experience'
          : 'Personal Skills',
      background: Colors.white,
      bottom: FilledButton(
        onPressed: selected.isEmpty
            ? null
            : () {
                final state = AppScope.of(context);
                if (categories) {
                  state.categories
                    ..clear()
                    ..addAll(selected);
                } else if (experience) {
                  state.level = selected.first;
                } else {
                  state.skills
                    ..clear()
                    ..addAll(selected);
                }
                state.save();
                if (ModalRoute.of(context)?.settings.arguments == 'edit') {
                  Navigator.pop(context);
                } else if (categories) {
                  go(context, '/experience');
                } else if (experience) {
                  go(context, '/skills');
                } else {
                  home(context);
                }
              },
        child: Text(
          ModalRoute.of(context)?.settings.arguments == 'edit'
              ? 'Save Changes'
              : 'Continue',
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.all(22),
        children: [
          Text(
            categories
                ? 'What kind of job are you looking for?'
                : experience
                ? 'How much experience do you have?'
                : 'Show what makes you stand out.',
            style: const TextStyle(fontSize: 28, height: 1.2),
          ),
          const SizedBox(height: 12),
          const Text(
            'Select the options that best describe you.',
            style: TextStyle(color: Palette.body),
          ),
          const SizedBox(height: 30),
          Wrap(
            spacing: 10,
            runSpacing: 14,
            children: choices
                .map(
                  (v) => FilterChip(
                    label: Text(v),
                    selected: selected.contains(v),
                    selectedColor: Palette.green,
                    backgroundColor: Palette.background,
                    side: BorderSide(
                      color: selected.contains(v)
                          ? Palette.green
                          : Palette.line,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    onSelected: (enabled) => setState(() {
                      if (experience) selected.clear();
                      enabled ? selected.add(v) : selected.remove(v);
                    }),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
