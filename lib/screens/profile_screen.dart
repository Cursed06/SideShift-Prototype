import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../widgets/app_header.dart';
import '../widgets/withdraw_dialog.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context);
    final user = appState.userProfile;
    final currency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: const AppHeader(title: 'Akun & Dompet SideShift'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 90),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundImage: NetworkImage(user.avatar),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: const BoxDecoration(
                            color: AppTheme.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.check, size: 10, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                user.name,
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppTheme.onSurface),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                              decoration: BoxDecoration(
                                color: AppTheme.escrowGreenBg,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'KYC VERIFIED',
                                style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: AppTheme.escrowGreenDark),
                              ),
                            ),
                          ],
                        ),
                        Text(user.tagline, style: const TextStyle(fontSize: 11, color: AppTheme.onSurfaceVariant)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryFixed,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                user.tierBadge,
                                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppTheme.primary),
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(Icons.star, size: 12, color: Colors.amber),
                            const SizedBox(width: 2),
                            Flexible(
                              child: Text(
                                '${user.rating} (${user.totalReviews})',
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.brown),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Dynamic Dark Wallet Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.inverseSurface,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.account_balance_wallet, color: AppTheme.primaryFixed, size: 16),
                      const SizedBox(width: 6),
                      const Expanded(
                        child: Text(
                          'DOMPET PENDAPATAN',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white70),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.escrowGreen.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'BI-FAST REAL-TIME',
                          style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: AppTheme.escrowGreen),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text('Total Saldo Dapat Ditarik', style: TextStyle(fontSize: 10, color: Colors.white60)),
                  Text(
                    currency.format(user.walletBalance),
                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        elevation: 0,
                      ),
                      icon: const Icon(Icons.arrow_outward, size: 16),
                      label: const Text('Tarik Dana Instan', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
                      onPressed: () => WithdrawBottomSheet.show(context),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Performance Stats
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      children: [
                        const Text('On-Time Rate', style: TextStyle(fontSize: 10, color: AppTheme.onSurfaceVariant)),
                        const SizedBox(height: 2),
                        Text(user.onTimeRate, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppTheme.escrowGreenDark)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      children: [
                        const Text('Shift Selesai', style: TextStyle(fontSize: 10, color: AppTheme.onSurfaceVariant)),
                        const SizedBox(height: 2),
                        Text('${user.totalShiftsCompleted} Shift', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppTheme.primary)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      children: [
                        const Text('No-Show', style: TextStyle(fontSize: 10, color: AppTheme.onSurfaceVariant)),
                        const SizedBox(height: 2),
                        Text('${user.noShowCount}x', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Skills and Certifications
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
                  const Text('KEAHLIAN TERVERIFIKASI', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: AppTheme.onSurface)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: user.skills.map((s) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Text('#$s', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                    )).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Transactions Ledger
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('RIWAYAT TRANSAKSI', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: AppTheme.onSurface)),
                      Text('BI-FAST 24/7', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...appState.transactions.map((tx) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: tx.amount > 0 ? AppTheme.escrowGreenBg : AppTheme.surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            tx.amount > 0 ? Icons.arrow_downward : Icons.arrow_upward,
                            size: 16,
                            color: tx.amount > 0 ? AppTheme.escrowGreenDark : AppTheme.onSurface,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(tx.title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800), maxLines: 1, overflow: TextOverflow.ellipsis),
                              Text('${tx.date} · ${tx.venue}', style: const TextStyle(fontSize: 9, color: AppTheme.onSurfaceVariant), maxLines: 1, overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${tx.amount > 0 ? '+' : ''}${currency.format(tx.amount)}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            color: tx.amount > 0 ? AppTheme.escrowGreenDark : AppTheme.onSurface,
                          ),
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
    );
  }
}
