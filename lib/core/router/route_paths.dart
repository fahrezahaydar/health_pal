class RoutePaths {
  const RoutePaths._();

  // Auth
  static const onboarding = '/onboarding';
  static const signIn = '/sign-in';
  static const signUp = '/sign-up';
  static const createProfile = '/sign-up/create-profile';
  static const forgotPassword = '/sign-in/forgot-password';

  // Main Shell
  static const home = '/home';
  static const loc = '/loc';
  static const bookingHistory = '/booking-history';
  static const profile = '/profile';

  // Stack routes
  static const doctorSearch = '/doctor/search';
  static const doctorDetail = '/doctor/:doctorId';
  static const bookAppointment = '/booking/:doctorId';
  static const bookingSuccess = '/booking/success';
  static const bookingDetail = '/booking-history/:bookingId';
  static const editProfile = '/profile/edit';
  static const favorite = '/profile/favorite';
  static const notificationSettings = '/profile/notifications';
  static const settings = '/settings';
  static const helpSupport = '/help-support';
  static const termsAndConditions = '/terms-and-conditions';
  static const noInternet = '/no-internet';
}
