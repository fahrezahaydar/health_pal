import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/banner_model.dart';
import '../model/specialization_model.dart';
import '../model/upcoming_appointment_model.dart';
import '../model/user_profile_model.dart';

@injectable
class HomeRemoteDataSource {
  final SupabaseClient _client;

  HomeRemoteDataSource(this._client);

  Future<List<BannerModel>> fetchBanners() async {
    final now = DateTime.now().toIso8601String();
    final result = await _client
        .from('banners')
        .select()
        .eq('is_active', true)
        .or('starts_at.is.null,starts_at.lte.$now')
        .or('ends_at.is.null,ends_at.gte.$now')
        .order('display_order', ascending: true);

    return (result as List)
        .map((e) => BannerModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<UpcomingAppointmentModel?> fetchUpcoming(String profileId) async {
    final result = await _client
        .from('appointments')
        .select(
            '*, doctors(id, full_name, photo_url, clinics(name), specializations(name)), doctor_slots(slot_date, slot_start, slot_end)')
        .eq('patient_id', profileId)
        .neq('status', 'completed')
        .neq('status', 'cancelled')
        .order('created_at', ascending: false)
        .limit(1)
        .maybeSingle();

    if (result == null) return null;
    return UpcomingAppointmentModel.fromJson(result);
  }

  Future<List<SpecializationModel>> fetchSpecializations() async {
    final result = await _client
        .from('specializations')
        .select()
        .order('name', ascending: true);

    return (result as List)
        .map((e) => SpecializationModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<UserProfileModel?> fetchUserProfile(String authId) async {
    final result = await _client
        .from('user_profiles')
        .select()
        .eq('auth_id', authId)
        .maybeSingle();

    if (result == null) return null;
    return UserProfileModel.fromJson(result);
  }
}
