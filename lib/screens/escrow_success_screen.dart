import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../widgets/app_header.dart';
import '../widgets/withdraw_dialog.dart';

class EscrowSuccessScreen extends StatefulWidget {
  const EscrowSuccessScreen({super.key});

  @override
  State<EscrowSuccessScreen> createState() => _EscrowSuccessScreenState();
}

class _EscrowSuccessScreenState extends State<EscrowSuccessScreen> {
  final _currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
  int _rating = 5;
  bool _feedbackSubmitted = false;

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context);
    final shift = appState.selectedShift;

    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: const AppHeader(
        title: 'Shift Selesai & Upah Cair',
        showBack: true,
        showRoleSwitch: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 80),
        child: Column(
          children: [
            // Celebration Hero Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.escrowGreenDark, Color(0xFF0F172A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.escrowGreen.withValues(alpha: 0.25),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check_circle, color: Colors.white, size: 40),
                  ),
                  const SizedBox(height: 14),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'SMART ESCROW AUTO-RELEASE',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  const Text(
                    'Smart Escrow Berhasil Dicairkan',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Dana langsung masuk ke dompet Anda tanpa potongan.',
                    style: TextStyle(fontSize: 11, color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                  // Amount Callout
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'TOTAL UPAH DITERIMA',
                          style: TextStyle(fontSize: 9, color: Colors.white60, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _currencyFormat.format(shift.totalPay),
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Itemized Transaction Receipt
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
                    'RINCIAN PEMBAYARAN SHIFT',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: AppTheme.onSurface),
                  ),
                  const SizedBox(height: 12),
                  _buildReceiptRow('Nomor Transaksi', 'TX-ESCR-882941'),
                  _buildReceiptRow('Penyedia Kerja', shift.businessName),
                  _buildReceiptRow('Posisi Tugas', shift.title),
                  _buildReceiptRow('Durasi Selesai', '${shift.durationHours} Jam 00 Menit'),
                  _buildReceiptRow('Tarif Satuan', '${_currencyFormat.format(shift.hourlyRate)} / jam'),
                  if (shift.isUrgent)
                    _buildReceiptRow('Surge Pay Boost', '+Rp 25.000 (Tepat Waktu)', isHighlight: true),
                  _buildReceiptRow('Biaya Platform SideShift', 'Rp 0 (Gratis)', isGreen: true),
                  const Divider(height: 20),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Total Masuk ke Dompet',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: AppTheme.onSurface),
                        ),
                      ),
                      Text(
                        _currencyFormat.format(shift.totalPay),
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: AppTheme.escrowGreenDark),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Employer Rating Card
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
                      CircleAvatar(
                        radius: 14,
                        backgroundImage: NetworkImage(shift.supervisor.avatar),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Beri Ulasan untuk ${shift.supervisor.name}',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
                            ),
                            const Text(
                              'Ulasan Anda menjaga kualitas komunitas SideShift',
                              style: TextStyle(fontSize: 10, color: AppTheme.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // 5 Star rating picker
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      final starNum = index + 1;
                      return IconButton(
                        icon: Icon(
                          starNum <= _rating ? Icons.star : Icons.star_border,
                          size: 32,
                          color: starNum <= _rating ? Colors.amber : Colors.grey.shade300,
                        ),
                        onPressed: () => setState(() => _rating = starNum),
                      );
                    }),
                  ),
                  const SizedBox(height: 8),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _feedbackSubmitted ? AppTheme.escrowGreenBg : AppTheme.surfaceContainerLow,
                        foregroundColor: _feedbackSubmitted ? AppTheme.escrowGreenDark : AppTheme.onSurface,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        setState(() => _feedbackSubmitted = true);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('⭐ Ulasan bintang 5 berhasil dikirim!'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      child: Text(
                        _feedbackSubmitted ? '✓ Ulasan Terkirim' : 'Kirim Ulasan Bintang 5',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
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
                  backgroundColor: AppTheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                icon: const Icon(Icons.account_balance_wallet, size: 20),
                label: const Text('Tarik Saldo ke Rekening (BI-FAST)', style: TextStyle(fontWeight: FontWeight.w800)),
                onPressed: () => WithdrawBottomSheet.show(context),
              ),
            ),
            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              height: 46,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
                onPressed: () {
                  appState.setTabIndex(0);
                  Navigator.of(context).pop();
                },
                child: const Text('Kembali ke Cari Shift', style: TextStyle(fontWeight: FontWeight.w700, color: AppTheme.onSurface)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReceiptRow(String label, String value, {bool isHighlight = false, bool isGreen = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.onSurfaceVariant)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: isHighlight
                    ? AppTheme.urgentOrange
                    : (isGreen ? AppTheme.escrowGreenDark : AppTheme.onSurface),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
