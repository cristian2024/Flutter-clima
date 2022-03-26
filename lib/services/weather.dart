import 'dart:convert';

import 'package:clima_flutter_2/utilities/exceptions.dart';
import 'package:http/http.dart' as http;

class WeatherModel {
  String getWeatherIcon(int condition) {
    if (condition < 300) {
      return '🌩';
    } else if (condition < 400) {
      return '🌧';
    } else if (condition < 600) {
      return '☔️';
    } else if (condition < 700) {
      return '☃️';
    } else if (condition < 800) {
      return '🌫';
    } else if (condition == 800) {
      return '☀️';
    } else if (condition <= 804) {
      return '☁️';
    } else {
      return '🤷‍';
    }
  }

  static String getMessage(double temp) {
    if (temp > 25) {
      return 'It\'s 🍦 time';
    } else if (temp > 20) {
      return 'Time for shorts and 👕';
    } else if (temp < 10) {
      return 'You\'ll need 🧣 and 🧤';
    } else {
      return 'Bring a 🧥 just in case';
    }
  }
}

abstract class WeatherService {
  Future<Map<dynamic, dynamic>> getActualWeather({
    required double lat,
    required double lon,
  });

  Future<Map<dynamic, dynamic>> getCityWeather({required String cityName});
  // async {
  // Uri url = Uri.parse(
  //     "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=0a1c018656f81de6b04e532ab9e42279");
  // http.Response response = await http.get(url);

  // await Future.delayed(
  //   const Duration(
  //     seconds: 3,
  //   ),
  // );
  // print(response.body);
  // if (response.statusCode == 429) {
  //   throw AccountBlockedException(
  //     cause: jsonDecode(response.body)['message'],
  //   );
  // }

  // return jsonDecode(response.body);
  // }
}

class OpenWeatherService implements WeatherService {
  String apiKey = "0a1c018656f81de6b04e532ab9e42279";
  @override
  Future<Map> getActualWeather(
      {required double lat, required double lon}) async {
    Uri url = Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric");
    http.Response response = await http.get(url);

    // await Future.delayed(
    //   const Duration(
    //     seconds: 3,
    //   ),
    // );
    print(response.body);
    if (response.statusCode == 429) {
      throw AccountBlockedException(
        cause: jsonDecode(response.body)['message'],
      );
    }

    return jsonDecode(response.body);
  }

  @override
  Future<Map> getCityWeather({required String cityName}) async {
    Uri url = Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric");
    http.Response response = await http.get(url);
    print(response.body);
    if (response.statusCode == 429) {
      throw AccountBlockedException(
        cause: jsonDecode(response.body)['message'],
      );
    }
    if (response.statusCode == 404) {
      throw NotFoundException(
        cause: jsonDecode(response.body)['message'],
      );
    }

    return jsonDecode(response.body);
  }
}

class LocalWeatherService implements WeatherService {
  @override
  Future<Map> getActualWeather({
    required double lat,
    required double lon,
  }) async {
    return {
      "coord": {"lon": -74.1638, "lat": 4.6367},
      "weather": [
        {
          "id": 802,
          "main": "Clouds",
          "description": "scattered clouds",
          "icon": "03n"
        }
      ],
      "base": "stations",
      "main": {
        "temp": 18.2,
        "feels_like": 287.89,
        "temp_min": 288.19,
        "temp_max": 288.19,
        "pressure": 1025,
        "humidity": 82
      },
      "visibility": 10000,
      "wind": {"speed": 1.03, "deg": 0},
      "clouds": {"all": 40},
      "dt": 1648258734,
      "sys": {
        "type": 1,
        "id": 8582,
        "country": "CO",
        "sunrise": 1648205915,
        "sunset": 1648249588
      },
      "timezone": -18000,
      "id": 3665965,
      "name": "Villa Mejía",
      "cod": 200
    };
  }

  @override
  Future<Map> getCityWeather({required String cityName}) {
    // TODO: implement getCityWeather
    throw UnimplementedError();
  }
}
