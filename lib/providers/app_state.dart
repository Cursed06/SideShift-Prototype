import 'dart:async';
import 'package:flutter/material.dart';
import '../models/shift.dart';
import '../data/mock_data.dart';

enum AppRole { worker, employer }

class AppState extends ChangeNotifier {
  AppRole _role = AppRole.worker;
  AppRole get role => _role;

  int _currentTabIndex = 0;
  int get currentTabIndex => _currentTabIndex;

  Shift _selectedShift = MockData.shifts[0];
  Shift get selectedShift => _selectedShift;

  final Set<String> _bookmarks = {'shift-101', 'shift-103'};
  Set<String> get bookmarks => _bookmarks;

  // Active Shift State
  String _activeShiftStatus = 'in_progress'; // 'none', 'claimed', 'in_progress', 'completed'
  String get activeShiftStatus => _activeShiftStatus;

  int _elapsedSeconds = 9840; // 2h 44m
  int get elapsedSeconds => _elapsedSeconds;

  int _accruedEarnings = 131250;
  int get accruedEarnings => _accruedEarnings;

  List<int> _completedTasks = [0, 1, 2];
  List<int> get completedTasks => _completedTasks;

  Timer? _dutyTimer;

  // User & Roster State
  final UserProfile _userProfile = MockData.userProfile;
  UserProfile get userProfile => _userProfile;

  final List<Shift> _shifts = List.from(MockData.shifts);
  List<Shift> get shifts => _shifts;

  final List<TransactionRecord> _transactions = List.from(MockData.transactions);
  List<TransactionRecord> get transactions => _transactions;

  final List<RosterWorker> _roster = List.from(MockData.employerRoster);
  List<RosterWorker> get roster => _roster;

  AppState() {
    _startDutyTimer();
  }

  void _startDutyTimer() {
    _dutyTimer?.cancel();
    _dutyTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_activeShiftStatus == 'in_progress') {
        _elapsedSeconds++;
        _accruedEarnings = ((_selectedShift.hourlyRate / 3600) * _elapsedSeconds).round();
        notifyListeners();
      }
    });
  }

  void setRole(AppRole newRole) {
    _role = newRole;
    _currentTabIndex = 0;
    notifyListeners();
  }

  void setTabIndex(int index) {
    _currentTabIndex = index;
    notifyListeners();
  }

  void setSelectedShift(Shift shift) {
    _selectedShift = shift;
    notifyListeners();
  }

  void toggleBookmark(String shiftId) {
    if (_bookmarks.contains(shiftId)) {
      _bookmarks.remove(shiftId);
    } else {
      _bookmarks.add(shiftId);
    }
    notifyListeners();
  }

  void toggleTask(int index) {
    if (_completedTasks.contains(index)) {
      _completedTasks.remove(index);
    } else {
      _completedTasks.add(index);
    }
    notifyListeners();
  }

  void claimShift(Shift shift) {
    _selectedShift = shift;
    _activeShiftStatus = 'claimed';
    _elapsedSeconds = 0;
    _accruedEarnings = 0;
    _completedTasks = [];
    _currentTabIndex = 1; // Switch to Shift Saya
    notifyListeners();
  }

  void performPunchIn() {
    _activeShiftStatus = 'in_progress';
    _elapsedSeconds = 10;
    _accruedEarnings = 500;
    notifyListeners();
  }

  void completeShiftAndReleaseEscrow() {
    _activeShiftStatus = 'completed';
    _userProfile.walletBalance += _selectedShift.totalPay;

    final newTx = TransactionRecord(
      id: 'TX-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
      type: 'earning',
      title: 'Upah Shift: ${_selectedShift.title}',
      venue: _selectedShift.businessName,
      amount: _selectedShift.totalPay,
      status: 'COMPLETED',
      date: 'Baru saja',
      method: 'BI-FAST Instant Escrow Release',
    );

    _transactions.insert(0, newTx);
    notifyListeners();
  }

  void triggerEmergencyBackup() {
    final backup = RosterWorker(
      id: 'worker-backup-${DateTime.now().millisecondsSinceEpoch}',
      name: 'Fauzan Ramadhan (Emergency Backup)',
      avatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=120&auto=format&fit=crop&q=80',
      role: 'Senior Barista Backup',
      shift: '14:30 - 20:00 (5.5 Jam)',
      status: 'ON_DUTY',
      checkInTime: 'Tiba 5 menit lagi',
      gpsStatus: '150m dari Kafe (Jl. Senopati)',
      escrowLocked: 320000,
      tasksCompleted: 'Standby',
    );

    _roster.insert(0, backup);
    notifyListeners();
  }

  void createNewShift(Shift shift) {
    _shifts.insert(0, shift);
    _currentTabIndex = 0; // go to roster
    notifyListeners();
  }

  bool withdraw(int amount, PayoutAccount account) {
    if (amount > _userProfile.walletBalance || amount <= 0) {
      return false;
    }

    _userProfile.walletBalance -= amount;

    final newTx = TransactionRecord(
      id: 'TX-WD-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
      type: 'withdraw',
      title: 'Penarikan Dana ke ${account.provider} (${account.accountNumber})',
      venue: 'Transfer BI-FAST ${account.provider}',
      amount: -amount,
      status: 'COMPLETED',
      date: 'Baru saja',
      method: 'BI-FAST Real-time Transfer (Rp 0 Biaya)',
    );

    _transactions.insert(0, newTx);
    notifyListeners();
    return true;
  }

  @override
  void dispose() {
    _dutyTimer?.cancel();
    super.dispose();
  }
}

class AppStateProvider extends InheritedNotifier<AppState> {
  const AppStateProvider({
    super.key,
    required AppState super.notifier,
    required super.child,
  });

  static AppState of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppStateProvider>()!.notifier!;
  }
}
