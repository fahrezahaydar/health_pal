import 'package:injectable/injectable.dart';

import '../../../../core/network/error_handler.dart';
import '../../../../core/network/result.dart';
import '../../domain/entity/banner_entity.dart';
import '../../domain/entity/specialization_entity.dart';
import '../../domain/entity/upcoming_appointment_entity.dart';
import '../../domain/entity/user_profile_entity.dart';
import '../../domain/repository/home_repository.dart';
import '../datasource/home_local_datasource.dart';
import '../datasource/home_remote_datasource.dart';

@Injectable(as: HomeRepository)
class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource _remote;
  final HomeLocalDataSource _local;

  HomeRepositoryImpl(this._remote, this._local);

  @override
  Future<Result<List<BannerEntity>>> getBanners() async {
    try {
      final remote = await _remote.fetchBanners();
      await _local.cacheBanners(remote);
      return Result.success(remote.map((m) => m.toEntity()).toList());
    } catch (e) {
      final cached = _local.getCachedBanners();
      if (cached != null) {
        return Result.success(cached.map((m) => m.toEntity()).toList());
      }
      return Result.failure(ErrorHandler().map(e));
    }
  }

  @override
  Future<Result<UpcomingAppointmentEntity?>> getUpcoming(
      String profileId) async {
    try {
      final remote = await _remote.fetchUpcoming(profileId);
      return Result.success(remote?.toEntity());
    } catch (e) {
      return Result.failure(ErrorHandler().map(e));
    }
  }

  @override
  Future<Result<List<SpecializationEntity>>> getSpecializations() async {
    try {
      final remote = await _remote.fetchSpecializations();
      await _local.cacheSpecializations(remote);
      return Result.success(remote.map((m) => m.toEntity()).toList());
    } catch (e) {
      final cached = _local.getCachedSpecializations();
      if (cached != null) {
        return Result.success(cached.map((m) => m.toEntity()).toList());
      }
      return Result.failure(ErrorHandler().map(e));
    }
  }

  @override
  Future<Result<UserProfileEntity>> getUserProfile(String authId) async {
    try {
      final remote = await _remote.fetchUserProfile(authId);
      return Result.success(remote.toEntity());
    } catch (e) {
      return Result.failure(ErrorHandler().map(e));
    }
  }
}
