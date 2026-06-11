import 'package:equatable/equatable.dart';

import '../../../domain/entity/banner_entity.dart';

sealed class BannerState extends Equatable {
  const BannerState();

  @override
  List<Object?> get props => [];
}

class BannerInitial extends BannerState {
  const BannerInitial();
}

class BannerLoading extends BannerState {
  const BannerLoading();
}

class BannerLoaded extends BannerState {
  final List<BannerEntity> banners;

  const BannerLoaded({this.banners = const []});

  @override
  List<Object?> get props => [banners];
}

class BannerError extends BannerState {
  final String message;

  const BannerError({this.message = ''});

  @override
  List<Object?> get props => [message];
}
