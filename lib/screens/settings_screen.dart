import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/app_header.dart';
import 'splash_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _nearbyAlerts = true;
  bool _instantPayoutAlerts = true;
  bool _biometrics = true;

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context);

    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: const AppHeader(title: 'Pengaturan & Preferensi'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Role Mode Toggle
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Mode Aplikasi', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800)),
                      Text('Beralih antara Pekerja atau Bisnis', style: TextStyle(fontSize: 10, color: AppTheme.onSurfaceVariant)),
                    ],
                  ),
                  SegmentedButton<AppRole>(
                    segments: const [
                      ButtonSegment(value: AppRole.worker, label: Text('Pekerja', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800))),
                      ButtonSegment(value: AppRole.employer, label: Text('Bisnis', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800))),
                    ],
                    selected: {appState.role},
                    onSelectionChanged: (set) => appState.setRole(set.first),
                    style: SegmentedButton.styleFrom(
                      selectedBackgroundColor: appState.role == AppRole.worker ? AppTheme.primary : AppTheme.urgentOrange,
                      selectedForegroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Emergency SOS Contacts
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.shield_outlined, size: 16, color: AppTheme.escrowGreenDark),
                      SizedBox(width: 6),
                      Text('KONTAK DARURAT (SOS)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: AppTheme.onSurface)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _buildContactRow('Keluarga Inti (Ibu Siti)', '+62 812-3344-5566 (Ibu)'),
                  const SizedBox(height: 6),
                  _buildContactRow('SideShift 24/7 Rapid SOS', '+62 21-5088-7700 (Darurat)'),
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Kunci Biometrik (FaceID)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                      Switch(
                        value: _biometrics,
                        activeTrackColor: AppTheme.primary,
                        onChanged: (v) => setState(() => _biometrics = v),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Notification Switches
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.notifications_outlined, size: 16, color: AppTheme.primary),
                      SizedBox(width: 6),
                      Text('NOTIFIKASI & PERINGATAN', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: AppTheme.onSurface)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Peluang Shift Terdekat (5 km)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                          Text('Notifikasi instan saat ada lowongan baru', style: TextStyle(fontSize: 10, color: AppTheme.onSurfaceVariant)),
                        ],
                      ),
                      Switch(
                        value: _nearbyAlerts,
                        activeTrackColor: AppTheme.primary,
                        onChanged: (v) => setState(() => _nearbyAlerts = v),
                      ),
                    ],
                  ),
                  const Divider(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Peringatan Upah Cair (BI-FAST)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                          Text('Notifikasi transfer dana escrow berhasil', style: TextStyle(fontSize: 10, color: AppTheme.onSurfaceVariant)),
                        ],
                      ),
                      Switch(
                        value: _instantPayoutAlerts,
                        activeTrackColor: AppTheme.primary,
                        onChanged: (v) => setState(() => _instantPayoutAlerts = v),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // App Specs
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: const Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Versi Aplikasi', style: TextStyle(fontSize: 11, color: AppTheme.onSurfaceVariant)),
                      Text('v2.4.0 (Stitch Build 2026.10)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800)),
                    ],
                  ),
                  SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Smart Escrow Protocol', style: TextStyle(fontSize: 11, color: AppTheme.onSurfaceVariant)),
                      Text('Tervalidasi & Terenkripsi', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppTheme.escrowGreenDark)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Logout Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.red.shade200),
                  backgroundColor: Colors.red.shade50,
                  foregroundColor: Colors.red.shade800,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                icon: const Icon(Icons.logout, size: 18),
                label: const Text('Keluar dari Akun', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const SplashScreen()),
                    (route) => false,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactRow(String name, String phone) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800)),
              Text(phone, style: const TextStyle(fontSize: 9, color: AppTheme.onSurfaceVariant)),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppTheme.escrowGreenBg,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text('TERDAFTAR', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: AppTheme.escrowGreenDark)),
          ),
        ],
      ),
    );
  }
}
