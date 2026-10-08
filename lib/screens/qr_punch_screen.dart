import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../providers/app_state.dart';
import 'escrow_success_screen.dart';

class QRPunchScreen extends StatefulWidget {
  const QRPunchScreen({super.key});

  @override
  State<QRPunchScreen> createState() => _QRPunchScreenState();
}

class _QRPunchScreenState extends State<QRPunchScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isScanning = false;
  bool _scanSuccess = false;
  bool _torchOn = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _simulateScan() {
    final appState = AppStateProvider.of(context);
    setState(() => _isScanning = true);

    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      setState(() {
        _isScanning = false;
        _scanSuccess = true;
      });

      Future.delayed(const Duration(milliseconds: 400), () {
        if (!mounted) return;
        if (appState.activeShiftStatus != 'in_progress') {
          appState.performPunchIn();
          Navigator.of(context).pop();
        } else {
          appState.completeShiftAndReleaseEscrow();
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const EscrowSuccessScreen()),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context);
    final isClockIn = appState.activeShiftStatus != 'in_progress';

    return Scaffold(
      backgroundColor: const Color(0xFF0B0F19),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0F19),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          isClockIn ? 'QR Punch-In Verifikasi' : 'QR Punch-Out Selesai',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Header description
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryContainer.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.primary.withValues(alpha: 0.4)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.shield_outlined, size: 14, color: AppTheme.primaryFixed),
                        SizedBox(width: 6),
                        Text(
                          'Smart Geofence Verification',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppTheme.primaryFixed),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    isClockIn ? 'Arahkan Kamera ke QR Toko' : 'Scan QR Toko untuk Selesaikan Shift',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Pastikan Anda berada di area ${appState.selectedShift.businessName}.',
                    style: const TextStyle(fontSize: 11, color: Colors.white60),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),

              // Viewfinder Scanner Box
              Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  color: const Color(0xFF131B2E),
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: Colors.blue.shade800, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primary.withValues(alpha: 0.2),
                      blurRadius: 40,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Viewfinder Corners
                    Positioned(
                      top: 16,
                      left: 16,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(color: AppTheme.primary, width: 4),
                            left: BorderSide(color: AppTheme.primary, width: 4),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 16,
                      right: 16,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(color: AppTheme.primary, width: 4),
                            right: BorderSide(color: AppTheme.primary, width: 4),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 16,
                      left: 16,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: AppTheme.primary, width: 4),
                            left: BorderSide(color: AppTheme.primary, width: 4),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 16,
                      right: 16,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: AppTheme.primary, width: 4),
                            right: BorderSide(color: AppTheme.primary, width: 4),
                          ),
                        ),
                      ),
                    ),

                    if (_scanSuccess)
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: const BoxDecoration(
                              color: AppTheme.escrowGreen,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.check, color: Colors.white, size: 36),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Verifikasi Sukses!',
                            style: TextStyle(color: AppTheme.escrowGreen, fontWeight: FontWeight.w800, fontSize: 14),
                          ),
                        ],
                      )
                    else ...[
                      const Icon(Icons.qr_code, size: 100, color: Colors.white24),
                      // Animated Laser Beam
                      if (_isScanning)
                        AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            return Positioned(
                              top: 30 + (_animationController.value * 190),
                              left: 20,
                              right: 20,
                              child: Container(
                                height: 3,
                                decoration: BoxDecoration(
                                  color: AppTheme.escrowGreen,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppTheme.escrowGreen.withValues(alpha: 0.8),
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                    ],
                  ],
                ),
              ),

              // GPS Geofence Pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF131B2E),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppTheme.escrowGreen.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.location_on, color: AppTheme.escrowGreen, size: 18),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'GPS Geofence: Akurat (8m)',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white),
                          ),
                          Text(
                            'Lokasi: ${appState.selectedShift.location}',
                            style: const TextStyle(fontSize: 10, color: Colors.white60),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppTheme.escrowGreen.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'VALID',
                        style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: AppTheme.escrowGreen),
                      ),
                    ),
                  ],
                ),
              ),

              // Bottom Trigger Buttons
              Row(
                children: [
                  IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor: _torchOn ? Colors.amber : Colors.white12,
                      foregroundColor: _torchOn ? Colors.black : Colors.white,
                      padding: const EdgeInsets.all(14),
                    ),
                    icon: Icon(_torchOn ? Icons.flash_on : Icons.flash_off, size: 22),
                    onPressed: () => setState(() => _torchOn = !_torchOn),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 0,
                        ),
                        icon: _isScanning
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : const Icon(Icons.camera_alt, size: 20),
                        label: Text(
                          _isScanning ? 'Memindai...' : (isClockIn ? 'Simulasi Scan Punch-In' : 'Simulasi Scan Punch-Out'),
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                        ),
                        onPressed: _isScanning ? null : _simulateScan,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
