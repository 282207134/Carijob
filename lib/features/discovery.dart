import 'package:flutter/material.dart';

import '../core/app_state.dart';
import '../core/theme.dart';
import '../data/job_repository.dart';
import '../data/models.dart';
import '../shared/widgets.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
    children: [
      SizedBox(
        height: 214,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: 28,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Palette.blue,
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
            ),
            Positioned(
              right: -20,
              top: -12,
              child: Art('search-art', size: 180),
            ),
            const Positioned(
              top: 55,
              left: 12,
              child: Text(
                'We help find your\ndream job!',
                style: TextStyle(fontSize: 28, height: 1.2),
              ),
            ),
            Positioned(
              left: 10,
              right: 10,
              bottom: 10,
              child: SearchBox(
                onSubmit: (q) => go(context, '/results', arguments: q),
              ),
            ),
          ],
        ),
      ),
      SectionTitle('Recommended', onSeeAll: () => go(context, '/recommended')),
      SizedBox(
        height: 164,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: 2,
          separatorBuilder: (_, _) => const SizedBox(width: 10),
          itemBuilder: (context, i) {
            final job = JobRepository.jobs[i];
            return InkWell(
              onTap: () => go(context, '/details', arguments: job),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 245,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: i == 0 ? Palette.sand : Palette.green,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CompanyLogo(job.company, size: 58),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                job.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                job.company,
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
                    const Divider(height: 18),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 18),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            job.location,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Palette.body,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Pill(
                          job.type,
                          color: Colors.white.withValues(alpha: .3),
                        ),
                        const SizedBox(width: 6),
                        Pill(
                          job.mode,
                          color: Colors.white.withValues(alpha: .3),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      SectionTitle('New Listing', onSeeAll: () => go(context, '/recommended')),
      ...JobRepository.jobs.skip(2).take(2).map((job) => JobCard(job)),
      InkWell(
        onTap: () => go(context, '/complete-profile'),
        child: const Panel(
          color: Palette.blue,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Let your profile do the talking',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      'Complete your profile for better matches.',
                      style: TextStyle(fontSize: 13, color: Palette.body),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward),
            ],
          ),
        ),
      ),
    ],
  );
}

class SearchBox extends StatefulWidget {
  const SearchBox({
    super.key,
    required this.onSubmit,
    this.initial = '',
    this.autofocus = false,
  });
  final ValueChanged<String> onSubmit;
  final String initial;
  final bool autofocus;
  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  late final controller = TextEditingController(text: widget.initial);
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => TextField(
    controller: controller,
    autofocus: widget.autofocus,
    textInputAction: TextInputAction.search,
    onSubmitted: widget.onSubmit,
    decoration: InputDecoration(
      hintText: 'Search Job or Company',
      filled: true,
      fillColor: const Color(0xFFEEF4FA),
      prefixIcon: const Icon(Icons.search, color: Color(0xFF8199BF)),
      suffixIcon: IconButton(
        tooltip: 'Search',
        onPressed: () => widget.onSubmit(controller.text),
        icon: const Icon(Icons.arrow_forward, size: 19),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    ),
  );
}

class ExploreView extends StatefulWidget {
  const ExploreView({super.key});
  @override
  State<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<ExploreView> {
  String query = '', type = 'Full-Time', location = 'United States';
  void search() => go(
    context,
    '/results',
    arguments: SearchRequest(query, JobFilter(type: type, location: location)),
  );
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.only(bottom: 20),
    children: [
      Container(
        color: Palette.blue,
        padding: const EdgeInsets.fromLTRB(10, 4, 10, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Panel(
              padding: 10,
              child: Column(
                children: [
                  TextField(
                    onChanged: (v) => query = v,
                    onSubmitted: (_) => search(),
                    decoration: InputDecoration(
                      hintText: 'Search Job or Company',
                      prefixIcon: const Icon(Icons.search),
                      fillColor: Palette.background,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _dropdown('Job Type', type, [
                          'All',
                          'Full-Time',
                          'Part-Time',
                          'Freelance',
                          'Internship',
                        ], (v) => setState(() => type = v)),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _dropdown('Location', location, [
                          'Anywhere',
                          'United States',
                          'Sweden',
                          'Indonesia',
                        ], (v) => setState(() => location = v)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: search,
                    child: const Text('Search Job'),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'Or Browse By Category',
                style: TextStyle(fontSize: 18),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(4, (i) {
                const names = [
                  'Music',
                  'Technology',
                  'Finance',
                  'Food & Drink',
                ];
                const assets = ['music', 'tech', 'finance', 'food'];
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: i < 3 ? 8 : 0),
                    child: InkWell(
                      onTap: () => go(
                        context,
                        '/results',
                        arguments: SearchRequest(
                          '',
                          JobFilter(category: names[i]),
                        ),
                      ),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Art('category-${assets[i]}', size: 82),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            names[i],
                            style: const TextStyle(
                              fontSize: 12,
                              color: Palette.body,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            SectionTitle(
              'New Listing',
              onSeeAll: () => go(context, '/recommended'),
            ),
            ...JobRepository.jobs.skip(2).take(3).map((j) => JobCard(j)),
          ],
        ),
      ),
    ],
  );
  Widget _dropdown(
    String label,
    String value,
    List<String> choices,
    ValueChanged<String> update,
  ) => Container(
    padding: const EdgeInsets.fromLTRB(10, 7, 6, 2),
    decoration: BoxDecoration(
      color: const Color(0xFFEEF4FA),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Palette.body)),
        DropdownButton<String>(
          value: value,
          isExpanded: true,
          isDense: true,
          underline: const SizedBox(),
          style: const TextStyle(
            fontFamily: 'Archivo',
            fontSize: 14,
            color: Palette.ink,
          ),
          items: choices
              .map((v) => DropdownMenuItem(value: v, child: Text(v)))
              .toList(),
          onChanged: (v) {
            if (v != null) update(v);
          },
        ),
      ],
    ),
  );
}

class SearchRequest {
  const SearchRequest(this.query, this.filter);
  final String query;
  final JobFilter filter;
}

class ResultsPage extends StatefulWidget {
  const ResultsPage({
    super.key,
    this.query = '',
    this.filter = const JobFilter(),
    this.title,
  });
  final String query;
  final JobFilter filter;
  final String? title;
  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  late String query = widget.query;
  late JobFilter filter = widget.filter;
  int tab = 0;
  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final jobs = widget.title == 'Saved Jobs'
        ? JobRepository.jobs.where((j) => state.saved.contains(j.id)).toList()
        : state.repository.search(query, filter);
    final companies = jobs.map((j) => j.company).toSet().toList();
    return PageFrame(
      title: widget.title ?? 'Search',
      child: Column(
        children: [
          if (widget.title == null)
            Padding(
              padding: const EdgeInsets.all(10),
              child: SearchBox(
                initial: query,
                onSubmit: (v) => setState(() => query = v),
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Results (${tab == 0 ? jobs.length : companies.length})',
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
                TextButton.icon(
                  onPressed: () async {
                    final next = await showModalBottomSheet<JobFilter>(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.white,
                      builder: (_) => FilterSheet(filter: filter),
                    );
                    if (next != null && mounted) setState(() => filter = next);
                  },
                  icon: const Icon(Icons.filter_alt, size: 18),
                  label: const Text('Filter'),
                ),
              ],
            ),
          ),
          if (widget.title != 'Saved Jobs')
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Tabs(
                labels: const ['Job', 'Company'],
                index: tab,
                onChanged: (v) => setState(() => tab = v),
              ),
            ),
          const SizedBox(height: 14),
          Expanded(
            child: jobs.isEmpty
                ? EmptyView(
                    title: widget.title == 'Saved Jobs'
                        ? 'No saved jobs yet'
                        : 'No results found',
                    message: widget.title == 'Saved Jobs'
                        ? 'Save a job from its details to find it here.'
                        : 'Try another keyword or adjust your filters.',
                    action: 'Browse jobs',
                    onAction: () {
                      if (widget.title == 'Saved Jobs') {
                        home(context, '/explore');
                        return;
                      }
                      setState(() {
                        query = '';
                        filter = const JobFilter();
                      });
                    },
                  )
                : ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    children: tab == 0
                        ? jobs.map((j) => JobCard(j, expanded: true)).toList()
                        : companies
                              .map(
                                (company) => Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: InkWell(
                                    onTap: () => go(
                                      context,
                                      '/opportunities',
                                      arguments: company,
                                    ),
                                    child: Panel(
                                      child: Row(
                                        children: [
                                          CompanyLogo(company),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  company,
                                                  style: const TextStyle(
                                                    fontSize: 20,
                                                  ),
                                                ),
                                                Text(
                                                  '${jobs.where((j) => j.company == company).length} job opportunities',
                                                  style: const TextStyle(
                                                    color: Palette.muted,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Icon(Icons.chevron_right),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                  ),
          ),
        ],
      ),
    );
  }
}

class FilterSheet extends StatefulWidget {
  const FilterSheet({super.key, this.filter = const JobFilter()});
  final JobFilter filter;
  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  late String type = widget.filter.type, period = widget.filter.period;
  late bool recent = widget.filter.recent;
  @override
  Widget build(BuildContext context) => SafeArea(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 18),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text('Filter', style: TextStyle(fontSize: 24)),
              ),
              IconButton(
                tooltip: 'Close filter',
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, color: Palette.muted),
              ),
            ],
          ),
          const Text('Sort By', style: TextStyle(fontSize: 14)),
          const SizedBox(height: 10),
          Row(
            children: [
              _choice(
                'Most Recent',
                recent,
                () => setState(() => recent = true),
              ),
              _choice(
                'Most Relevant',
                !recent,
                () => setState(() => recent = false),
              ),
            ],
          ),
          const Divider(),
          const Text('Date Period', style: TextStyle(fontSize: 14)),
          const SizedBox(height: 10),
          Wrap(
            children: ['Past 24 Hours', 'Past Month', 'Past 7 Days', 'All Time']
                .map(
                  (v) => SizedBox(
                    width: (MediaQuery.sizeOf(context).width - 28) / 2,
                    child: _choice(
                      v,
                      period == v,
                      () => setState(() => period = v),
                      expand: false,
                    ),
                  ),
                )
                .toList(),
          ),
          const Divider(),
          const Text('Job Type', style: TextStyle(fontSize: 14)),
          const SizedBox(height: 10),
          Wrap(
            children:
                ['Internship', 'Part-Time', 'Full-Time', 'Freelance', 'All']
                    .map(
                      (v) => SizedBox(
                        width: (MediaQuery.sizeOf(context).width - 28) / 2,
                        child: _choice(
                          v,
                          type == v,
                          () => setState(() => type = v),
                          expand: false,
                        ),
                      ),
                    )
                    .toList(),
          ),
          const Divider(),
          FilledButton(
            onPressed: () => Navigator.pop(
              context,
              JobFilter(
                type: type,
                period: period,
                recent: recent,
                location: widget.filter.location,
                category: widget.filter.category,
              ),
            ),
            child: const Text('Apply Filter'),
          ),
        ],
      ),
    ),
  );
  Widget _choice(
    String label,
    bool selected,
    VoidCallback onTap, {
    bool expand = true,
  }) {
    final row = InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(
              selected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: selected ? Palette.green : Palette.line,
              size: 22,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                style: TextStyle(color: selected ? Palette.ink : Palette.muted),
              ),
            ),
          ],
        ),
      ),
    );
    return expand ? Expanded(child: row) : row;
  }
}

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});
  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return PageFrame(
      title: 'Notification',
      child: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          const Text('Today', style: TextStyle(color: Palette.muted)),
          const SizedBox(height: 14),
          ...state.applications.where((a) => !a.rejected).map((a) {
            final j = state.repository.byId(a.jobId);
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: () => go(context, '/application-details', arguments: a),
                child: Panel(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CompanyLogo(j.company, size: 48),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              a.stage == 0
                                  ? 'Application submitted'
                                  : 'Your application has an update',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '${j.title} at ${j.company}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Palette.body,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              a.stage == 2
                                  ? 'Your interview schedule is ready.'
                                  : 'Tap to view your application progress.',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Palette.muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
