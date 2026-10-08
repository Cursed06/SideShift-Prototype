import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/app_header.dart';
import 'login_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: const AppHeader(
        showBack: true,
        showRoleSwitch: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.primaryFixed,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.auto_awesome, size: 12, color: AppTheme.primary),
                  SizedBox(width: 4),
                  Text(
                    'Protokol Kerja Mikro #1 Indonesia',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppTheme.primary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            const Text(
              'Kerja Shift Fleksibel,\nUpah Cair Detik Ini Juga.',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w900,
                color: AppTheme.onSurface,
                height: 1.2,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'SideShift menghubungkan barista, kru event, dan staf retail dengan kafe serta bisnis terpercaya. Dilindungi Smart Escrow otomatis.',
              style: TextStyle(fontSize: 12, color: AppTheme.onSurfaceVariant, height: 1.4),
            ),
            const SizedBox(height: 20),

            // Live Metrics
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.inverseSurface,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text('1,420+', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white)),
                      Text('Shift Aktif', style: TextStyle(fontSize: 10, color: Colors.white60)),
                    ],
                  ),
                  Column(
                    children: [
                      Text('< 15 Mnt', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppTheme.escrowGreen)),
                      Text('Cair BI-FAST', style: TextStyle(fontSize: 10, color: Colors.white60)),
                    ],
                  ),
                  Column(
                    children: [
                      Text('4.96 ⭐', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.amber)),
                      Text('Rating Mitra', style: TextStyle(fontSize: 10, color: Colors.white60)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'MENGAPA MEMILIH SIDESHIFT?',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: AppTheme.onSurface),
            ),
            const SizedBox(height: 12),

            _buildPillar(
              icon: Icons.lock_outline,
              title: 'Smart Escrow Protection',
              desc: 'Upah dikunci oleh pemberi kerja sebelum shift dimulai. Dana langsung cair begitu punch-out.',
              color: AppTheme.primary,
            ),
            const SizedBox(height: 10),
            _buildPillar(
              icon: Icons.bolt,
              title: 'Pencairan BI-FAST Seketika',
              desc: 'Tarik saldo ke rekening BCA, Mandiri, BRI, GoPay, OVO, atau ShopeePay 24/7 tanpa biaya.',
              color: AppTheme.escrowGreenDark,
            ),
            const SizedBox(height: 10),
            _buildPillar(
              icon: Icons.access_time,
              title: 'Emergency Backup Dispatch',
              desc: 'Untuk pemilik kafe: jika staf mendadak absen, sistem memanggil barista pengganti dalam 15 menit.',
              color: AppTheme.urgentOrange,
            ),
            const SizedBox(height: 24),

            // Bottom CTA
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
                child: const Text('Mulai Sekarang (Gratis)', style: TextStyle(fontWeight: FontWeight.w800)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPillar({
    required IconData icon,
    required String title,
    required String desc,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800)),
                const SizedBox(height: 2),
                Text(desc, style: const TextStyle(fontSize: 11, color: AppTheme.onSurfaceVariant, height: 1.3)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
