import 'package:injectable/injectable.dart';

import '../../../../core/enums/failure_code.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/network/error_handler.dart';
import '../../../../core/network/result.dart';
import '../../../../core/services/app_services.dart';
import '../../../../core/utils/retry.dart';
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
  final AppServices _appServices;

  // Sprint 2 — B7: inject AppServices untuk handleWithAuthCheck
  // (auto-logout on 401 di getUserProfile).
  HomeRepositoryImpl(this._remote, this._local, this._appServices);

  @override
  Future<Result<List<BannerEntity>>> getBanners() async {
    try {
      // Sprint 2 — B8: retry network-transient errors (SocketException,
      // TimeoutException) with exponential backoff 1s, 2s, 4s.
      final remote = await withRetry(() => _remote.fetchBanners());
      await _local.cacheBanners(remote);
      return Result.success(remote.map((m) => m.toEntity()).toList());
    } catch (e) {
      final cached = _local.getCachedBanners();
      if (cached != null) {
        return Result.success(cached.map((m) => m.toEntity()).toList());
      }
      return Result.failure(const ErrorHandler().map(e));
    }
  }

  @override
  Future<Result<UpcomingAppointmentEntity?>> getUpcoming(
      String profileId) async {
    try {
      final remote = await _remote.fetchUpcoming(profileId);
      return Result.success(remote?.toEntity());
    } catch (e) {
      return Result.failure(const ErrorHandler().map(e));
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
      return Result.failure(const ErrorHandler().map(e));
    }
  }

  @override
  Future<Result<UserProfileEntity>> getUserProfile(String authId) async {
    // Sprint 2 — B4: remote-first + cache fallback (TDD 08 §2 compliance).
    // Profile cache TTL = 5 menit (session-spanning, cepat untuk re-check).
    try {
      final remote = await _remote.fetchUserProfile(authId);
      if (remote == null) {
        // Null dari remote = user belum punya profile (sign-up baru).
        // JANGAN cache null — biarkan next Home mount re-fetch.
        return Result.failure(const ApiException(
          code: FailureCode.notFound,
          message: 'User profile not found',
        ));
      }
      await _local.cacheUserProfile(remote);
      return Result.success(remote.toEntity());
    } catch (e) {
      final cached = _local.getCachedUserProfile();
      if (cached != null) {
        return Result.success(cached.toEntity());
      }
      // Sprint 2 — B7: jika unauthorized (401/token expired),
      // trigger auto-logout sebelum return failure.
      return Result.failure(
        await ErrorHandler.handleWithAuthCheck(
          e,
          onUnauthorized: () => _appServices.logout(),
        ),
      );
    }
  }
}
