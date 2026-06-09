import '../../../../core/network/result.dart';
import '../entity/banner_entity.dart';
import '../entity/specialization_entity.dart';
import '../entity/upcoming_appointment_entity.dart';
import '../entity/user_profile_entity.dart';

abstract class HomeRepository {
  Future<Result<List<BannerEntity>>> getBanners();
  Future<Result<UpcomingAppointmentEntity?>> getUpcoming(String profileId);
  Future<Result<List<SpecializationEntity>>> getSpecializations();
  Future<Result<UserProfileEntity>> getUserProfile(String authId);
}
