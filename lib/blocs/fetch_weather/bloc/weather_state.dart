part of 'weather_bloc.dart';

class WeatherState extends Equatable {
  @override
  List<Object> get props => [];
}
class WeatherInitial extends WeatherState {}
class WeatherInitState extends WeatherState{}

class WeatherLoadingState extends WeatherState{}

class WeatherSuccessState extends WeatherState{
  final List<Weather> weatherForecast;
  WeatherSuccessState(this.weatherForecast);
}
class WeatherErrorState extends WeatherState{
  final String message;
  WeatherErrorState({required this.message});
}
