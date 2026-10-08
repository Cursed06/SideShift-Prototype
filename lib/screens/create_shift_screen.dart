import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../models/shift.dart';
import '../widgets/app_header.dart';

class CreateShiftScreen extends StatefulWidget {
  const CreateShiftScreen({super.key});

  @override
  State<CreateShiftScreen> createState() => _CreateShiftScreenState();
}

class _CreateShiftScreenState extends State<CreateShiftScreen> {
  final _currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
  String _selectedRole = 'barista';
  String _shiftTitle = 'Senior Barista Espresso & Manual Brew';
  double _hourlyRate = 45000;
  int _durationHours = 6;
  int _workerCount = 2;
  bool _isUrgent = false;
  bool _isPublishing = false;

  final List<Map<String, dynamic>> _presets = [
    {'id': 'barista', 'label': 'Barista F&B', 'icon': Icons.coffee, 'rate': 45000.0, 'title': 'Senior Barista Espresso & Manual Brew'},
    {'id': 'cashier', 'label': 'Kasir POS', 'icon': Icons.shopping_bag, 'rate': 40000.0, 'title': 'Kasir POS & Front Helper'},
    {'id': 'kitchen', 'label': 'Cook Helper', 'icon': Icons.restaurant, 'rate': 48000.0, 'title': 'Kitchen Helper & Prep Cook'},
    {'id': 'event', 'label': 'Event Usher', 'icon': Icons.confirmation_number, 'rate': 55000.0, 'title': 'Lead Stage Crew & Usher VIP'},
    {'id': 'logistics', 'label': 'Gudang Logistics', 'icon': Icons.inventory_2, 'rate': 42000.0, 'title': 'Order Picker & Logistics Helper'},
  ];

  void _handlePublish() {
    final appState = AppStateProvider.of(context);
    setState(() => _isPublishing = true);

    Future.delayed(const Duration(milliseconds: 1400), () {
      if (!mounted) return;
      final newShift = Shift(
        id: 'shift-${DateTime.now().millisecondsSinceEpoch}',
        title: _shiftTitle,
        businessName: 'Kopi Kenangan Senopati',
        businessLogo: 'https://images.unsplash.com/photo-1554118811-1e0d58224f24?w=120&auto=format&fit=crop&q=80',
        venueImage: 'https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?w=800&auto=format&fit=crop&q=80',
        verified: true,
        rating: 4.9,
        reviewCount: 1,
        category: _selectedRole == 'barista' || _selectedRole == 'kitchen' ? 'fb' : _selectedRole == 'event' ? 'event' : _selectedRole == 'cashier' ? 'retail' : 'logistics',
        isUrgent: _isUrgent,
        urgentBonus: _isUrgent ? 'Rp 30.000 Surge Pay' : null,
        hourlyRate: _hourlyRate.toInt(),
        durationHours: _durationHours,
        totalPay: (_hourlyRate.toInt() * _durationHours) + (_isUrgent ? 30000 : 0),
        date: 'Hari ini, 6 Okt 2026',
        timeSlot: '15:00 - 21:00 WIB',
        location: 'Senopati, Jakarta Selatan',
        distanceKm: 0.8,
        escrowSecured: true,
        spotsTotal: _workerCount,
        spotsLeft: _workerCount,
        dressCode: 'Pakaian rapi hitam, sepatu tertutup.',
        requirements: ['Pengalaman kerja relevan', 'Disiplin dan ramah'],
        tasks: ['Melakukan operasional harian sesuai SOP'],
        supervisor: Supervisor(
          name: 'Store Manager Senopati',
          phone: '+62 811-2233-4455',
          avatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=120&auto=format&fit=crop&q=80',
        ),
      );

      appState.createNewShift(newShift);
      setState(() => _isPublishing = false);
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lowongan Shift Berhasil Dipublikasikan & Smart Escrow Terkunci!'),
          backgroundColor: AppTheme.escrowGreenDark,
          behavior: SnackBarBehavior.floating,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final baseTotal = _hourlyRate.toInt() * _durationHours * _workerCount;
    final surgeTotal = _isUrgent ? 30000 * _workerCount : 0;
    final grossTotal = baseTotal + surgeTotal;
    final platformFee = (grossTotal * 0.05).round();
    final totalEscrow = grossTotal + platformFee;

    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: const AppHeader(
        title: 'Buat Lowongan (2 Menit)',
        showBack: true,
        showRoleSwitch: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Rapid wizard banner
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.urgentOrangeBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.urgentOrangeBorder),
              ),
              child: const Row(
                children: [
                  Icon(Icons.bolt, color: AppTheme.urgentOrange),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('2-Minute Shift Publisher', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFFC2410C))),
                        Text('Dana escrow langsung dikunci & notifikasi disiarkan.', style: TextStyle(fontSize: 10, color: Color(0xFF9A3412))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // 1. Role Preset
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
                  const Text('1. PILIH KATEGORI & POSISI', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: AppTheme.onSurface)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _presets.map((preset) {
                      final isSelected = _selectedRole == preset['id'];
                      return InkWell(
                        onTap: () {
                          setState(() {
                            _selectedRole = preset['id'];
                            _shiftTitle = preset['title'];
                            _hourlyRate = preset['rate'];
                          });
                        },
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? AppTheme.primaryFixed.withValues(alpha: 0.5) : AppTheme.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isSelected ? AppTheme.primary : Colors.grey.shade200,
                              width: isSelected ? 1.5 : 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(preset['icon'] as IconData, size: 16, color: isSelected ? AppTheme.primary : AppTheme.secondary),
                              const SizedBox(width: 6),
                              Text(
                                preset['label'],
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: isSelected ? AppTheme.primary : AppTheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                  const Text('Judul Shift', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppTheme.onSurface)),
                  const SizedBox(height: 4),
                  TextField(
                    controller: TextEditingController(text: _shiftTitle),
                    onChanged: (v) => _shiftTitle = v,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      filled: true,
                      fillColor: AppTheme.surfaceContainerLow,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // 2. Upah & Durasi
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
                  const Text('2. UPAH PER JAM & DURASI', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: AppTheme.onSurface)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Tarif Upah per Jam:', style: TextStyle(fontSize: 12, color: AppTheme.onSurfaceVariant)),
                      Text(
                        '${_currencyFormat.format(_hourlyRate)}/jam',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppTheme.primary),
                      ),
                    ],
                  ),
                  Slider(
                    value: _hourlyRate,
                    min: 35000,
                    max: 100000,
                    divisions: 26,
                    activeColor: AppTheme.primary,
                    onChanged: (v) => setState(() => _hourlyRate = v),
                  ),
                  const Divider(height: 20),

                  Row(
                    children: [
                      // Duration Stepper
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Durasi Jam', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppTheme.surfaceContainerLow,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove, size: 16),
                                    onPressed: () => setState(() => _durationHours = (_durationHours > 3 ? _durationHours - 1 : 3)),
                                  ),
                                  Text('$_durationHours Jam', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900)),
                                  IconButton(
                                    icon: const Icon(Icons.add, size: 16),
                                    onPressed: () => setState(() => _durationHours = (_durationHours < 12 ? _durationHours + 1 : 12)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),

                      // Worker Count Stepper
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Jumlah Pekerja', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppTheme.surfaceContainerLow,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove, size: 16),
                                    onPressed: () => setState(() => _workerCount = (_workerCount > 1 ? _workerCount - 1 : 1)),
                                  ),
                                  Text('$_workerCount Orang', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900)),
                                  IconButton(
                                    icon: const Icon(Icons.add, size: 16),
                                    onPressed: () => setState(() => _workerCount = (_workerCount < 10 ? _workerCount + 1 : 10)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Urgent Boost Toggle
                  InkWell(
                    onTap: () => setState(() => _isUrgent = !_isUrgent),
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _isUrgent ? AppTheme.urgentOrangeBg : AppTheme.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: _isUrgent ? AppTheme.urgentOrange : Colors.transparent),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.local_fire_department, color: _isUrgent ? AppTheme.urgentOrange : Colors.grey, size: 20),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Urgent Surge Boost (+Rp 30.000/staf)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800)),
                                Text('Notifikasi prioritas tertinggi untuk shift mendadak.', style: TextStyle(fontSize: 9, color: AppTheme.onSurfaceVariant)),
                              ],
                            ),
                          ),
                          Checkbox(
                            value: _isUrgent,
                            activeColor: AppTheme.urgentOrange,
                            onChanged: (v) => setState(() => _isUrgent = v ?? false),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // 3. Escrow Total Summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.inverseSurface,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('TOTAL DEPOSIT SMART ESCROW', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white70)),
                      Text('100% REFUNDABLE', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: AppTheme.escrowGreen)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Upah Pokok ($_workerCount staf x $_durationHours jam)', style: const TextStyle(fontSize: 11, color: Colors.white60)),
                      Text(_currencyFormat.format(baseTotal), style: const TextStyle(fontSize: 11, color: Colors.white)),
                    ],
                  ),
                  if (_isUrgent)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Surge Bonus', style: TextStyle(fontSize: 11, color: AppTheme.tertiaryFixed)),
                        Text('+ ${_currencyFormat.format(surgeTotal)}', style: const TextStyle(fontSize: 11, color: AppTheme.tertiaryFixed)),
                      ],
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Biaya Escrow Platform (5%)', style: TextStyle(fontSize: 11, color: Colors.white60)),
                      Text(_currencyFormat.format(platformFee), style: const TextStyle(fontSize: 11, color: Colors.white)),
                    ],
                  ),
                  const Divider(color: Colors.white24, height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total yang Dikunci:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white)),
                      Text(
                        _currencyFormat.format(totalEscrow),
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppTheme.escrowGreen),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.urgentOrange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                icon: _isPublishing
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.lock, size: 18),
                label: Text(
                  _isPublishing ? 'Mengunci Dana Escrow...' : 'Bayar & Publikasikan Shift',
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                ),
                onPressed: _isPublishing ? null : _handlePublish,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
