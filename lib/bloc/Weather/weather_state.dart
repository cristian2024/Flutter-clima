part of 'weather_cubit.dart';

abstract class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object> get props => [];
}

class WeatherInitial extends WeatherState {}

class WeatherStart extends WeatherState {}

class WeatherGetted extends WeatherState {
  final Map<dynamic, dynamic> weather;

  WeatherGetted({
    required this.weather,
  });
}

class WeatherError extends WeatherState {
  String message;

  WeatherError({
    required this.message,
  });
}
