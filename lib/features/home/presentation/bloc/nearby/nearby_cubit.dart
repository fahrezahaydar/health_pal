import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/network/result.dart';
import '../../../../loc/domain/entity/clinic_entity.dart';
import '../../../../loc/domain/usecase/get_nearby_clinics_usecase.dart';
import 'nearby_state.dart';

@injectable
class NearbyCubit extends Cubit<NearbyState> {
  final GetNearbyClinicsUseCase _getClinics;

  NearbyCubit(this._getClinics) : super(const NearbyInitial());

  Future<void> loadNearby() async {
    emit(const NearbyLoading());

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      print('Location service enabled: $serviceEnabled'); // Debug log
      if (!serviceEnabled) {
        emit(
          const NearbyLocationDenied(
            reason: 'Layanan lokasi tidak aktif. Nyalakan GPS di pengaturan.',
          ),
        );
        return;
      }

      var permission = await Geolocator.checkPermission();
      print('Location permission status: $permission'); // Debug log
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          emit(
            const NearbyLocationDenied(
              reason:
                  'Izin lokasi diperlukan untuk menampilkan klinik terdekat.',
            ),
          );
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        emit(
          const NearbyLocationDenied(
            reason:
                'Izin lokasi ditolak permanen. Buka Settings untuk mengizinkan.',
          ),
        );
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 15),
        ),
      );

      final result = await _getClinics(
        lat: position.latitude,
        lng: position.longitude,
      );

      switch (result) {
        case Success<List<ClinicEntity>>(:final data):
          if (data.isEmpty) {
            emit(
              const NearbyError(
                message: 'Tidak ada klinik di sekitar lokasi Anda.',
              ),
            );
          } else {
            emit(NearbyLoaded(clinics: data));
          }
        case Failure<List<ClinicEntity>>(:final message):
          emit(NearbyError(message: message));
      }
    } catch (e) {
      emit(NearbyError(message: 'Gagal mendapatkan lokasi: $e'));
    }
  }
}
