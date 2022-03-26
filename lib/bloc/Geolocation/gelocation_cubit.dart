import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

part 'gelocation_state.dart';

class GelocationCubit extends Cubit<GelocationState> {
  final geolocator = GeolocatorPlatform.instance;
  GelocationCubit() : super(GelocationInitial()) {
    print('Hola mundo');
    getLocationPermission();
  }

  void getLocationPermission() async {
    try {
      emit(GelocationpermissionStart());

      bool isEnabled = await getServiceEnabled();
      if (isEnabled) {
        LocationPermission permission = await Geolocator.checkPermission();

        if (!(permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever)) {
          emit(
            GelocationpermissionGranted(),
          );
          getActualLocation();
        } else {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied ||
              permission == LocationPermission.deniedForever) {
            emit(
              GelocationpermissionDenied(),
            );
          } else {
            emit(
              GelocationpermissionGranted(),
            );
          }
        }
      } else {
        // print(isEnabled);
        emit(
          GeolocationIsNotEnabled(),
        );
      }
    } on Exception catch (e) {
      emit(
        GelocationError(
          error: e,
          message: 'Se presento un error en la obtencion del permiso',
        ),
      );
    }
  }

  void getActualLocation() async {
    try {
      emit(
        GeolocationGettingPosition(),
      );
      Position position = await geolocator.getCurrentPosition();
      // print(position.toString());
      // await Future.delayed(
      //   Duration(
      //     seconds: 5,
      //   ),
      // );
      emit(
        GeolocationPositionGetted(
          position: position,
        ),
      );
    } on Exception catch (e) {
      emit(
        GelocationError(
          error: e,
          message: 'No se pudo obtener la posicion Actual',
        ),
      );
    }
  }

  Future<bool> getServiceEnabled() async {
    bool isEnabled = await geolocator.isLocationServiceEnabled();
    // print(kIsWeb);
    if (!kIsWeb) {
      try {
        geolocator.getServiceStatusStream().listen(
          (event) {
            // print('listener : ${event == ServiceStatus.disabled}');
            if (event == ServiceStatus.disabled) {
              emit(
                GeolocationIsNotEnabled(),
              );
            } else if (event == ServiceStatus.enabled) {
              emit(
                GeolocationIsEnabled(),
              );
            }
          },
        );
      } on Exception catch (e) {
        emit(
          GelocationError(
              error: e, message: 'Error al observar el estado del gps'),
        );
      }
    }

    return isEnabled;
  }
}
