import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../model/fetch_weather_model.dart';
import '../repository/fetch_weather_api_repository.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherApiRepository apiRepository = WeatherApiRepository();
  WeatherBloc() : super(WeatherInitial()) {
    on<WeatherEvent>((event, emit) {
    });

    on<FetchWeather>((event, emit) async {
      emit(WeatherLoadingState());
      var response = await apiRepository.getWeather(cityName: event.cityName);

      if (response.errorMessage.isNotEmpty) {
        emit(WeatherErrorState(message: response.errorMessage));
      } else {
        emit(WeatherSuccessState(response.content));
      }
    });
  }
}
