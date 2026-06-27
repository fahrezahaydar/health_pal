import 'package:equatable/equatable.dart';

class DoctorScheduleEntity extends Equatable {
  final String id;
  final String doctorId;
  final int dayOfWeek;
  final String startTime;
  final String endTime;
  final int slotDurationMinutes;
  final bool isActive;

  const DoctorScheduleEntity({
    required this.id,
    required this.doctorId,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    this.slotDurationMinutes = 30,
    this.isActive = true,
  });

  String get dayName {
    const days = [
      'Minggu', 'Senin', 'Selasa', 'Rabu',
      'Kamis', "Jum'at", 'Sabtu',
    ];
    if (dayOfWeek < 0 || dayOfWeek > 6) return 'Hari ke-$dayOfWeek';
    return days[dayOfWeek];
  }

  String get timeDisplay {
    final s = _formatTime12h(startTime);
    final e = _formatTime12h(endTime);
    return '$s – $e';
  }

  static String _formatTime12h(String time) {
    final parts = time.split(':');
    if (parts.length < 2) return time;
    final hour = int.parse(parts[0]);
    final minute = parts[1];
    final period = hour >= 12 ? 'PM' : 'AM';
    final h12 = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    return '${h12.toString().padLeft(2, '0')}:$minute $period';
  }

  static DoctorScheduleEntity mock() => const DoctorScheduleEntity(
        id: 'sk-1',
        doctorId: 'sk-doctor',
        dayOfWeek: 1,
        startTime: '08:00:00',
        endTime: '17:00:00',
      );

  @override
  List<Object?> get props => [
        id,
        doctorId,
        dayOfWeek,
        startTime,
        endTime,
        slotDurationMinutes,
        isActive,
      ];
}
