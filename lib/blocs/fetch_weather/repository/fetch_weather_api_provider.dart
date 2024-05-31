import 'package:dio/dio.dart';
import 'package:weather_guru/environment.dart';
import 'package:weather_guru/utils/api_response.dart';
import 'package:weather_guru/utils/internet_connectivity.dart';
import 'package:weather_guru/blocs/fetch_weather/model/fetch_weather_model.dart';

class WeatherApiProvider {
  final Dio _dio = Dio();

  Future<ApiResponse> getWeather({required String cityName}) async {
    var responseData;
    try {
      var connectivityNotifier = ConnectivityNotifier();
      bool isConnected = await connectivityNotifier.checkInternetConnection();
      if (!isConnected) {
        return ApiResponse(
          content: null,
          errorMessage:
              "No internet connection",
        );
      }

      Response response = await _dio.request(
        '${endPointUrl}forecast?q=$cityName&units=metric&appid=$xAPIKey',
        options: Options(
          method: 'GET',
        ),
      );

      if (response.statusCode == 200) {
        print(response.data);
        return ApiResponse(
          content: _weatherFromJson(response.data),
          errorMessage: '',
        );
      } else {
        responseData = response.data['message'];
        return ApiResponse(
          content: null,
          errorMessage: responseData,
        );
      }
    } catch (error, stacktrace) {
      print("Exception occurred: $error stackTrace: $stacktrace");
      return ApiResponse(
        content: null,
        errorMessage:
            responseData ?? 'No city by the name $cityName was found',
      );
    }
  }

  List<Weather> _weatherFromJson(dynamic data) {
    List<Weather> weatherList = [];
    for (var item in data['list']) {
      weatherList.add(Weather.fromJson(item));
    }
    return weatherList;
  }
}
