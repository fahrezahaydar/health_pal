import 'package:flutter/material.dart';
import 'package:iconsax_latest/iconsax_latest.dart';

/// Centralized icon reference untuk seluruh aplikasi.
///
/// SAAT INI: masih memakai Material Icons (Icons.xxx) sebagai placeholder.
/// TODO: User akan mengganti value di bawah ini ke Iconsax.xxx yang sesuai.
/// Setelah semua TODO selesai, `import 'package:flutter/material.dart'`
/// bisa dihapus dari file ini.
class AppIcons {
  AppIcons._();

  // ── Navigation ──
  static const IconData arrowBack = Icons.arrow_back; // TODO: ganti ke iconsax
  static const IconData close = Icons.close; // TODO: ganti ke iconsax
  static const IconData arrowDropDown = Icons.arrow_drop_down; // TODO: ganti ke iconsax
  static const IconData sort = Icons.sort; // TODO: ganti ke iconsax
  static const IconData share = Icons.share_outlined; // TODO: ganti ke iconsax
  static const IconData editCalendar = Icons.edit_calendar; // TODO: ganti ke iconsax

  // ── Search ──
  static const IconData search = Icons.search; // TODO: ganti ke iconsax
  static const IconData searchOff = Icons.search_off; // TODO: ganti ke iconsax

  // ── Auth & Profile ──
  static const IconData person = Icons.person; // TODO: ganti ke iconsax
  static const IconData email = Icons.email; // TODO: ganti ke iconsax
  static const IconData lock = Icons.lock; // TODO: ganti ke iconsax
  static const IconData visibilityOff = Icons.visibility_off; // TODO: ganti ke iconsax
  static const IconData visibility = Icons.visibility; // TODO: ganti ke iconsax
  static const IconData logout = Icons.logout; // TODO: ganti ke iconsax
  static const IconData settings = Icons.settings; // TODO: ganti ke iconsax
  static const IconData help = Icons.help; // TODO: ganti ke iconsax
  static const IconData description = Icons.description; // TODO: ganti ke iconsax
  static const IconData notifications = Icons.notifications; // TODO: ganti ke iconsax
  static const IconData favorite = Icons.favorite; // TODO: ganti ke iconsax
  static const IconData favoriteBorder = Icons.favorite_border; // TODO: ganti ke iconsax

  // ── Booking & Appointment ──
  static const IconData calendarToday = Icons.calendar_today; // TODO: ganti ke iconsax
  static const IconData accessTime = Icons.access_time; // TODO: ganti ke iconsax
  static const IconData checkCircle = Icons.check_circle; // TODO: ganti ke iconsax
  static const IconData check = Icons.check; // TODO: ganti ke iconsax

  // ── Medical & Clinic ──
  static const IconData localHospital = Icons.local_hospital; // TODO: ganti ke iconsax
  static const IconData localHospitalOutlined = Icons.local_hospital_outlined; // TODO: ganti ke iconsax
  static const IconData locationOn = Icons.location_on; // TODO: ganti ke iconsax
  static const IconData locationOff = Icons.location_off; // TODO: ganti ke iconsax
  static const IconData locationDisabled = Icons.location_disabled; // TODO: ganti ke iconsax
  static const IconData phone = Icons.phone; // TODO: ganti ke iconsax
  static const IconData myLocation = Icons.my_location; // TODO: ganti ke iconsax
  static const IconData wifiOff = Icons.wifi_off; // TODO: ganti ke iconsax
  static const IconData star = Icons.star; // TODO: ganti ke iconsax
  static const IconData people = Icons.people; // TODO: ganti ke iconsax
  static const IconData map = Icons.map; // TODO: ganti ke iconsax
  static const IconData payments = Icons.payments; // TODO: ganti ke iconsax
  static const IconData paymentsOutlined = Icons.payments_outlined; // TODO: ganti ke iconsax

  // ── Doctor Detail Info ──
  static const IconData schoolOutlined = Icons.school_outlined; // TODO: ganti ke iconsax
  static const IconData workOutline = Icons.work_outline; // TODO: ganti ke iconsax
  static const IconData rateReviewOutlined = Icons.rate_review_outlined; // TODO: ganti ke iconsax

  // ── Error & Status ──
  static const IconData errorOutline = Icons.error_outline; // TODO: ganti ke iconsax
  static const IconData infoOutline = Icons.info_outline; // TODO: ganti ke iconsax
  static const IconData info = Icons.info; // TODO: ganti ke iconsax

  // ── Settings ──
  static const IconData darkMode = Icons.dark_mode; // TODO: ganti ke iconsax
  static const IconData delete = Icons.delete; // TODO: ganti ke iconsax
  static const IconData storage = Icons.storage; // TODO: ganti ke iconsax

  // ── Quick Categories (Home) ──
  static const IconData medicalServices = Icons.medical_services; // TODO: ganti ke iconsax
  static const IconData air = Icons.air; // TODO: ganti ke iconsax
  static const IconData psychology = Icons.psychology; // TODO: ganti ke iconsax
  static const IconData science = Icons.science; // TODO: ganti ke iconsax
  static const IconData biotech = Icons.biotech; // TODO: ganti ke iconsax
  static const IconData vaccines = Icons.vaccines; // TODO: ganti ke iconsax

  // ═══════════════════════════════════════════════════════════
  //   SUDAH ICONSAX (tidak perlu diganti)
  // ═══════════════════════════════════════════════════════════

  // ── Navigation (Iconsax) ──
  static const IconData home = Iconsax.home;
  static const IconData location = Iconsax.location;
  static const IconData arrowRight03 = Iconsax.arrowRight03;
  static const IconData arrowDown01 = Iconsax.arrowDown01;
  static const IconData arrowUp02 = Iconsax.arrowUp02;
  static const IconData arrowDown02 = Iconsax.arrowDown02;

  // ── Actions (Iconsax) ──
  static const IconData searchNormal = Iconsax.searchNormal;
  static const IconData filter = Iconsax.filter;
  static const IconData gallery = Iconsax.gallery;
  static const IconData edit = Iconsax.editStyle4;
  static const IconData camera = Iconsax.cameraStyle4;
  static const IconData galleryPicker = Iconsax.galleryStyle4;
  static const IconData trash = Iconsax.trashStyle4;
  static const IconData profileCircle = Iconsax.profileCircle;

  // ── Notification (Iconsax) ──
  static const IconData notificationBingStyle5 = Iconsax.notificationBingStyle5;
  static const IconData notification = Iconsax.notification;
  static const IconData tickCircle = Iconsax.tickCircle;
  static const IconData closeCircle = Iconsax.closeCircle;
  static const IconData clock = Iconsax.clock;
  static const IconData warning2 = Iconsax.warning2;
  static const IconData infoCircle = Iconsax.infoCircle;
  static const IconData shieldTick = Iconsax.shieldTick;

  // ── Dialog (Iconsax) ──
  static const IconData messageQuestion = Iconsax.messageQuestion;

  // ── Date Picker (Iconsax) ──
  static const IconData calendar = Iconsax.calendar;
  static const IconData calendar2 = Iconsax.calendar2Style8;

  // ── User (Iconsax) ──
  static const IconData user = Iconsax.user;
}
