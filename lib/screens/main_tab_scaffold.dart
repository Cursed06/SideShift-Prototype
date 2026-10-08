import 'package:flutter/material.dart';
import '../providers/app_state.dart';
import '../widgets/app_header.dart';
import '../widgets/custom_bottom_nav.dart';
import 'job_feed_screen.dart';
import 'active_shift_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';
import 'live_roster_screen.dart';

class MainTabScaffold extends StatelessWidget {
  const MainTabScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context);
    final isWorker = appState.role == AppRole.worker;

    final workerScreens = const [
      JobFeedScreen(),
      ActiveShiftScreen(),
      ProfileScreen(),
      SettingsScreen(),
    ];

    final employerScreens = const [
      LiveRosterScreen(),
      JobFeedScreen(),
      SettingsScreen(),
    ];

    final screens = isWorker ? workerScreens : employerScreens;
    final index = appState.currentTabIndex.clamp(0, screens.length - 1);

    return Scaffold(
      body: IndexedStack(
        index: index,
        children: screens,
      ),
      bottomNavigationBar: const CustomBottomNav(),
    );
  }
}
