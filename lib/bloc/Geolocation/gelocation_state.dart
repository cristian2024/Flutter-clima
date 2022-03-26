part of 'gelocation_cubit.dart';

abstract class GelocationState extends Equatable {
  const GelocationState();

  @override
  List<Object> get props => [];
}


class GelocationError extends GelocationState {
  final Exception error;
  final String message;

  const GelocationError({required this.error, required this.message});
}

class GeolocationIsNotEnabled extends GelocationState {}

class GeolocationIsEnabled extends GelocationState {}

class GelocationInitial extends GelocationState {}

class GelocationpermissionStart extends GelocationState {}

class GelocationpermissionGranted extends GeolocationIsEnabled {}

class GelocationpermissionDenied extends GeolocationIsEnabled {}



class GeolocationGettingPosition extends GelocationpermissionGranted {}

class GeolocationPositionGetted extends GelocationpermissionGranted {
  final Position position;

  GeolocationPositionGetted({required this.position});
}
