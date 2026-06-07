class DateFormatter {
  const DateFormatter._();

  static String toDayMonth(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
    ];
    return '${date.day} ${months[date.month - 1]}';
  }

  static String toFullDate(DateTime date) {
    const months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  static String toTimeOfDay(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  static String dayName(int dayOfWeek) {
    const days = [
      'Minggu', 'Senin', 'Selasa', 'Rabu',
      'Kamis', "Jum'at", 'Sabtu',
    ];
    return days[dayOfWeek % 7];
  }
}
