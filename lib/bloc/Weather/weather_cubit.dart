import 'package:bloc/bloc.dart';
import 'package:clima_flutter_2/services/networking.dart';
import 'package:clima_flutter_2/services/weather.dart';
import 'package:clima_flutter_2/utilities/exceptions.dart';
import 'package:equatable/equatable.dart';

part 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  late WeatherService weatherService;

  WeatherCubit() : super(WeatherInitial()) {
    weatherService = OpenWeatherService();
  }

  void getActualWeather({
    required double latitud,
    required double longitud,
  }) async {
    emit(WeatherStart());
    try {
      Map<dynamic, dynamic> weather = await weatherService.getActualWeather(
        lat: latitud,
        lon: longitud,
      );

      emit(
        WeatherGetted(
          weather: weather,
        ),
      );
    } on AccountBlockedException catch (error) {
      emit(
        WeatherError(
          message: 'Api bloqueada',
        ),
      );
    }

    // print()
  }

  void getCityWeather({required String nameCity}) async {
    emit(WeatherStart());
    try {
      Map<dynamic, dynamic> weather = await weatherService.getCityWeather(
        cityName: nameCity,
      );

      emit(
        WeatherGetted(
          weather: weather,
        ),
      );
    } on AccountBlockedException catch (error) {
      emit(
        WeatherError(
          message: 'Api bloqueada',
        ),
      );
    } on NotFoundException catch (error) {
      emit(
        WeatherError(
          message: 'No se encontro la ciudad',
        ),
      );
    }
  }
}
