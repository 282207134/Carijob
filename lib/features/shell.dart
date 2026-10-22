import 'package:flutter/material.dart';

import '../core/app_state.dart';
import '../core/theme.dart';
import '../shared/widgets.dart';
import 'discovery.dart';
import 'jobs.dart';
import 'profile.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key, this.initialIndex = 0, this.rejected = false});
  final int initialIndex;
  final bool rejected;
  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  late int index = widget.initialIndex;
  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    const labels = ['Home', 'Explore', 'My Job', 'Profile'];
    const icons = [
      Icons.home_outlined,
      Icons.manage_search,
      Icons.assignment_outlined,
      Icons.person_outline,
    ];
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            if (index != 3)
              Container(
                color: index == 1 ? Palette.blue : Colors.white,
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 18),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => setState(() => index = 3),
                      child: const Art('avatar'),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        index == 0
                            ? state.name
                            : index == 1
                            ? 'Explore'
                            : 'My Applied Job',
                        style: TextStyle(
                          fontSize: index == 0 ? 21 : 28,
                          letterSpacing: -.5,
                        ),
                      ),
                    ),
                    IconButton.filledTonal(
                      tooltip: 'Notifications',
                      onPressed: () => go(context, '/notifications'),
                      style: IconButton.styleFrom(
                        backgroundColor: Palette.background,
                      ),
                      icon: const Icon(
                        Icons.notifications,
                        size: 21,
                        color: Palette.muted,
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: IndexedStack(
                index: index,
                children: [
                  const HomeView(),
                  const ExploreView(),
                  ApplicationsView(initialTab: widget.rejected ? 1 : 0),
                  const ProfileView(),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Row(
                children: List.generate(
                  4,
                  (i) => Expanded(
                    flex: index == i ? 26 : 11,
                    child: Padding(
                      padding: EdgeInsets.only(right: i < 3 ? 6 : 0),
                      child: Material(
                        color: index == i ? Palette.ink : Palette.background,
                        borderRadius: BorderRadius.circular(40),
                        child: InkWell(
                          key: ValueKey('tab-$i'),
                          onTap: () => setState(() => index = i),
                          borderRadius: BorderRadius.circular(40),
                          child: SizedBox(
                            height: 56,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  icons[i],
                                  color: index == i
                                      ? Colors.white
                                      : Palette.muted,
                                  size: 24,
                                ),
                                if (index == i) ...[
                                  const SizedBox(width: 8),
                                  Text(
                                    labels[i],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
