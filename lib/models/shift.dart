class Supervisor {
  final String name;
  final String phone;
  final String avatar;

  Supervisor({
    required this.name,
    required this.phone,
    required this.avatar,
  });
}

class Shift {
  final String id;
  final String title;
  final String businessName;
  final String businessLogo;
  final String venueImage;
  final bool verified;
  final double rating;
  final int reviewCount;
  final String category; // 'fb', 'event', 'retail', 'logistics'
  final bool isUrgent;
  final String? urgentBonus;
  final int hourlyRate;
  final int durationHours;
  final int totalPay;
  final String date;
  final String timeSlot;
  final String location;
  final double distanceKm;
  final bool escrowSecured;
  final int spotsTotal;
  final int spotsLeft;
  final String dressCode;
  final List<String> requirements;
  final List<String> tasks;
  final Supervisor supervisor;

  Shift({
    required this.id,
    required this.title,
    required this.businessName,
    required this.businessLogo,
    required this.venueImage,
    required this.verified,
    required this.rating,
    required this.reviewCount,
    required this.category,
    required this.isUrgent,
    this.urgentBonus,
    required this.hourlyRate,
    required this.durationHours,
    required this.totalPay,
    required this.date,
    required this.timeSlot,
    required this.location,
    required this.distanceKm,
    required this.escrowSecured,
    required this.spotsTotal,
    required this.spotsLeft,
    required this.dressCode,
    required this.requirements,
    required this.tasks,
    required this.supervisor,
  });
}

class PayoutAccount {
  final String id;
  final String provider; // 'BCA', 'GoPay', 'OVO'
  final String accountNumber;
  final String holderName;
  final bool isDefault;

  PayoutAccount({
    required this.id,
    required this.provider,
    required this.accountNumber,
    required this.holderName,
    required this.isDefault,
  });
}

class TransactionRecord {
  final String id;
  final String type; // 'earning', 'withdraw'
  final String title;
  final String venue;
  final int amount;
  final String status;
  final String date;
  final String method;

  TransactionRecord({
    required this.id,
    required this.type,
    required this.title,
    required this.venue,
    required this.amount,
    required this.status,
    required this.date,
    required this.method,
  });
}

class RosterWorker {
  final String id;
  final String name;
  final String avatar;
  final String role;
  final String shift;
  final String status; // 'ON_DUTY', 'EN_ROUTE', 'COMPLETED'
  final String checkInTime;
  final String gpsStatus;
  final int escrowLocked;
  final String tasksCompleted;

  RosterWorker({
    required this.id,
    required this.name,
    required this.avatar,
    required this.role,
    required this.shift,
    required this.status,
    required this.checkInTime,
    required this.gpsStatus,
    required this.escrowLocked,
    required this.tasksCompleted,
  });
}

class UserProfile {
  final String id;
  final String name;
  final String tagline;
  final String phone;
  final String email;
  final String avatar;
  final String tier;
  final String tierBadge;
  final double rating;
  final int totalReviews;
  final String onTimeRate;
  final int totalShiftsCompleted;
  final int noShowCount;
  int walletBalance;
  final List<String> skills;
  final List<PayoutAccount> payoutAccounts;

  UserProfile({
    required this.id,
    required this.name,
    required this.tagline,
    required this.phone,
    required this.email,
    required this.avatar,
    required this.tier,
    required this.tierBadge,
    required this.rating,
    required this.totalReviews,
    required this.onTimeRate,
    required this.totalShiftsCompleted,
    required this.noShowCount,
    required this.walletBalance,
    required this.skills,
    required this.payoutAccounts,
  });
}
