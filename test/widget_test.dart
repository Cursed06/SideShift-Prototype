import 'io_mock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sideshift/main.dart';

void main() {
  setUpAll(() {
    setupHttpOverrides();
  });

  testWidgets('Full SideShift Worker & Employer Flow Test', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(412 * 2.625, 915 * 2.625);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    // 1. Launch App
    await tester.pumpWidget(const SideShiftApp());
    await tester.pumpAndSettle();

    // Verify Splash Screen elements
    expect(find.text('SideShift'), findsWidgets);
    expect(find.text('Kerja Shift Fleksibel,\nUpah Cair Instan.'), findsOneWidget);
    expect(find.text('Cari Shift Kerja'), findsOneWidget);
    expect(find.text('Pasang Lowongan Shift'), findsOneWidget);

    // 2. Click "Mulai Eksplorasi Shift" -> Navigate to Login Screen
    final startButton = find.text('Mulai Eksplorasi Shift');
    await tester.ensureVisible(startButton);
    await tester.tap(startButton);
    await tester.pumpAndSettle();

    // Verify Login Screen
    expect(find.text('Masuk dengan Nomor WhatsApp'), findsOneWidget);
    expect(find.text('Lanjut & Kirim OTP'), findsOneWidget);

    // 3. Submit phone to enter OTP step
    await tester.tap(find.text('Lanjut & Kirim OTP'));
    await tester.pumpAndSettle();
    expect(find.text('Masukkan Kode OTP'), findsOneWidget);
    expect(find.text('Verifikasi & Masuk'), findsOneWidget);

    // 4. Verify OTP -> Enter MainTabScaffold (Job Feed)
    await tester.tap(find.text('Verifikasi & Masuk'));
    await tester.pumpAndSettle();

    expect(find.text('PELUANG SHIFT TERSEDIA'), findsOneWidget);
    expect(find.text('Senior Barista Espresso & Manual Brew'), findsOneWidget);

    // 5. Open Shift Detail Screen
    final detailButton = find.text('Detail').first;
    await tester.ensureVisible(detailButton);
    await tester.tap(detailButton);
    await tester.pumpAndSettle();

    expect(find.text('Detail Lowongan Shift'), findsOneWidget);
    expect(find.text('Jaminan Smart Escrow'), findsOneWidget);

    // 6. Click "Klaim Shift Ini" in bottomSheet
    final claimBtn = find.text('Klaim Shift Ini');
    await tester.tap(claimBtn, warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(find.text('Konfirmasi Klaim Shift'), findsOneWidget);
    await tester.tap(find.text('Konfirmasi'));
    await tester.pumpAndSettle();

    // 7. Should navigate to Active Shift Command Center (status is 'claimed')
    expect(find.text('Command Center Shift Aktif'), findsOneWidget);
    expect(find.text('SIAP CLOCK-IN'), findsOneWidget);
    expect(find.text('WAKTU BERJALAN'), findsOneWidget);

    // 8. Open QR Scanner for Punch-In
    final qrButton = find.text('Buka Scanner QR Punch-In');
    await tester.ensureVisible(qrButton);
    await tester.tap(qrButton);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('QR Punch-In Verifikasi'), findsOneWidget);
    expect(find.text('GPS Geofence: Akurat (8m)'), findsOneWidget);

    // Go back to Active Shift
    final backBtn = find.byIcon(Icons.arrow_back_ios_new).first;
    await tester.tap(backBtn);
    await tester.pumpAndSettle();

    // 9. Now simulate Active duty & Clock-Out
    final punchInBtn = find.text('Clock-In Sekarang & Mulai Bertugas');
    await tester.ensureVisible(punchInBtn);
    await tester.tap(punchInBtn);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Perform scan in QR screen
    final scanSimBtn = find.text('Simulasi Scan Punch-In');
    await tester.tap(scanSimBtn);
    // Advance timers for scan simulation (600ms + 400ms)
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    // Now back at Active Shift in 'in_progress' state!
    expect(find.text('SEDANG BERTUGAS'), findsOneWidget);

    // 10. Clock-Out & Release Escrow
    final clockOutButton = find.textContaining('Clock-Out & Cairkan Upah');
    await tester.ensureVisible(clockOutButton);
    await tester.tap(clockOutButton);
    await tester.pumpAndSettle();

    expect(find.text('Shift Selesai & Upah Cair'), findsOneWidget);
    expect(find.text('Smart Escrow Berhasil Dicairkan'), findsOneWidget);
    expect(find.text('RINCIAN PEMBAYARAN SHIFT'), findsOneWidget);

    // 11. Open Profile Screen via Bottom Nav
    final backBtnEscrow = find.byIcon(Icons.arrow_back_ios_new).first;
    await tester.tap(backBtnEscrow);
    await tester.pumpAndSettle();

    final akunTab = find.text('Akun');
    await tester.tap(akunTab);
    await tester.pumpAndSettle();

    expect(find.text('Akun & Dompet SideShift'), findsOneWidget);
    expect(find.text('DOMPET PENDAPATAN'), findsOneWidget);
    expect(find.text('Tarik Dana Instan'), findsOneWidget);

    // 12. Switch to Employer Mode via Header
    final roleBadge = find.text('Pekerja');
    await tester.tap(roleBadge);
    await tester.pumpAndSettle();

    expect(find.text('Live Roster & Panic Hub'), findsOneWidget);
    expect(find.text('Kopi Kenangan Senopati'), findsOneWidget);
    expect(find.text('Panggil Staf Backup Darurat (SOS)'), findsOneWidget);

    // 13. Test Emergency Backup Dispatch
    final sosButton = find.text('Panggil Staf Backup Darurat (SOS)');
    await tester.ensureVisible(sosButton);
    await tester.tap(sosButton);
    await tester.pumpAndSettle();

    expect(find.text('Panggil Backup Darurat'), findsOneWidget);
    await tester.tap(find.text('Aktifkan Sekarang'));
    await tester.pumpAndSettle();

    expect(find.text('Fauzan Ramadhan (Emergency Backup)'), findsOneWidget);
  });
}
