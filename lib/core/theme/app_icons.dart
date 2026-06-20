import 'package:flutter/widgets.dart';
import 'package:iconsax_latest/iconsax_latest.dart';

/// Centralized icon reference untuk seluruh aplikasi.
///
class AppIcons {
  AppIcons._();

  // ── Navigation ──
  static const IconData arrowBack = Iconsax.arrowLeft01Style4;
  static const IconData close = Iconsax.closeSquareStyle2;
  static const IconData arrowDropDown = Iconsax.arrowDown01Style4;
  static const IconData sort = Iconsax.sortStyle5;
  static const IconData share = Iconsax.shareStyle4;
  static const IconData editCalendar = Iconsax.calendarEditStyle4;

  // ── Search ──
  static const IconData search = Iconsax.searchNormal;

  // ── Auth & Profile ──
  static const IconData person = Iconsax.user;
  static const IconData email = Iconsax.smsStyle5;
  static const IconData lock = Iconsax.lockStyle1;
  static const IconData visibilityOff = Iconsax.eyeSlashStyle2;
  static const IconData visibility = Iconsax.eye;
  static const IconData logout = Iconsax.logout02;
  static const IconData settings = Iconsax.setting2Style1;
  static const IconData help = Iconsax.infoCircleStyle1;
  static const IconData description = Iconsax.documentText2;
  static const IconData favorite = Iconsax.heart;

  // ── Booking & Appointment ──
  static const IconData calendarToday = Iconsax.calendar2Style11;
  static const IconData accessTime = Iconsax.clockStyle10;
  static const IconData checkCircle = Iconsax.tickCircleStyle1;
  static const IconData check = Iconsax.tickSquareStyle1;

  // ── Medical & Clinic ──
  static const IconData localHospital = Iconsax.hospitalStyle3;
  static const IconData localHospitalOutlined = Iconsax.aiHospitalStyle5;
  static const IconData locationOn = Iconsax.location;
  static const IconData locationOff = Iconsax.locationCrossStyle2;
  static const IconData locationDisabled = Iconsax.locationSlashStyle2;
  static const IconData phone = Iconsax.callCallingStyle1;
  static const IconData myLocation = Iconsax.gpsStyle4;
  static const IconData wifiOff = Iconsax.wifi;
  static const IconData star = Iconsax.starStyle5;
  static const IconData people = Iconsax.peopleStyle1;
  static const IconData map = Iconsax.map1Style1;
  static const IconData payments = Iconsax.wallet1Style3;

  static const IconData info = Iconsax.infoCircleStyle1;

  // ── Settings ──
  static const IconData darkMode = Iconsax.moonStyle3;
  static const IconData storage = Iconsax.dataStyle1;

  // ── Navigation (Iconsax) ──
  static const IconData home = Iconsax.home;
  static const IconData location = Iconsax.location;
  static const IconData arrowRight = Iconsax.arrowRight01Style4;
  static const IconData arrowDown = Iconsax.arrowDown01Style4;
  static const IconData arrowUp = Iconsax.arrowUp01Style4;
  static const IconData arrowDown02 = Iconsax.arrowDown02;

  // ── Actions (Iconsax) ──
  static const IconData searchNormal = Iconsax.searchNormal;
  static const IconData filter = Iconsax.filterStyle4;
  static const IconData gallery = Iconsax.galleryStyle5;
  static const IconData edit = Iconsax.editStyle5;
  static const IconData camera = Iconsax.camera;
  static const IconData galleryPicker = Iconsax.galleryAddStyle4;
  static const IconData trash = Iconsax.trash;
  static const IconData profileCircle = Iconsax.profileCircleStyle2;

  // ── Notification (Iconsax) ──
  static const IconData notification = Iconsax.notificationBingStyle4;
  static const IconData tickCircle = Iconsax.tickCircleStyle1;
  static const IconData closeCircle = Iconsax.closeCircle;
  static const IconData clock = Iconsax.clockStyle10;
  static const IconData warning2 = Iconsax.warning2;
  static const IconData infoCircle = Iconsax.infoCircleStyle1;
  static const IconData shieldTick = Iconsax.shieldTickStyle1;

  // ── Dialog (Iconsax) ──
  static const IconData messageQuestion = Iconsax.messageQuestionStyle2;

  // ── Date Picker (Iconsax) ──
  static const IconData calendar = Iconsax.calendarStyle2;
  static const IconData calendar2 = Iconsax.calendar2Style11;

  // ── User (Iconsax) ──
  static const IconData user = Iconsax.user;

  /// Semua icon untuk debugging/gallery.
  static const Map<String, IconData> allIcons = {
    'arrowBack': arrowBack,
    'close': close,
    'arrowDropDown': arrowDropDown,
    'sort': sort,
    'share': share,
    'editCalendar': editCalendar,

    'search': search,

    'person': person,
    'email': email,
    'lock': lock,
    'visibilityOff': visibilityOff,
    'visibility': visibility,
    'logout': logout,
    'settings': settings,
    'help': help,
    'description': description,
    'favorite': favorite,

    'calendarToday': calendarToday,
    'accessTime': accessTime,
    'checkCircle': checkCircle,
    'check': check,

    'localHospital': localHospital,
    'localHospitalOutlined': localHospitalOutlined,
    'locationOn': locationOn,
    'locationOff': locationOff,
    'locationDisabled': locationDisabled,
    'phone': phone,
    'myLocation': myLocation,
    'wifiOff': wifiOff,
    'star': star,
    'people': people,
    'map': map,
    'payments': payments,

    'info': info,

    'darkMode': darkMode,
    'storage': storage,

    'home': home,
    'location': location,
    'arrowRight': arrowRight,
    'arrowDown': arrowDown,
    'arrowUp': arrowUp,
    'arrowDown02': arrowDown02,

    'searchNormal': searchNormal,
    'filter': filter,
    'gallery': gallery,
    'edit': edit,
    'camera': camera,
    'galleryPicker': galleryPicker,
    'trash': trash,
    'profileCircle': profileCircle,

    'notification': notification,
    'tickCircle': tickCircle,
    'closeCircle': closeCircle,
    'clock': clock,
    'warning2': warning2,
    'infoCircle': infoCircle,
    'shieldTick': shieldTick,

    'messageQuestion': messageQuestion,

    'calendar': calendar,
    'calendar2': calendar2,

    'user': user,
  };
}
