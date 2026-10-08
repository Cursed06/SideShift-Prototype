import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../widgets/app_header.dart';

class ShiftDetailScreen extends StatefulWidget {
  const ShiftDetailScreen({super.key});

  @override
  State<ShiftDetailScreen> createState() => _ShiftDetailScreenState();
}

class _ShiftDetailScreenState extends State<ShiftDetailScreen> {
  final _currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  void _showClaimConfirmation(BuildContext context) {
    final appState = AppStateProvider.of(context);
    final shift = appState.selectedShift;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.escrowGreenBg,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.shield, color: AppTheme.escrowGreenDark, size: 24),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Konfirmasi Klaim Shift',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                      ),
                      Text(
                        'Dana upah Anda dijamin otomatis oleh Smart Escrow.',
                        style: TextStyle(fontSize: 11, color: AppTheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Summary Card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text('Posisi:', style: TextStyle(fontSize: 12, color: AppTheme.onSurfaceVariant)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          shift.title,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
                          textAlign: TextAlign.right,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Text('Lokasi:', style: TextStyle(fontSize: 12, color: AppTheme.onSurfaceVariant)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          shift.businessName,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
                          textAlign: TextAlign.right,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Text('Jadwal:', style: TextStyle(fontSize: 12, color: AppTheme.onSurfaceVariant)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          shift.timeSlot,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
                          textAlign: TextAlign.right,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Dana Terkunci:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800)),
                      Text(
                        _currencyFormat.format(shift.totalPay),
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppTheme.escrowGreenDark),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: const Text('Batal', style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      appState.claimShift(shift);
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Shift "${shift.title}" Berhasil Diklaim!'),
                          backgroundColor: AppTheme.escrowGreenDark,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    child: const Text('Konfirmasi', style: TextStyle(fontWeight: FontWeight.w800)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context);
    final shift = appState.selectedShift;

    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: const AppHeader(
        title: 'Detail Lowongan Shift',
        showBack: true,
        showRoleSwitch: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Venue Image
            Stack(
              children: [
                Image.network(
                  shift.venueImage,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withValues(alpha: 0.8),
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.8),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.fiber_manual_record, size: 8, color: AppTheme.escrowGreen),
                        const SizedBox(width: 6),
                        Text(
                          'Escrow Dana ${_currencyFormat.format(shift.totalPay)} Terkunci',
                          style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 12,
                  left: 16,
                  right: 16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              shift.businessName,
                              style: const TextStyle(fontSize: 12, color: AppTheme.primaryFixed, fontWeight: FontWeight.w800),
                            ),
                            Text(
                              shift.title,
                              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star, size: 14, color: Colors.amber),
                            const SizedBox(width: 4),
                            Text(
                              '${shift.rating}',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Urgent Banner
                  if (shift.isUrgent)
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 14),
                      decoration: BoxDecoration(
                        color: AppTheme.urgentOrangeBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.urgentOrangeBorder),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.local_fire_department, color: AppTheme.urgentOrange),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  shift.urgentBonus ?? 'Surge Pay Boost',
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFFC2410C)),
                                ),
                                const Text(
                                  'Bonus kehadiran tepat waktu langsung dicairkan.',
                                  style: TextStyle(fontSize: 10, color: Color(0xFF9A3412)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Smart Escrow Card
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
                            Icon(Icons.lock, size: 16, color: AppTheme.escrowGreenDark),
                            SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'Jaminan Smart Escrow',
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
                              ),
                            ),
                            Text(
                              '100% Aman',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.escrowGreenDark,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppTheme.surfaceContainerLow,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Column(
                                  children: [
                                    const Text('Upah/Jam', style: TextStyle(fontSize: 9, color: AppTheme.onSurfaceVariant)),
                                    const SizedBox(height: 2),
                                    Text(
                                      _currencyFormat.format(shift.hourlyRate),
                                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: AppTheme.primary),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppTheme.surfaceContainerLow,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Column(
                                  children: [
                                    const Text('Durasi', style: TextStyle(fontSize: 9, color: AppTheme.onSurfaceVariant)),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${shift.durationHours} Jam',
                                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryFixed.withValues(alpha: 0.5),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Column(
                                  children: [
                                    const Text('Total Cair', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: AppTheme.primary)),
                                    const SizedBox(height: 2),
                                    Text(
                                      _currencyFormat.format(shift.totalPay),
                                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: AppTheme.primary),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Schedule & Location
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
                          'JADWAL & LOKASI',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: AppTheme.onSurface),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 16, color: AppTheme.primary),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(shift.date, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800)),
                                Text(shift.timeSlot, style: const TextStyle(fontSize: 11, color: AppTheme.onSurfaceVariant)),
                              ],
                            ),
                          ],
                        ),
                        const Divider(height: 20),
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 16, color: AppTheme.escrowGreenDark),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(shift.location, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800)),
                                  Text('${shift.distanceKm} km dari posisi GPS Anda', style: const TextStyle(fontSize: 11, color: AppTheme.onSurfaceVariant)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Dress Code & Requirements
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
                          'PERSYARATAN & DRESS CODE',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: AppTheme.onSurface),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.amber.shade200),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.checkroom, size: 16, color: Colors.brown),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  shift.dressCode,
                                  style: const TextStyle(fontSize: 11, color: Colors.brown, height: 1.3),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        ...shift.requirements.map((req) => Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.check_circle, size: 14, color: AppTheme.primary),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(req, style: const TextStyle(fontSize: 11, color: AppTheme.onSurface)),
                                  ),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Task Checklist
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
                          'TUGAS UTAMA SHIFT',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: AppTheme.onSurface),
                        ),
                        const SizedBox(height: 10),
                        ...shift.tasks.asMap().entries.map((entry) => Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppTheme.surfaceContainerLow,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 10,
                                    backgroundColor: AppTheme.primaryFixed,
                                    child: Text(
                                      '${entry.key + 1}',
                                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppTheme.primary),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(entry.value, style: const TextStyle(fontSize: 11, color: AppTheme.onSurface)),
                                  ),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade200)),
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Estimasi Upah', style: TextStyle(fontSize: 10, color: AppTheme.onSurfaceVariant)),
                  Text(
                    _currencyFormat.format(shift.totalPay),
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: AppTheme.primary),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                    onPressed: () => _showClaimConfirmation(context),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            'Klaim Shift Ini',
                            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(Icons.arrow_forward, size: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
