import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../widgets/app_header.dart';
import 'qr_punch_screen.dart';
import 'escrow_success_screen.dart';

class ActiveShiftScreen extends StatelessWidget {
  const ActiveShiftScreen({super.key});

  String _formatTime(int totalSeconds) {
    final h = totalSeconds ~/ 3600;
    final m = (totalSeconds % 3600) ~/ 60;
    final s = totalSeconds % 60;
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  void _showSosDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
            SizedBox(width: 8),
            Text('Layanan Darurat SOS', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
          ],
        ),
        content: const Text(
          'Pilih opsi darurat jika Anda mengalami kendala keselamatan, kecelakaan, atau perselisihan operasional.',
          style: TextStyle(fontSize: 12, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Tutup'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('🚨 Sinyal Darurat terkirim ke Tim Tanggap SideShift 24/7.'),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Panggil Bantuan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context);
    final shift = appState.selectedShift;
    final currency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: const AppHeader(title: 'Command Center Shift Aktif'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // High-Contrast Duty Command Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.inverseSurface,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status & Venue
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppTheme.escrowGreen,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        appState.activeShiftStatus == 'in_progress' ? 'SEDANG BERTUGAS' : 'SIAP CLOCK-IN',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.escrowGreen,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const Spacer(),
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            shift.businessName,
                            style: const TextStyle(fontSize: 10, color: Colors.white70, fontWeight: FontWeight.w700),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  Text(
                    shift.title,
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 12, color: Colors.white60),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          shift.location,
                          style: const TextStyle(fontSize: 11, color: Colors.white70),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Clocks & Accrued Earnings
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('WAKTU BERJALAN', style: TextStyle(fontSize: 9, color: Colors.white60, fontWeight: FontWeight.w700)),
                              const SizedBox(height: 2),
                              Text(
                                _formatTime(appState.elapsedSeconds),
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
                              ),
                              const Text('Target: 6 Jam', style: TextStyle(fontSize: 9, color: Colors.white54)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryContainer.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.blue.shade400.withValues(alpha: 0.3)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('UPAH TERKUMPUL', style: TextStyle(fontSize: 9, color: AppTheme.primaryFixed, fontWeight: FontWeight.w700)),
                              const SizedBox(height: 2),
                              Text(
                                currency.format(appState.accruedEarnings),
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppTheme.escrowGreen),
                              ),
                              Text('Total: ${currency.format(shift.totalPay)}', style: const TextStyle(fontSize: 9, color: Colors.white60)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Supervisor and SOS buttons
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundImage: NetworkImage(shift.supervisor.avatar),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          shift.supervisor.name,
                          style: const TextStyle(fontSize: 11, color: Colors.white70, fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.phone, size: 18, color: Colors.white),
                        style: IconButton.styleFrom(backgroundColor: Colors.white12),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Menghubungi ${shift.supervisor.name}...')),
                          );
                        },
                      ),
                      const SizedBox(width: 6),
                      IconButton(
                        icon: const Icon(Icons.warning_amber, size: 18, color: Colors.redAccent),
                        style: IconButton.styleFrom(backgroundColor: Colors.red.withValues(alpha: 0.2)),
                        onPressed: () => _showSosDialog(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Milestone Gates
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
                  const Text(
                    'TAHAPAN & VERIFIKASI SHIFT',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: AppTheme.onSurface),
                  ),
                  const SizedBox(height: 12),
                  _buildMilestone(
                    icon: Icons.check_circle,
                    color: AppTheme.escrowGreenDark,
                    title: 'Clock-In Geofence Terverifikasi',
                    subtitle: '13:54 WIB · Lokasi GPS cocok (Radius 8m)',
                    isDone: true,
                  ),
                  _buildMilestone(
                    icon: Icons.check_circle,
                    color: AppTheme.primary,
                    title: 'Briefing Operasional & Station Setup',
                    subtitle: 'SOP terkonfirmasi oleh supervisor',
                    isDone: true,
                  ),
                  _buildMilestone(
                    icon: Icons.schedule,
                    color: Colors.amber.shade800,
                    title: 'Sedang Menjalankan Shift',
                    subtitle: '${appState.completedTasks.length} dari ${shift.tasks.length} checklist tugas selesai',
                    isDone: false,
                    isCurrent: true,
                  ),
                  _buildMilestone(
                    icon: Icons.lock_outline,
                    color: Colors.grey,
                    title: 'Clock-Out & Pencairan Escrow',
                    subtitle: 'Siap diproses setelah jam kerja',
                    isDone: false,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Tasks Checklist
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
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'CHECKLIST TUGAS HARIAN',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: AppTheme.onSurface),
                        ),
                      ),
                      Text(
                        '${appState.completedTasks.length}/${shift.tasks.length} Selesai',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppTheme.primary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ...shift.tasks.asMap().entries.map((entry) {
                    final isChecked = appState.completedTasks.contains(entry.key);
                    return InkWell(
                      onTap: () => appState.toggleTask(entry.key),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isChecked ? AppTheme.escrowGreenBg : AppTheme.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: isChecked ? AppTheme.escrowGreen.withValues(alpha: 0.3) : Colors.transparent),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isChecked ? Icons.check_box : Icons.check_box_outline_blank,
                              color: isChecked ? AppTheme.escrowGreenDark : Colors.grey,
                              size: 18,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                entry.value,
                                style: TextStyle(
                                  fontSize: 11,
                                  decoration: isChecked ? TextDecoration.lineThrough : null,
                                  color: isChecked ? Colors.grey : AppTheme.onSurface,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Actions
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.escrowGreenDark,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                icon: const Icon(Icons.shield_outlined, size: 20),
                label: Text(
                  appState.activeShiftStatus == 'in_progress'
                      ? 'Clock-Out & Cairkan Upah (${currency.format(shift.totalPay)})'
                      : 'Clock-In Sekarang & Mulai Bertugas',
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                ),
                onPressed: () {
                  if (appState.activeShiftStatus == 'in_progress') {
                    appState.completeShiftAndReleaseEscrow();
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const EscrowSuccessScreen()),
                    );
                  } else {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const QRPunchScreen()),
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              height: 44,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
                icon: const Icon(Icons.qr_code_scanner, size: 18, color: AppTheme.primary),
                label: Text(
                  appState.activeShiftStatus == 'in_progress'
                      ? 'Buka Scanner QR Punch-Out'
                      : 'Buka Scanner QR Punch-In',
                  style: const TextStyle(fontWeight: FontWeight.w800, color: AppTheme.primary, fontSize: 12),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const QRPunchScreen()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMilestone({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required bool isDone,
    bool isCurrent = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: isDone || isCurrent ? AppTheme.onSurface : Colors.grey,
                  ),
                ),
                Text(subtitle, style: const TextStyle(fontSize: 10, color: AppTheme.onSurfaceVariant)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
