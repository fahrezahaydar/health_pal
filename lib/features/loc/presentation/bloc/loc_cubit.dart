// lib/features/loc/presentation/bloc/loc_cubit.dart
//
// Cubit untuk Loc (Nearby Clinics) page.
// - requestLocationAndLoad() → minta permission → get position → load clinics
// - refresh() → reload dengan position terakhir
// - changeRadius(double km) → reload dengan radius berbeda

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/network/result.dart';
import '../../domain/entity/clinic_entity.dart';
import '../../domain/usecase/get_nearby_clinics_usecase.dart';
import 'loc_state.dart';

@injectable
class LocCubit extends Cubit<LocState> {
  final GetNearbyClinicsUseCase _getClinics;

  LocCubit(this._getClinics) : super(const LocInitial());

  double _radiusKm = 10.0;
  Position? _lastPosition;

  /// Request lokasi + load clinics.
  /// Dipanggil dari initState page atau tombol "Izinkan Lokasi".
  Future<void> requestLocationAndLoad() async {
    emit(const LocLoading());

    try {
      // 1. Cek service status
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        emit(const LocError(
          message:
              'Layanan lokasi tidak aktif. Nyalakan GPS di pengaturan perangkat.',
        ));
        return;
      }

      // 2. Cek permission
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          emit(const LocPermissionDenied(
            reason:
                'Izin lokasi diperlukan untuk menampilkan klinik terdekat.',
          ));
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        emit(const LocPermissionDenied(
          reason:
              'Izin lokasi ditolak permanen. Buka Settings aplikasi untuk mengizinkan.',
        ));
        return;
      }

      // 3. Get current position
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 15),
        ),
      );
      _lastPosition = position;
      await _load(position, _radiusKm);
    } catch (e) {
      emit(LocError(message: 'Gagal mendapatkan lokasi: $e'));
    }
  }

  /// Reload clinics dengan position terakhir + radius saat ini.
  Future<void> refresh() async {
    if (_lastPosition == null) {
      // Belum pernah load — fallback ke requestLocationAndLoad
      await requestLocationAndLoad();
      return;
    }
    emit(const LocLoading());
    await _load(_lastPosition!, _radiusKm);
  }

  /// Ubah radius — re-fetch dengan radius baru (butuh position).
  Future<void> changeRadius(double km) async {
    _radiusKm = km;
    if (_lastPosition == null) {
      await requestLocationAndLoad();
      return;
    }
    emit(const LocLoading());
    await _load(_lastPosition!, km);
  }

  void setFilter(String? specialization) {
    final current = state;
    if (current is! LocLoaded) return;
    emit(current.copyWith(selectedSpecialization: specialization));
  }

  void setSortBy(String sortBy) {
    final current = state;
    if (current is! LocLoaded) return;
    emit(current.copyWith(sortBy: sortBy));
  }

  Future<void> _load(Position position, double radiusKm) async {
    final result = await _getClinics(
      lat: position.latitude,
      lng: position.longitude,
      radiusKm: radiusKm,
    );
    switch (result) {
      case Success<List<ClinicEntity>>(:final data):
        emit(LocLoaded(
          clinics: data,
          currentPosition: position,
          radiusKm: radiusKm,
        ));
      case Failure(:final message):
        emit(LocError(message: message));
    }
  }
}
