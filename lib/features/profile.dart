import 'package:flutter/material.dart';

import '../core/app_state.dart';
import '../core/theme.dart';
import '../shared/widgets.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return ListView(
      padding: const EdgeInsets.all(10),
      children: [
        Container(
          height: 300,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Palette.blue,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 80,
                left: -40,
                child: Transform.rotate(
                  angle: -.13,
                  child: Text(
                    '${state.name} ${state.name}',
                    style: TextStyle(
                      fontSize: 40,
                      color: Palette.ink.withValues(alpha: .10),
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 6),
                    ),
                    child: const Art('avatar-large', size: 90),
                  ),
                  const SizedBox(height: 12),
                  Text(state.name, style: const TextStyle(fontSize: 24)),
                  Text(
                    state.email,
                    style: const TextStyle(fontSize: 14, color: Palette.body),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: 140,
                    height: 38,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Palette.muted),
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: () => go(context, '/full-profile'),
                      child: const Text(
                        'See Full Profile',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Panel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'General',
                style: TextStyle(color: Palette.muted, fontSize: 14),
              ),
              _row(context, Icons.language, 'Language', '/language'),
              const Divider(height: 1),
              SizedBox(
                height: 48,
                child: Row(
                  children: [
                    const Icon(
                      Icons.notifications,
                      size: 21,
                      color: Palette.sand,
                    ),
                    const SizedBox(width: 10),
                    const Expanded(child: Text('Allow Notification')),
                    Switch(
                      value: state.notifications,
                      onChanged: (v) {
                        state.notifications = v;
                        state.save();
                      },
                      activeTrackColor: Palette.green,
                      thumbColor: const WidgetStatePropertyAll(Colors.white),
                      trackOutlineColor: const WidgetStatePropertyAll(
                        Colors.transparent,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              _row(context, Icons.lock, 'Security', '/security'),
              const Divider(height: 1),
              _row(context, Icons.logout, 'Sign Out', '/sign-out', red: true),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Panel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Support',
                style: TextStyle(color: Palette.muted, fontSize: 14),
              ),
              _row(context, Icons.people, 'About Us', '/about'),
              const Divider(height: 1),
              _row(context, Icons.help, 'FAQ', '/faq'),
            ],
          ),
        ),
        const SizedBox(height: 14),
        TextButton.icon(
          onPressed: () => go(context, '/saved'),
          icon: const Icon(Icons.bookmark_border),
          label: const Text('Saved Jobs'),
        ),
      ],
    );
  }

  Widget _row(
    BuildContext context,
    IconData icon,
    String text,
    String route, {
    bool red = false,
  }) => InkWell(
    onTap: () =>
        route == '/sign-out' ? showSignOut(context) : go(context, route),
    child: SizedBox(
      height: 48,
      child: Row(
        children: [
          Icon(icon, size: 21, color: red ? Colors.red : Palette.sand),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: red ? Colors.red : Palette.ink),
            ),
          ),
          Icon(Icons.chevron_right, color: red ? Colors.red : Palette.line),
        ],
      ),
    ),
  );
}

Future<void> showSignOut(BuildContext context) => showModalBottomSheet<void>(
  context: context,
  backgroundColor: Colors.white,
  builder: (c) => const SignOutSheet(),
);

class SignOutSheet extends StatelessWidget {
  const SignOutSheet({super.key});
  @override
  Widget build(BuildContext context) => SafeArea(
    child: Padding(
      padding: const EdgeInsets.all(22),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Are you sure want to sign out?',
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 10),
          const Text(
            'Your saved jobs and profile will remain on this device.',
            style: TextStyle(color: Palette.body),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.canPop(context)
                      ? Navigator.pop(context)
                      : home(context, '/profile'),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    AppScope.of(context)
                      ..signedIn = false
                      ..save();
                    home(context, '/sign-in');
                  },
                  child: const Text('Sign Out'),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

class FullProfilePage extends StatelessWidget {
  const FullProfilePage({super.key});
  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    return PageFrame(
      title: 'My Profile',
      actions: [
        IconButton(
          tooltip: 'Edit Profile',
          onPressed: () => go(context, '/edit-profile'),
          icon: const Icon(Icons.edit_outlined),
        ),
      ],
      child: ListView(
        padding: const EdgeInsets.all(22),
        children: [
          Center(
            child: Column(
              children: [
                const Art('avatar-large', size: 90),
                const SizedBox(height: 12),
                Text(s.name, style: const TextStyle(fontSize: 28)),
                Text(s.workTitle, style: const TextStyle(color: Palette.body)),
                const SizedBox(height: 10),
                Text(
                  s.address,
                  style: const TextStyle(color: Palette.muted, fontSize: 14),
                ),
              ],
            ),
          ),
          const SectionTitle('About Me'),
          Text(s.about, style: const TextStyle(color: Palette.body)),
          const SectionTitle('Personal Information'),
          ...{
            'Email': s.email,
            'Phone Number': s.phone,
            'Address': s.address,
          }.entries.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    e.key,
                    style: const TextStyle(fontSize: 12, color: Palette.muted),
                  ),
                  Text(e.value),
                ],
              ),
            ),
          ),
          const SectionTitle('Work Experience'),
          Panel(
            child: Row(
              children: [
                CompanyLogo(s.workCompany),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s.workCompany,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        s.workTitle,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Palette.body,
                        ),
                      ),
                      Text(
                        '${s.startDate} – ${s.endDate}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Palette.muted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SectionTitle('Education Background'),
          Panel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s.institution),
                Text(
                  s.degree,
                  style: const TextStyle(color: Palette.body, fontSize: 14),
                ),
                const Text(
                  'Visual Communication',
                  style: TextStyle(color: Palette.muted, fontSize: 12),
                ),
              ],
            ),
          ),
          const SectionTitle('Skills'),
          Wrap(
            spacing: 8,
            runSpacing: 10,
            children: s.skills
                .map((v) => Pill(v, color: Palette.sand))
                .toList(),
          ),
          const SizedBox(height: 28),
          OutlinedButton(
            onPressed: () => go(context, '/edit-experience'),
            child: const Text('Edit Experiences'),
          ),
        ],
      ),
    );
  }
}

class ProfileFormPage extends StatefulWidget {
  const ProfileFormPage({super.key, this.kind = 'personal'});
  final String kind;
  @override
  State<ProfileFormPage> createState() => _ProfileFormPageState();
}

class _ProfileFormPageState extends State<ProfileFormPage> {
  final form = GlobalKey<FormState>();
  final fields = <String, TextEditingController>{};
  bool loaded = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!loaded) {
      final s = AppScope.of(context);
      final labels = switch (widget.kind) {
        'work' => [
          'Job Title',
          'Job Level',
          'Company Name',
          'Start Date',
          'End Date',
        ],
        'education' => ['Institution', 'Degree'],
        'experiences' => [
          'About Me',
          'Job Title',
          'Company Name',
          'Institution',
          'Degree',
        ],
        _ => ['Name', 'Email', 'Phone Number', 'Address'],
      };
      for (final label in labels) {
        fields[label] = TextEditingController(text: s.profile[label]);
      }
      loaded = true;
    }
  }

  @override
  void dispose() {
    for (final c in fields.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = switch (widget.kind) {
      'work' => 'Work Experience',
      'education' => 'Education Background',
      'experiences' => 'Edit Experiences',
      'identity' => 'Account Identity',
      _ => 'Edit Profile',
    };
    return PageFrame(
      title: title,
      bottom: FilledButton(
        onPressed: () {
          if (!form.currentState!.validate()) return;
          AppScope.of(context)
              .updateProfile(fields.map((k, v) => MapEntry(k, v.text.trim())));
          toast(context, 'Profile updated');
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          } else {
            home(context, '/profile');
          }
        },
        child: const Text('Save Changes'),
      ),
      child: Form(
        key: form,
        child: ListView(
          padding: const EdgeInsets.all(22),
          children: [
            if (widget.kind == 'personal' || widget.kind == 'identity') ...[
              const Center(child: Art('avatar-large', size: 90)),
              const SizedBox(height: 24),
              const SectionTitle('Personal Info'),
            ],
            ...fields.entries.map(
              (e) => FormFieldTile(
                e.key,
                controller: e.value,
                email: e.key == 'Email',
                lines: e.key == 'About Me'
                    ? 5
                    : e.key == 'Address'
                    ? 2
                    : 1,
              ),
            ),
            if (widget.kind == 'personal')
              OutlinedButton(
                onPressed: () => go(context, '/edit-experience'),
                child: const Text('Edit Experiences'),
              ),
            if (widget.kind == 'experiences') ...[
              const SectionTitle('Skills'),
              Wrap(
                spacing: 8,
                children: AppScope.of(context).skills
                    .map((v) => Pill(v))
                    .toList(),
              ),
              const SizedBox(height: 20),
              OutlinedButton(
                onPressed: () =>
                    go(context, '/personal-skills', arguments: 'edit'),
                child: const Text('Edit Skills'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class CompleteProfilePage extends StatelessWidget {
  const CompleteProfilePage({super.key});
  @override
  Widget build(BuildContext context) => PageFrame(
    title: 'Complete Profile',
    child: ListView(
      padding: const EdgeInsets.all(10),
      children: [
        for (final entry in [
          (
            Icons.person_outline,
            'Account Identity',
            'Your contact details and personal information.',
            '/identity',
          ),
          (
            Icons.work_outline,
            'Interested Job',
            'Choose the fields you want to work in.',
            '/categories',
          ),
          (
            Icons.business_center_outlined,
            'Work Experience',
            'Show the experience you bring to a team.',
            '/work-experience',
          ),
          (
            Icons.school_outlined,
            'Education Background',
            'Tell us about your education.',
            '/education',
          ),
          (
            Icons.auto_awesome_outlined,
            'Personal Skills',
            'Highlight the skills that make you unique.',
            '/personal-skills',
          ),
        ])
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              onTap: () => go(context, entry.$4, arguments: 'edit'),
              child: Panel(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Palette.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(entry.$1),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(entry.$2),
                          const SizedBox(height: 6),
                          Text(
                            entry.$3,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Palette.body,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: Palette.muted),
                  ],
                ),
              ),
            ),
          ),
      ],
    ),
  );
}

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});
  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  String? selected;
  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    selected ??= s.language;
    return PageFrame(
      title: 'Language',
      bottom: FilledButton(
        onPressed: () {
          s.language = selected!;
          s.save();
          toast(
            context,
            'Language preference saved. This UI kit is currently in English.',
          );
          if (Navigator.canPop(context)) Navigator.pop(context);
        },
        child: const Text('Save Changes'),
      ),
      child: ListView(
        children:
            [
                  'English (US)',
                  'Indonesia',
                  'English (Australia)',
                  'French',
                  'Japan',
                  'Melayu',
                  'Tagalog',
                  'Spain',
                ]
                .map(
                  (v) => ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 8,
                    ),
                    leading: const Icon(Icons.language, color: Palette.muted),
                    title: Text(v),
                    trailing: Icon(
                      selected == v
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      color: selected == v ? Palette.green : Palette.line,
                    ),
                    onTap: () => setState(() => selected = v),
                  ),
                )
                .toList(),
      ),
    );
  }
}

class SecurityPage extends StatefulWidget {
  const SecurityPage({super.key});
  @override
  State<SecurityPage> createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  final form = GlobalKey<FormState>();
  final current = TextEditingController(), next = TextEditingController();
  @override
  void dispose() {
    current.dispose();
    next.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    return PageFrame(
      title: 'Security',
      child: ListView(
        padding: const EdgeInsets.all(22),
        children: [
          const SectionTitle('Password'),
          Form(
            key: form,
            child: Column(
              children: [
                FormFieldTile(
                  'Current Password',
                  controller: current,
                  password: true,
                ),
                FormFieldTile('New Password', controller: next, password: true),
                FilledButton(
                  onPressed: () {
                    if (form.currentState!.validate()) {
                      toast(
                        context,
                        'Demo preference only. No server password was changed.',
                      );
                      current.clear();
                      next.clear();
                    }
                  },
                  child: const Text('Save Changes'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const SectionTitle('Two-Factor Authentication'),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Text Message'),
            subtitle: const Text(
              'We’ll send a code to your number',
              style: TextStyle(fontSize: 14, color: Palette.muted),
            ),
            value: s.textMessage,
            onChanged: (v) {
              s.textMessage = v;
              s.save();
            },
            activeTrackColor: Palette.green,
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Authentication App'),
            subtitle: const Text(
              'We’ll check if you have the app',
              style: TextStyle(fontSize: 14, color: Palette.muted),
            ),
            value: s.authenticator,
            onChanged: (v) {
              s.authenticator = v;
              s.save();
            },
            activeTrackColor: Palette.green,
          ),
          const SizedBox(height: 22),
          const Text(
            'These switches save demo preferences only. SMS and authenticator enrollment require a connected authentication service.',
            style: TextStyle(fontSize: 12, color: Palette.muted),
          ),
        ],
      ),
    );
  }
}

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});
  @override
  Widget build(BuildContext context) => PageFrame(
    title: 'About Us',
    child: ListView(
      padding: const EdgeInsets.all(22),
      children: [
        const SizedBox(height: 42),
        Center(
          child: Container(
            width: 98,
            height: 98,
            decoration: BoxDecoration(
              color: Palette.blue,
              borderRadius: BorderRadius.circular(26),
            ),
            child: const Padding(
              padding: EdgeInsets.all(20),
              child: Art('carijob-logo', size: 54),
            ),
          ),
        ),
        const SizedBox(height: 18),
        const Center(child: Text('Carijob', style: TextStyle(fontSize: 24))),
        const Center(
          child: Text(
            'Version 1.0.0',
            style: TextStyle(color: Palette.muted, fontSize: 14),
          ),
        ),
        const SizedBox(height: 40),
        const Text(
          'Carijob is the leading talent ecosystem in Southeast Asia. Our mission is to enable professionals in the region to grow their careers and empower organizations to hire the right talent from anywhere in Southeast Asia.',
          style: TextStyle(color: Palette.body),
        ),
        const SizedBox(height: 18),
        const Text(
          'Find inspiring opportunities, build a profile that tells your story and keep track of every step of your job search.',
          style: TextStyle(color: Palette.body),
        ),
        const SizedBox(height: 32),
        const Text(
          'Flutter UI demo based on the Carijob UI Kit in Pixso. Company names and sample applications are for demonstration.',
          style: TextStyle(fontSize: 13, color: Palette.muted),
        ),
      ],
    ),
  );
}

class FaqPage extends StatelessWidget {
  const FaqPage({super.key});
  @override
  Widget build(BuildContext context) => PageFrame(
    title: 'FAQ',
    background: Colors.white,
    child: ListView(
      children: const [
        ExpansionTile(
          title: Text('What is this app for?'),
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Carijob helps you discover jobs, save opportunities, build a profile and track applications.',
              ),
            ),
          ],
        ),
        ExpansionTile(
          initiallyExpanded: true,
          title: Text('Why Should I Use Carijob?'),
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Carijob brings opportunities and your career profile into one place. Search by role or company, explore different industries and follow your application progress.\n\nThis demo stores your profile, bookmarks and applications on your device. A production service can connect the same screens to real employers and verified job listings.',
                style: TextStyle(color: Palette.body),
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text('What Kind of Candidates Carijob Have?'),
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'The reference includes creative, technology, marketing and business roles across experience levels.',
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text('How to Report Bugs?'),
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Record the page and steps that caused the issue, then share them with your project maintainer.',
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text('Where Do I Send the Partnership?'),
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Partnership contact details will be configured when the live service is connected.',
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
