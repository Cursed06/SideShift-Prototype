import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../providers/app_state.dart';
import 'app_header.dart';
import '../screens/qr_punch_screen.dart';
import '../screens/create_shift_screen.dart';

class CustomBottomNav extends StatelessWidget {
  const CustomBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context);
    final isWorker = appState.role == AppRole.worker;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Container(
          height: 68,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: isWorker
                ? [
                    Expanded(
                      child: _buildNavItem(
                        context,
                        icon: Icons.explore_outlined,
                        activeIcon: Icons.explore,
                        label: 'Eksplor',
                        index: 0,
                        currentIndex: appState.currentTabIndex,
                        onTap: () => appState.setTabIndex(0),
                      ),
                    ),
                    Expanded(
                      child: _buildNavItem(
                        context,
                        icon: Icons.schedule_outlined,
                        activeIcon: Icons.schedule,
                        label: 'Shift Saya',
                        index: 1,
                        currentIndex: appState.currentTabIndex,
                        hasBadge: appState.activeShiftStatus == 'in_progress',
                        onTap: () => appState.setTabIndex(1),
                      ),
                    ),
                    // Center Floating QR Punch Button
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const QRPunchScreen()),
                        );
                      },
                      child: Container(
                        width: 48,
                        height: 48,
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppTheme.primaryContainer, AppTheme.primary],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primary.withValues(alpha: 0.35),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.qr_code_scanner,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                    Expanded(
                      child: _buildNavItem(
                        context,
                        icon: Icons.person_outline,
                        activeIcon: Icons.person,
                        label: 'Akun',
                        index: 2,
                        currentIndex: appState.currentTabIndex,
                        onTap: () => appState.setTabIndex(2),
                      ),
                    ),
                    Expanded(
                      child: _buildNavItem(
                        context,
                        icon: Icons.settings_outlined,
                        activeIcon: Icons.settings,
                        label: 'Pengaturan',
                        index: 3,
                        currentIndex: appState.currentTabIndex,
                        onTap: () => appState.setTabIndex(3),
                      ),
                    ),
                  ]
                : [
                    Expanded(
                      child: _buildNavItem(
                        context,
                        icon: Icons.people_outline,
                        activeIcon: Icons.people,
                        label: 'Live Roster',
                        index: 0,
                        currentIndex: appState.currentTabIndex,
                        onTap: () => appState.setTabIndex(0),
                      ),
                    ),
                    // Center Floating Create Shift Button
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const CreateShiftScreen()),
                        );
                      },
                      child: Container(
                        width: 48,
                        height: 48,
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFEA580C), AppTheme.urgentOrange],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.urgentOrange.withValues(alpha: 0.35),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                    Expanded(
                      child: _buildNavItem(
                        context,
                        icon: Icons.explore_outlined,
                        activeIcon: Icons.explore,
                        label: 'Feed Pasar',
                        index: 1,
                        currentIndex: appState.currentTabIndex,
                        onTap: () => appState.setTabIndex(1),
                      ),
                    ),
                    Expanded(
                      child: _buildNavItem(
                        context,
                        icon: Icons.settings_outlined,
                        activeIcon: Icons.settings,
                        label: 'Pengaturan',
                        index: 2,
                        currentIndex: appState.currentTabIndex,
                        onTap: () => appState.setTabIndex(2),
                      ),
                    ),
                  ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
    required int currentIndex,
    required VoidCallback onTap,
    bool hasBadge = false,
  }) {
    final isSelected = index == currentIndex;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  isSelected ? activeIcon : icon,
                  size: 22,
                  color: isSelected ? AppTheme.primary : AppTheme.secondary,
                ),
                if (hasBadge)
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppTheme.escrowGreen,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                color: isSelected ? AppTheme.primary : AppTheme.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
