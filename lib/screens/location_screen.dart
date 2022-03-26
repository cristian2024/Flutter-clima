import 'package:clima_flutter_2/bloc/Geolocation/gelocation_cubit.dart';
import 'package:clima_flutter_2/bloc/Weather/weather_cubit.dart';
import 'package:clima_flutter_2/screens/city_screen.dart';
import 'package:clima_flutter_2/services/weather.dart';
import 'package:clima_flutter_2/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

class LocationScreen extends StatefulWidget {
  final Position position;

  const LocationScreen({Key? key, required this.position}) : super(key: key);
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<WeatherCubit, WeatherState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          print(state);
          if (state is WeatherError) {
            return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/location_background.jpg'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.white.withOpacity(0.8),
                    BlendMode.dstATop,
                  ),
                ),
              ),
              constraints: BoxConstraints.expand(),
              child: Center(
                child: Text(
                  state.message,
                ),
              ),
            );
          } else if (!(state is WeatherGetted)) {
            return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/location_background.jpg'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Colors.white.withOpacity(0.8), BlendMode.dstATop),
                ),
              ),
              constraints: BoxConstraints.expand(),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          // if (!(state is WeatherGetted)) {
          //   context.read<WeatherCubit>().getActualWeather(
          //         latitud: widget.position.latitude,
          //         longitud: widget.position.longitude,
          //       );
          // }

          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/location_background.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.white.withOpacity(0.8), BlendMode.dstATop),
              ),
            ),
            constraints: BoxConstraints.expand(),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        TextButton(
                          onPressed: () {
                            context.read<GelocationCubit>().getActualLocation();
                            Navigator.pop(context);
                            //context.read<WeatherCubit>().getActualWeather();
                          },
                          child: Icon(
                            Icons.near_me,
                            size: 50.0,
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            String name = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return CityScreen();
                                },
                              ),
                            );
                            // print(name);
                            context
                                .read<WeatherCubit>()
                                .getCityWeather(nameCity: name);
                            // Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.location_city,
                            size: 50.0,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 15.0),
                      child: Wrap(
                        children: <Widget>[
                          Text(
                            // "Hola",
                            (state.weather["main"]["temp"]).toString(),
                            style: kTempTextStyle,
                          ),
                          Text(
                            "  " + state.weather["weather"][0]["main"],
                            // '☀️',
                            style: kConditionTextStyle,
                          ),
                        ],

                        // children: <Widget>[
                        //   // if(state is WeatherGetted){
                        //   //   return Text('Hola mundo')
                        //   // },
                        //   (state is WeatherGetted)
                        //       ? Text(
                        //           '32°',
                        //           style: kTempTextStyle,
                        //         )
                        //       : CircularProgressIndicator(),
                        //       (state is WeatherGetted)
                        //       ? Text(
                        //           '32°',
                        //           style: kTempTextStyle,
                        //         )
                        //       : CircularProgressIndicator(),
                        //   Text(
                        //     '☀️',
                        //     style: kConditionTextStyle,
                        //   ),
                        // ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 15.0),
                      child: Text(
                        // "Hola",
                        "${WeatherModel.getMessage(state.weather["main"]["temp"])} in ${state.weather["name"]}",
                        textAlign: TextAlign.right,
                        style: kMessageTextStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
