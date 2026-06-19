// lib/features/loc/presentation/bloc/loc_cubit.dart
//
// Cubit untuk Loc (Nearby Clinics) page.
// - requestLocationAndLoad() → minta permission → get position → load clinics
// - refresh() → reload dengan position terakhir
// - changeRadius(double km) → reload dengan radius berbeda

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entity/clinic_entity.dart';
import '../../domain/usecase/get_nearby_clinics_usecase.dart';
import 'loc_state.dart';

@injectable
class LocCubit extends Cubit<LocState> {
  // ignore: unused_field
  final GetNearbyClinicsUseCase _getClinics; // akan dipakai lagi setelah deploy

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
    // TODO: ganti dengan panggil _getClinics setelah function get_nearby_clinics
    // sudah di-deploy + schema cache di-reload.
    final dummy = <ClinicEntity>[
      const ClinicEntity(
        id: 'c1a2b3c4-d5e6-7890-clinic-000000000001',
        name: 'Klinik Sehat Bersama',
        address: 'Jl. Merdeka No. 10',
        city: 'Bandung',
        latitude: -6.9210,
        longitude: 107.6087,
        phone: '022-12345678',
        imageUrl: null,
        distanceMeters: 1200,
        doctorCount: 5,
      ),
      const ClinicEntity(
        id: 'c1a2b3c4-d5e6-7890-clinic-000000000002',
        name: 'RS Mitra Husada',
        address: 'Jl. Diponegoro No. 45',
        city: 'Bandung',
        latitude: -6.9030,
        longitude: 107.6185,
        phone: '022-23456789',
        imageUrl: null,
        distanceMeters: 1800,
        doctorCount: 12,
      ),
      const ClinicEntity(
        id: 'c1a2b3c4-d5e6-7890-clinic-000000000003',
        name: 'Klinik Bunda Sehat',
        address: 'Jl. Riau No. 78',
        city: 'Bandung',
        latitude: -6.8950,
        longitude: 107.6050,
        phone: '022-34567890',
        imageUrl: null,
        distanceMeters: 2800,
        doctorCount: 3,
      ),
      const ClinicEntity(
        id: 'c1a2b3c4-d5e6-7890-clinic-000000000004',
        name: 'Puskesmas Sukajadi',
        address: 'Jl. Sukajadi No. 120',
        city: 'Bandung',
        latitude: -6.9100,
        longitude: 107.5850,
        phone: '022-45678901',
        imageUrl: null,
        distanceMeters: 3500,
        doctorCount: 8,
      ),
      const ClinicEntity(
        id: 'c1a2b3c4-d5e6-7890-clinic-000000000005',
        name: 'Klinik Medika Utama',
        address: 'Jl. Cihampelas No. 55',
        city: 'Bandung',
        latitude: -6.8930,
        longitude: 107.5950,
        phone: '022-56789012',
        imageUrl: null,
        distanceMeters: 3200,
        doctorCount: 6,
      ),
      const ClinicEntity(
        id: 'c1a2b3c4-d5e6-7890-clinic-000000000006',
        name: 'RSIA Hermina',
        address: 'Jl. Setiabudi No. 89',
        city: 'Bandung',
        latitude: -6.8750,
        longitude: 107.5900,
        phone: '022-67890123',
        imageUrl: null,
        distanceMeters: 5100,
        doctorCount: 15,
      ),
    ];
    emit(LocLoaded(
      clinics: dummy,
      currentPosition: position,
      radiusKm: radiusKm,
    ));
  }
}
