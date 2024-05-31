import '../../../../utils/api_response.dart';
import 'fetch_weather_api_provider.dart';

class WeatherApiRepository {
  final _provider = WeatherApiProvider();
  Future<ApiResponse> getWeather({required String cityName}) {
    return _provider.getWeather(cityName: cityName);
  }
}

class NetworkError extends Error {}