import 'package:flutter/material.dart';

import '../core/app_state.dart';
import '../core/theme.dart';
import '../data/models.dart';

void go(BuildContext context, String route, {Object? arguments}) =>
    Navigator.pushNamed(context, route, arguments: arguments);
void home(BuildContext context, [String route = '/home']) =>
    Navigator.pushNamedAndRemoveUntil(context, route, (_) => false);
void toast(BuildContext context, String text) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

class Art extends StatelessWidget {
  const Art(this.name, {super.key, this.size = 44, this.fit = BoxFit.contain});
  final String name;
  final double size;
  final BoxFit fit;
  @override
  Widget build(BuildContext context) => Image.asset(
    'assets/images/$name.png',
    width: size,
    height: size,
    fit: fit,
  );
}

class CompanyLogo extends StatelessWidget {
  const CompanyLogo(this.company, {super.key, this.size = 64});
  final String company;
  final double size;
  @override
  Widget build(BuildContext context) {
    final asset = company.toLowerCase();
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Palette.background,
        borderRadius: BorderRadius.circular(13),
      ),
      alignment: Alignment.center,
      child: ['google', 'twitter'].contains(asset)
          ? Art(asset, size: size * .54)
          : ['medium', 'spotify', 'twitch', 'pinterest'].contains(asset)
          ? ClipRRect(
              borderRadius: BorderRadius.circular(13),
              child: Art(asset, size: size),
            )
          : const Icon(Icons.business_outlined, color: Palette.muted),
    );
  }
}

class Pill extends StatelessWidget {
  const Pill(
    this.label, {
    super.key,
    this.color = const Color(0xFFF0F5F9),
    this.foreground = Palette.body,
  });
  final String label;
  final Color color, foreground;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(30),
    ),
    child: Text(
      label,
      style: TextStyle(fontSize: 12, color: foreground),
      maxLines: 1,
    ),
  );
}

class Panel extends StatelessWidget {
  const Panel({
    super.key,
    required this.child,
    this.color = Colors.white,
    this.padding = 12,
  });
  final Widget child;
  final Color color;
  final double padding;
  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(padding),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(20),
    ),
    child: child,
  );
}

class PageFrame extends StatelessWidget {
  const PageFrame({
    super.key,
    required this.title,
    required this.child,
    this.bottom,
    this.actions,
    this.background = Palette.background,
  });
  final String title;
  final Widget child;
  final Widget? bottom;
  final List<Widget>? actions;
  final Color background;
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: background,
    appBar: AppBar(
      title: Text(title),
      actions: actions,
      leading: IconButton(
        tooltip: 'Back',
        icon: const Icon(Icons.arrow_back),
        onPressed: () =>
            Navigator.canPop(context) ? Navigator.pop(context) : home(context),
      ),
    ),
    body: SafeArea(top: false, child: child),
    bottomNavigationBar: bottom == null
        ? null
        : SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 14),
              child: bottom,
            ),
          ),
  );
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.title, {super.key, this.onSeeAll});
  final String title;
  final VoidCallback? onSeeAll;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 18, bottom: 12),
    child: Row(
      children: [
        Expanded(child: Text(title, style: const TextStyle(fontSize: 20))),
        if (onSeeAll != null)
          InkWell(
            onTap: onSeeAll,
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Text(
                'See all',
                style: TextStyle(color: Palette.muted, fontSize: 14),
              ),
            ),
          ),
      ],
    ),
  );
}

class JobCard extends StatelessWidget {
  const JobCard(this.job, {super.key, this.expanded = false, this.onTap});
  final Job job;
  final bool expanded;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap ?? () => go(context, '/details', arguments: job),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CompanyLogo(job.company),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            job.title,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                            maxLines: 2,
                          ),
                          Text(
                            job.company,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Palette.body,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                size: 14,
                                color: Palette.muted,
                              ),
                              const SizedBox(width: 3),
                              Expanded(
                                child: Text(
                                  job.location,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Palette.muted,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 4),
                    Pill(job.type, foreground: Palette.muted),
                  ],
                ),
                if (expanded) ...[
                  const Divider(),
                  Text(
                    'Join ${job.company} and help shape the next generation of ${job.category.toLowerCase()} experiences.',
                    style: const TextStyle(color: Palette.body),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(job.salaryLabel),
                      const Spacer(),
                      IconButton(
                        tooltip: state.saved.contains(job.id)
                            ? 'Unsave job'
                            : 'Save job',
                        onPressed: () => state.toggleSaved(job.id),
                        icon: Icon(
                          state.saved.contains(job.id)
                              ? Icons.bookmark
                              : Icons.bookmark_border,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EmptyView extends StatelessWidget {
  const EmptyView({
    super.key,
    this.title = 'No results found',
    this.message = 'Try another keyword or adjust your filters.',
    this.action,
    this.onAction,
  });
  final String title, message;
  final String? action;
  final VoidCallback? onAction;
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(28),
            decoration: const BoxDecoration(
              color: Palette.blue,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.manage_search, size: 72),
          ),
          const SizedBox(height: 28),
          Text(
            title,
            style: const TextStyle(fontSize: 26),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Palette.body),
          ),
          if (action != null) ...[
            const SizedBox(height: 24),
            FilledButton(onPressed: onAction, child: Text(action!)),
          ],
        ],
      ),
    ),
  );
}

class FormFieldTile extends StatelessWidget {
  const FormFieldTile(
    this.label, {
    super.key,
    required this.controller,
    this.password = false,
    this.lines = 1,
    this.requiredField = true,
    this.email = false,
  });
  final String label;
  final TextEditingController controller;
  final bool password, requiredField, email;
  final int lines;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: TextFormField(
      controller: controller,
      obscureText: password,
      maxLines: lines,
      keyboardType: email
          ? TextInputType.emailAddress
          : label.contains('Phone')
          ? TextInputType.phone
          : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        hintText: 'Your $label',
        alignLabelWithHint: true,
      ),
      validator: (value) {
        if (!requiredField) return null;
        if (value == null || value.trim().isEmpty) return 'Please enter $label';
        if (email && !RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value)) {
          return 'Enter a valid email';
        }
        if (password && value.length < 6) return 'Use at least 6 characters';
        return null;
      },
    ),
  );
}

class Tabs extends StatelessWidget {
  const Tabs({
    super.key,
    required this.labels,
    required this.index,
    required this.onChanged,
  });
  final List<String> labels;
  final int index;
  final ValueChanged<int> onChanged;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(5),
    decoration: BoxDecoration(
      color: const Color(0xFFECF2F8),
      borderRadius: BorderRadius.circular(40),
    ),
    child: Row(
      children: List.generate(
        labels.length,
        (i) => Expanded(
          child: InkWell(
            onTap: () => onChanged(i),
            borderRadius: BorderRadius.circular(30),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 11),
              decoration: BoxDecoration(
                color: index == i ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(30),
              ),
              alignment: Alignment.center,
              child: Text(
                labels[i],
                style: TextStyle(
                  color: index == i ? Palette.ink : Palette.muted,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
