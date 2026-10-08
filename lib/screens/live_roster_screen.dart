import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../widgets/app_header.dart';
import 'create_shift_screen.dart';

class LiveRosterScreen extends StatelessWidget {
  const LiveRosterScreen({super.key});

  void _showEmergencyDialog(BuildContext context) {
    final appState = AppStateProvider.of(context);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Row(
          children: [
            Icon(Icons.bolt, color: Colors.red, size: 28),
            SizedBox(width: 8),
            Expanded(
              child: Text('Panggil Backup Darurat', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
            ),
          ],
        ),
        content: const Text(
          'Sistem AI SideShift akan menyiarkan panggilan darurat berinsentif ke 5 Barista terdekat dalam radius 2 km untuk tiba dalam < 15 menit.',
          style: TextStyle(fontSize: 12, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              appState.triggerEmergencyBackup();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('🚨 Protokol Darurat Aktif: Memanggil 3 Barista Backup Terdekat...'),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Aktifkan Sekarang'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context);
    final roster = appState.roster;
    final currency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: const AppHeader(title: 'Live Roster & Panic Hub'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 90),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Store Header Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'OUTLET MITRA AKTIF',
                          style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: AppTheme.urgentOrange),
                        ),
                        const Text(
                          'Kopi Kenangan Senopati',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppTheme.onSurface),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.fiber_manual_record, size: 8, color: AppTheme.escrowGreen),
                            const SizedBox(width: 4),
                            Text(
                              '${roster.length} Staf Sedang Shift',
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.escrowGreenDark),
                            ),
                            const Text(' • ', style: TextStyle(color: Colors.grey)),
                            const Flexible(
                              child: Text(
                                'Escrow: Rp 813.000',
                                style: TextStyle(fontSize: 11, color: AppTheme.onSurfaceVariant),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor: AppTheme.urgentOrangeBg,
                      foregroundColor: AppTheme.urgentOrange,
                    ),
                    icon: const Icon(Icons.add, size: 20),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const CreateShiftScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Emergency Panic Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF450A0A),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: Colors.red.shade900),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded, size: 18, color: Colors.amberAccent),
                      const SizedBox(width: 6),
                      const Expanded(
                        child: Text(
                          'RAPID EMERGENCY DISPATCH',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white70),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          '< 15 MENIT RESPON',
                          style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Pekerja Berhalangan / Pengunjung Membludak?',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Tekan tombol darurat untuk memanggil staf pengganti otomatis terdekat.',
                    style: TextStyle(fontSize: 11, color: Colors.white70),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade600,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        elevation: 0,
                      ),
                      icon: const Icon(Icons.bolt, size: 18, color: Colors.amberAccent),
                      label: const Text('Panggil Staf Backup Darurat (SOS)', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
                      onPressed: () => _showEmergencyDialog(context),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Live Roster List
            const Row(
              children: [
                Expanded(
                  child: Text(
                    'DAFTAR PEKERJA SEDANG SHIFT',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: AppTheme.onSurface),
                  ),
                ),
                Text(
                  'Live GPS Monitor',
                  style: TextStyle(fontSize: 10, color: AppTheme.onSurfaceVariant, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 10),

            ...roster.map((worker) => Container(
              margin: const EdgeInsets.only(bottom: 12),
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
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(worker.avatar),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(worker.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800), maxLines: 1, overflow: TextOverflow.ellipsis),
                            Text(worker.role, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.primary), maxLines: 1, overflow: TextOverflow.ellipsis),
                            Text(worker.shift, style: const TextStyle(fontSize: 10, color: AppTheme.onSurfaceVariant), maxLines: 1, overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: worker.status == 'ON_DUTY' ? AppTheme.escrowGreenBg : Colors.amber.shade50,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: worker.status == 'ON_DUTY' ? AppTheme.escrowGreen.withValues(alpha: 0.3) : Colors.amber.shade200,
                          ),
                        ),
                        child: Text(
                          worker.status == 'ON_DUTY' ? 'ON DUTY' : 'EN ROUTE',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                            color: worker.status == 'ON_DUTY' ? AppTheme.escrowGreenDark : Colors.brown,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Punch-In', style: TextStyle(fontSize: 9, color: AppTheme.onSurfaceVariant)),
                              Text(worker.checkInTime, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text('Posisi GPS', style: TextStyle(fontSize: 9, color: AppTheme.onSurfaceVariant)),
                              Text(worker.gpsStatus, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.escrowGreenDark), maxLines: 1, overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  Row(
                    children: [
                      const Icon(Icons.lock, size: 12, color: AppTheme.primary),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          'Escrow: ${currency.format(worker.escrowLocked)}',
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      InkWell(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Menghubungi ${worker.name}...')),
                          );
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.phone, size: 14, color: AppTheme.primary),
                        ),
                      ),
                      const SizedBox(width: 6),
                      InkWell(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Shift & tugas ${worker.name} disetujui.')),
                          );
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryFixed,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text('Verifikasi', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppTheme.primary)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
