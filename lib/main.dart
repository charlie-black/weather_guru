import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:weather_guru/screens/splash_screen.dart';
import 'blocs/fetch_weather/bloc/weather_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, screenType) {
      return MaterialApp(
        title: 'Weather App',
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(0.8)),
            child: child!,
          );
        },
        debugShowCheckedModeBanner: false,
        home: BlocProvider(
          create: (context) => WeatherBloc(),
          child: const SplashScreen(),
        ),
      );
    });
  }
}
