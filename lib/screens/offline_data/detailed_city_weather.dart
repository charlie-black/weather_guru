import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:weather_guru/screens/offline_data/saved_five_day_forecast.dart';
import '../../blocs/fetch_weather/model/fetch_weather_model.dart';
import '../../utils/constants.dart';
import '../../utils/gradient_button.dart';
import '../../utils/helpers.dart';
import '../../utils/widgets.dart';

class DetailedSavedCityWeather extends StatefulWidget {
  final String cityName;
  final String updatedTime;
  final List<Map<String, dynamic>> savedWeatherData;
   const DetailedSavedCityWeather({super.key, required this.cityName, required this.savedWeatherData, required this.updatedTime,});

  @override
  State<DetailedSavedCityWeather> createState() => _DetailedSavedCityWeatherState();
}

class _DetailedSavedCityWeatherState extends State<DetailedSavedCityWeather> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: SingleChildScrollView(child: Container(child: _buildWeatherDetails())),
    );
  }

  Widget _buildWeatherDetails() {
    List<Weather> weatherData = widget.savedWeatherData.map((weatherMap) {
      return Weather(
        temperature: weatherMap['temperature'],
        weatherDescription: weatherMap['weatherDescription'],
        humidity: weatherMap['humidity'],
        windSpeed: weatherMap['windSpeed'],
        cloud: weatherMap['cloud'],
        date: DateTime.parse(weatherMap['date']),
        weatherIcon: weatherMap['weatherIcon'],
        mainWeather: weatherMap['mainWeather'],
      );
    }).toList();
    return _buildWeatherBody(context, weatherData);
  }

  Widget _buildWeatherBody(BuildContext context, final List<Weather> forecast) {
    DateTime today = DateTime.now();
    String todayDateString = formatDate(today);
    List<Weather>? todayForecast = forecast.where((weather) {
      DateTime weatherDate = DateTime.parse(weather.date.toString());
      return formatDate(weatherDate) == todayDateString;
    }).toList();

    if (todayForecast.isNotEmpty) {
      return Container(
        height: 100.h,
        color: kPrimaryColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRect(
              child: Container(
                height: 70.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  image: DecorationImage(
                    image: AssetImage(
                        "assets/images/${todayForecast[0].weatherIcon}.jpeg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10.h,
                    ),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: strokeTextWidget(
                            fillText: widget.cityName,
                            textFontSize: 30.0,
                            textFontWeight: FontWeight.bold)),
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 50,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Image.asset(
                        'assets/icons/${todayForecast[0].weatherIcon}.png',
                        height: 70,
                        width: 70,
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: strokeTextWidget(
                            fillText: "${todayForecast[0].temperature}°C",
                            textFontSize: 40.0,
                            textFontWeight: FontWeight.bold)),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: strokeTextWidget(
                            fillText: todayForecast[0].weatherDescription,
                            textFontSize: 20.0,
                            textFontWeight: FontWeight.bold)),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: strokeTextWidget(
                            fillText: formatDate(today),
                            textFontSize: 18.0,
                            textFontWeight: FontWeight.normal)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Lottie.asset('assets/json/wind.json',
                                height: 40, width: 40),
                            strokeTextWidget(
                                fillText: "${todayForecast[0].windSpeed}Km/h",
                                textFontSize: 18.0,
                                textFontWeight: FontWeight.normal)
                          ],
                        ),
                        Column(
                          children: [
                            Lottie.asset('assets/json/humidity.json',
                                height: 40, width: 40),
                            strokeTextWidget(
                                fillText: "${todayForecast[0].humidity}%",
                                textFontSize: 18.0,
                                textFontWeight: FontWeight.normal)
                          ],
                        ),
                        Column(
                          children: [
                            Lottie.asset('assets/json/cloud.json',
                                height: 40, width: 40),
                            strokeTextWidget(
                                fillText: "${todayForecast[0].cloud}%",
                                textFontSize: 18.0,
                                textFontWeight: FontWeight.normal)
                          ],
                        ),
                      ],
                    ),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: strokeTextWidget(
                            fillText:"Last Updated at ${formatTime(DateTime.parse(widget.updatedTime))}",
                            textFontSize: 12.0,
                            textFontWeight: FontWeight.normal)),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Today",
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GradientButton(
                      text: "5 Days",
                      width: 30.w,
                      height: 30,
                      borderRadius: 10,
                      textColor: Colors.white,
                      colors: const [Colors.black, Colors.black],
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SavedFiveDayForecast(
                              forecast: forecast,
                              cityName: widget.cityName, updateTime: widget.updatedTime,
                            ),
                          ),
                        );
                      }),
                )
              ],
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: todayForecast.map((weather) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black),
                        gradient: const LinearGradient(
                          colors: [Colors.white, Colors.white],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              formatTime(weather.date),
                              style: const TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              backgroundColor: Colors.black.withOpacity(0.7),
                              child: Image.asset(
                                'assets/icons/${weather.weatherIcon}.png',
                                height: 30,
                                width: 30,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "${weather.temperature}°C",
                              style: const TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            )
          ],
        ),
      );
    } else {
      return const Center(
          child: Text(
            'No forecast available for today.',
            style: TextStyle(color: Colors.black, fontSize: 20),
          ));
    }
  }

}
