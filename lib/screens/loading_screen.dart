import 'package:clima_flutter_2/bloc/Geolocation/gelocation_cubit.dart';
import 'package:clima_flutter_2/bloc/Weather/weather_cubit.dart';
import 'package:clima_flutter_2/screens/city_screen.dart';
import 'package:clima_flutter_2/screens/location_screen.dart';
import 'package:clima_flutter_2/services/networking.dart';
// import 'package:clima_flutter_2/Geolocation/gelocationpermission_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:geolocator/geolocator.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {}

  void getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.low,
    );
    // print(position);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Inyeccion de distintos blocs para el uso correspondiente
      body: BlocConsumer<GelocationCubit, GelocationState>(
        listener: (context, state) {
          if (state is GeolocationPositionGetted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => WeatherCubit()
                    ..getActualWeather(
                      latitud: state.position.latitude,
                      longitud: state.position.longitude,
                    ),
                  child: LocationScreen(
                    position: state.position,
                  ),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is GeolocationIsEnabled) {
            if (state is GelocationpermissionGranted) {
              if (state is GeolocationGettingPosition) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
                // return
              } else if (state is GeolocationPositionGetted) {
                // WeatherService.getActualWeather(
                //   lat: state.position.latitude,
                //   lon: state.position.longitude,
                // );
                return Center(
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<GelocationCubit>().getActualLocation();
                    },
                    child: Text(
                      state.position.toString(),
                    ),
                  ),
                );
              } else {
                return Center(
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<GelocationCubit>().getActualLocation();
                      // BlocProvider.of<GelocationCubit>(context)
                      //     .getActualLocation();
                    },
                    child: const Text(
                      'Get Location',
                    ),
                  ),
                );
              }
            } else if (state is GelocationpermissionDenied) {
              return const SafeArea(
                child: Text(
                  'No se otorgaron los permisos para esta tarea',
                ),
              );
            } else {
              return Center(
                child: ElevatedButton(
                  onPressed: () {
                    context.read<GelocationCubit>().getActualLocation();
                    // BlocProvider.of<GelocationCubit>(context)
                    //     .getActualLocation();
                  },
                  child: const Text(
                    'Validar permisos para uso de gps',
                  ),
                ),
              );
            }
          } else if (state is GeolocationIsNotEnabled) {
            return SafeArea(
              child: Text(
                'No esta encendido el gps',
              ),
            );
          } else if (state is GelocationError) {
            return SafeArea(
              child: Text(
                state.error.toString(),
              ),
            );
          } else {
            return const SafeArea(
              child: Text(
                'No tienes permisos para esta tarea',
              ),
            );
          }
        },
      ),
    );
  }
}
