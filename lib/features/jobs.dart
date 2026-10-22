import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';

import '../core/app_state.dart';
import '../core/theme.dart';
import '../data/models.dart';
import '../shared/widgets.dart';

class JobDetailsPage extends StatelessWidget {
  const JobDetailsPage({super.key, required this.job});
  final Job job;
  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return PageFrame(
      title: 'Details',
      actions: [
        IconButton(
          tooltip: state.saved.contains(job.id) ? 'Unsave job' : 'Save job',
          onPressed: () => state.toggleSaved(job.id),
          icon: Icon(
            state.saved.contains(job.id)
                ? Icons.bookmark
                : Icons.bookmark_border,
          ),
        ),
      ],
      bottom: FilledButton(
        onPressed: () => state.hasApplied(job.id)
            ? home(context, '/my-jobs')
            : go(context, '/apply', arguments: job),
        child: Text(state.hasApplied(job.id) ? 'View Application' : 'Apply'),
      ),
      child: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          Panel(
            color: Palette.green,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CompanyLogo(job.company, size: 68),
                    const Spacer(),
                    const Icon(
                      Icons.location_on,
                      size: 18,
                      color: Palette.body,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      job.mode,
                      style: const TextStyle(color: Palette.body, fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  job.title,
                  style: const TextStyle(fontSize: 28, height: 1.2),
                ),
                Text(job.company, style: const TextStyle(color: Palette.body)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFA0CC96),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                const Icon(Icons.paid, size: 18),
                const SizedBox(width: 7),
                Expanded(child: Text(job.salaryLabel)),
                Pill(job.type, color: Colors.white),
                const SizedBox(width: 6),
                Pill(job.mode, color: Colors.white),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Palette.line),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Posted by',
                  style: TextStyle(fontSize: 14, color: Palette.muted),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Art('recruiter', size: 53),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Alfonso Lipshutz',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            'Job Recruiter at ${job.company}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Palette.body,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SectionTitle('About the Job'),
          Text(
            job.title.toLowerCase().contains('design')
                ? 'The Brand Designer job description includes the entire process of brainstorming, visualizing and creating design including typography, layouts, illustration and photography.'
                : 'Join ${job.company} to build thoughtful products and experiences. Work with a collaborative team, turn customer insights into ideas and help shape our next chapter.',
            style: const TextStyle(color: Palette.body),
          ),
          const SectionTitle('Responsibilities'),
          ...[
            'Maintain brand consistency throughout all our marketing collaterals.',
            'Assist to generate leads by optimizing the website, rendering our campaign visuals.',
            'Collaborate with product, engineering and marketing teams.',
          ].map(_bullet),
          const SectionTitle('Requirements'),
          ...[
            '2–3 years of relevant professional experience.',
            'Strong communication and problem-solving skills.',
            'A portfolio showing your process and attention to detail.',
          ].map(_bullet),
          const SectionTitle('Benefits'),
          const Text(
            'Flexible working hours, learning opportunities, health coverage and a supportive international team.',
            style: TextStyle(color: Palette.body),
          ),
          const SectionTitle('About the Company'),
          Text(
            '${job.company} brings people and ideas together. Explore open roles and find the right opportunity for your next step.',
            style: const TextStyle(color: Palette.body),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () =>
                go(context, '/opportunities', arguments: job.company),
            child: const Text('See All Opportunities'),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _bullet(String value) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('•  ', style: TextStyle(color: Palette.muted)),
        Expanded(
          child: Text(value, style: const TextStyle(color: Palette.body)),
        ),
      ],
    ),
  );
}

class ApplyPage extends StatefulWidget {
  const ApplyPage({super.key, required this.job, this.full = false});
  final Job job;
  final bool full;
  @override
  State<ApplyPage> createState() => _ApplyPageState();
}

class _ApplyPageState extends State<ApplyPage> {
  final form = GlobalKey<FormState>();
  final email = TextEditingController(),
      phone = TextEditingController(),
      letter = TextEditingController();
  String? resume;
  bool submitting = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (email.text.isEmpty) {
      final s = AppScope.of(context);
      email.text = s.email;
      phone.text = s.phone;
    }
  }

  @override
  void dispose() {
    email.dispose();
    phone.dispose();
    letter.dispose();
    super.dispose();
  }

  Future<void> pickResume() async {
    try {
      final file = await openFile(
        acceptedTypeGroups: [
          const XTypeGroup(
            label: 'Resume',
            extensions: ['pdf', 'doc', 'docx'],
            mimeTypes: [
              'application/pdf',
              'application/msword',
              'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
            ],
            uniformTypeIdentifiers: [
              'com.adobe.pdf',
              'org.openxmlformats.wordprocessingml.document',
              'com.microsoft.word.doc',
            ],
          ),
        ],
      );
      if (file == null) return;
      if (await file.length() > 5 * 1024 * 1024) {
        if (mounted) toast(context, 'Choose a file smaller than 5MB.');
        return;
      }
      if (![
        'pdf',
        'doc',
        'docx',
      ].contains(file.name.split('.').last.toLowerCase())) {
        if (mounted) toast(context, 'Choose a Word or PDF document.');
        return;
      }
      if (mounted) setState(() => resume = file.name);
    } catch (_) {
      if (mounted) {
        toast(context, 'The file could not be opened. Please try again.');
      }
    }
  }

  Future<void> submit() async {
    if (!form.currentState!.validate()) return;
    if (resume == null) {
      toast(context, 'Please choose a resume or use the demo resume.');
      return;
    }
    setState(() => submitting = true);
    final state = AppScope.of(context);
    await state.apply(
      widget.job.id,
      email: email.text.trim(),
      phone: phone.text.trim(),
      resumeName: resume!,
      coverLetter: letter.text.trim(),
    );
    if (mounted) {
      Navigator.pushReplacementNamed(
        context,
        '/success',
        arguments: widget.job,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return PageFrame(
      title: 'Apply to ${widget.job.company}',
      bottom: FilledButton(
        onPressed: submitting ? null : submit,
        child: Text(submitting ? 'Submitting…' : 'Apply'),
      ),
      child: Form(
        key: form,
        child: ListView(
          padding: const EdgeInsets.all(22),
          children: [
            const Text(
              'Your Profile',
              style: TextStyle(color: Palette.muted, fontSize: 14),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Art('avatar', size: 54),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.name,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        state.address,
                        style: const TextStyle(
                          color: Palette.body,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 26),
            FormFieldTile('Email', controller: email, email: true),
            FormFieldTile('Phone Number', controller: phone),
            if (!widget.full)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () =>
                      go(context, '/apply-full', arguments: widget.job),
                  child: const Text('Review full profile'),
                ),
              ),
            if (widget.full) ...[
              const SectionTitle('Work Experience'),
              Panel(
                child: Text(
                  '${state.workTitle}\n${state.workCompany} · ${state.level}',
                ),
              ),
              const SectionTitle('Skills'),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: state.skills.map((s) => Pill(s)).toList(),
              ),
            ],
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                border: Border.all(color: Palette.line),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Icon(Icons.upload_file, size: 44, color: Palette.muted),
                  const SizedBox(height: 16),
                  const Text('Upload Resume', style: TextStyle(fontSize: 18)),
                  const Text(
                    'Microsoft Word or PDF only (5MB)',
                    style: TextStyle(fontSize: 13, color: Palette.muted),
                  ),
                  const SizedBox(height: 16),
                  if (resume != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Text(
                        resume!,
                        style: const TextStyle(color: Palette.body),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  OutlinedButton(
                    onPressed: pickResume,
                    child: Text(resume == null ? 'Upload File' : 'Change File'),
                  ),
                  TextButton(
                    onPressed: () =>
                        setState(() => resume = 'Matt_Murdock_Demo_Resume.pdf'),
                    child: const Text('Use demo resume'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 26),
            FormFieldTile(
              'Cover Letter (optional)',
              controller: letter,
              requiredField: false,
              lines: 4,
            ),
            const Text(
              'Demo application — saved on this device. Your resume is not sent to an employer.',
              style: TextStyle(fontSize: 12, color: Palette.muted),
            ),
          ],
        ),
      ),
    );
  }
}

class SuccessPage extends StatelessWidget {
  const SuccessPage({super.key, required this.job});
  final Job job;
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Spacer(),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 190,
                  height: 190,
                  decoration: const BoxDecoration(
                    color: Palette.green,
                    shape: BoxShape.circle,
                  ),
                ),
                Transform.rotate(
                  angle: -.2,
                  child: Container(
                    width: 110,
                    height: 135,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.check_circle,
                      size: 78,
                      color: Palette.ink,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 36),
            const Text(
              'Applied Successfully!',
              style: TextStyle(fontSize: 30),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Your application to ${job.company} has been saved. Track your next step in My Job.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Palette.body),
            ),
            const Spacer(),
            FilledButton(
              onPressed: () => home(context, '/my-jobs'),
              child: const Text('View My Application'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => home(context),
              child: const Text('Back to Home'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    ),
  );
}

class ApplicationsView extends StatefulWidget {
  const ApplicationsView({super.key, this.initialTab = 0});
  final int initialTab;
  @override
  State<ApplicationsView> createState() => _ApplicationsViewState();
}

class _ApplicationsViewState extends State<ApplicationsView> {
  late int tab = widget.initialTab;
  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final apps = state.applications
        .where((a) => a.rejected == (tab == 1))
        .toList();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Tabs(
            labels: const ['Active', 'Rejected'],
            index: tab,
            onChanged: (v) => setState(() => tab = v),
          ),
        ),
        Expanded(
          child: apps.isEmpty
              ? EmptyView(
                  title: 'No applications yet',
                  message:
                      'Find a role you love and send your first application.',
                  action: 'Explore jobs',
                  onAction: () => home(context, '/explore'),
                )
              : ListView(
                  padding: const EdgeInsets.all(10),
                  children: apps.map((a) {
                    final job = state.repository.byId(a.jobId);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: InkWell(
                        onTap: () =>
                            go(context, '/application-details', arguments: a),
                        child: Panel(
                          padding: 10,
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CompanyLogo(job.company, size: 68),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          job.title,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          job.company,
                                          style: const TextStyle(
                                            color: Palette.body,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          _applied(a),
                                          style: const TextStyle(
                                            color: Palette.muted,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Pill(job.type, foreground: Palette.muted),
                                ],
                              ),
                              const Divider(height: 22),
                              a.rejected
                                  ? const Row(
                                      children: [
                                        Icon(
                                          Icons.cancel_outlined,
                                          color: Color(0xFFDB5656),
                                          size: 18,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Application rejected',
                                          style: TextStyle(
                                            color: Color(0xFFDB5656),
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    )
                                  : ProgressSteps(stage: a.stage),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
        ),
      ],
    );
  }

  String _applied(Application a) {
    final days = DateTime.now().difference(a.appliedAt).inDays;
    return days == 0
        ? 'Applied today'
        : days == 1
        ? 'Applied yesterday'
        : 'Applied ${days}d ago';
  }
}

class ProgressSteps extends StatelessWidget {
  const ProgressSteps({super.key, required this.stage});
  final int stage;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
    decoration: BoxDecoration(
      color: Palette.background,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        7,
        (i) => i.isOdd
            ? Icon(
                Icons.chevron_right,
                size: 18,
                color: i ~/ 2 < stage ? Palette.ink : Palette.line,
              )
            : Flexible(
                child: Text(
                  ['Submitted', 'Test', 'Interview', 'Offer'][i ~/ 2],
                  style: TextStyle(
                    fontSize: 13,
                    color: i ~/ 2 <= stage ? Palette.ink : Palette.muted,
                  ),
                ),
              ),
      ),
    ),
  );
}

class ApplicationDetailsPage extends StatelessWidget {
  const ApplicationDetailsPage({super.key, required this.application});
  final Application application;
  @override
  Widget build(BuildContext context) {
    final a = application;
    final job = AppScope.of(context).repository.byId(a.jobId);
    return PageFrame(
      title: 'Details',
      child: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          Panel(
            color: Palette.green,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CompanyLogo(job.company, size: 68),
                    const Spacer(),
                    const Pill('Application'),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  job.title,
                  style: const TextStyle(fontSize: 28, height: 1.2),
                ),
                Text(job.company, style: const TextStyle(color: Palette.body)),
                const Divider(),
                const Text(
                  'Application Progress',
                  style: TextStyle(fontSize: 14, color: Palette.body),
                ),
                const SizedBox(height: 8),
                if (a.rejected)
                  const Pill('Rejected', foreground: Color(0xFFCC3333))
                else
                  ProgressSteps(stage: a.stage),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Panel(
            child: Column(
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Job Details',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    TextButton(
                      onPressed: () => go(context, '/details', arguments: job),
                      child: const Text('See Details'),
                    ),
                  ],
                ),
                ...{
                  'Location': job.location,
                  'Industry': job.category,
                  'Job Type': job.type,
                  'Salary': job.salaryLabel,
                  'Experience': '2–3 Years',
                }.entries.map(
                  (e) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            e.key,
                            style: const TextStyle(color: Palette.body),
                          ),
                        ),
                        Expanded(
                          child: Text(e.value, textAlign: TextAlign.right),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Panel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  a.rejected
                      ? 'Application Update'
                      : a.stage == 2
                      ? 'Interview Schedule'
                      : a.stage == 1
                      ? 'Assessment'
                      : a.stage == 3
                      ? 'Offer Received'
                      : 'Application Submitted',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 16),
                if (a.stage == 2)
                  const Row(
                    children: [
                      Icon(Icons.video_call_outlined, size: 38),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Interview · Google Meet\nMay 26, 2023 · 4:30pm–5pm',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  )
                else
                  Text(
                    a.rejected
                        ? 'Thank you for your interest. The team has decided to continue with other candidates. Explore more opportunities.'
                        : a.stage == 3
                        ? 'Congratulations! The hiring team has prepared an offer. This is a sample status for the UI demonstration.'
                        : a.stage == 1
                        ? 'The hiring team has invited you to complete a skills assessment. This sample has no external test link.'
                        : 'Your application has been received. We will let you know when the hiring team updates your status.',
                    style: const TextStyle(color: Palette.body),
                  ),
                if (a.stage == 2)
                  const Padding(
                    padding: EdgeInsets.only(top: 12),
                    child: Text(
                      'Sample schedule from the design reference.',
                      style: TextStyle(color: Palette.muted, fontSize: 12),
                    ),
                  ),
                if (a.resumeName.isNotEmpty) ...[
                  const Divider(),
                  const Text(
                    'Submitted Information',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 12),
                  Text(a.email),
                  Text(a.phone),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.description_outlined, size: 22),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          a.resumeName,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Palette.body,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (a.coverLetter.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      a.coverLetter,
                      style: const TextStyle(color: Palette.body),
                    ),
                  ],
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
