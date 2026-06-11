import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/network/result.dart';
import '../../../domain/entity/banner_entity.dart';
import '../../../domain/usecase/get_banners_usecase.dart';
import 'banner_state.dart';

@injectable
class BannerCubit extends Cubit<BannerState> {
  final GetBannersUseCase _getBanners;

  BannerCubit(this._getBanners) : super(const BannerInitial());

  Future<void> loadBanners() async {
    emit(const BannerLoading());
    final result = await _getBanners();
    switch (result) {
      case Success<List<BannerEntity>>():
        emit(BannerLoaded(banners: result.data));
      case Failure<List<BannerEntity>>():
        emit(BannerError(message: result.message));
    }
  }
}
