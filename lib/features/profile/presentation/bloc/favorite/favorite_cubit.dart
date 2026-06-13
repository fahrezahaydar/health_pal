// lib/features/profile/presentation/bloc/favorite/favorite_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/network/result.dart';
import '../../../../doctor/domain/entity/doctor_entity.dart';
import '../../../domain/usecase/get_favorites_usecase.dart';
import 'favorite_state.dart';

@injectable
class FavoriteCubit extends Cubit<FavoriteState> {
  final GetFavoritesUseCase _getFavorites;

  FavoriteCubit(this._getFavorites) : super(const FavoriteInitial());

  Future<void> loadFavorites() async {
    emit(const FavoriteLoading());
    final result = await _getFavorites();
    switch (result) {
      case Success<List<DoctorEntity>>(:final data):
        emit(FavoriteLoaded(data));
      case Failure(:final message):
        emit(FavoriteError(message: message));
    }
  }
}
