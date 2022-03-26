// import 'package:clima_flutter_2/Geolocation/gelocationpermission_cubit.dart';
import 'package:clima_flutter_2/bloc/Geolocation/gelocation_cubit.dart';
import 'package:clima_flutter_2/bloc/Weather/weather_cubit.dart';
import 'package:clima_flutter_2/screens/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GelocationCubit(),
        ),
        // BlocProvider(
        //   create: (context) => WeatherCubit(),
        // ),
      ],
      child: MaterialApp(
        theme: ThemeData.dark(),
        home: LoadingScreen(),
      ),
    );
  }
}
