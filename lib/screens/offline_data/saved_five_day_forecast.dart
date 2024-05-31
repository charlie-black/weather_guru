import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

import '../../blocs/fetch_weather/model/fetch_weather_model.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';
import '../../utils/widgets.dart';

class SavedFiveDayForecast extends StatefulWidget {
  final List<Weather> forecast;
  final String cityName;
  final String updateTime;
  const SavedFiveDayForecast({super.key, required this.forecast, required this.cityName, required this.updateTime});

  @override
  State<SavedFiveDayForecast> createState() => _SavedFiveDayForecastState();
}

class _SavedFiveDayForecastState extends State<SavedFiveDayForecast> {
  @override
  Widget build(BuildContext context) {
    List<Weather> filteredForecast = filterOutDailyForecast(widget.forecast);
    Map<String, List<Weather>> groupedForecast =
    groupForecastByDate(filteredForecast);
    Weather? cityWeather = getAvailableWeather(filteredForecast);
    if (cityWeather == null) {
      return Scaffold(
        backgroundColor: kPrimaryColor,
        body: Center(
          child: Text(
            "Not enough data available.",
            style: TextStyle(color: Colors.black, fontSize: 20.sp),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Container(
          child: Column(
            children: [
              Stack(
                children: [
                  ClipRect(
                    child: Container(
                      height: 50.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(30.0),
                          bottomRight: Radius.circular(30.0),
                        ),
                        image: DecorationImage(
                          image: AssetImage(
                              "assets/images/${cityWeather.weatherIcon}.jpeg"),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 10.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: strokeTextWidget(
                                      fillText: widget.cityName,
                                      textFontSize: 30.0,
                                      textFontWeight: FontWeight.bold)),
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: strokeTextWidget(
                                      fillText: "Tomorrow",
                                      textFontSize: 15.0,
                                      textFontWeight: FontWeight.normal)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
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
                                    'assets/icons/${cityWeather.weatherIcon}.png',
                                    height: 70,
                                    width: 70,
                                  ),
                                ),
                              ),
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: strokeTextWidget(
                                      fillText:
                                      "${cityWeather.temperature}°C",
                                      textFontSize: 40.0,
                                      textFontWeight: FontWeight.normal)),
                            ],
                          ),
                          strokeTextWidget(
                              fillText: cityWeather.weatherDescription,
                              textFontSize: 20.0,
                              textFontWeight: FontWeight.bold),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Lottie.asset('assets/json/wind.json',
                                      height: 40, width: 40),
                                  strokeTextWidget(
                                      fillText:
                                      "${cityWeather.windSpeed}Km/h",
                                      textFontSize: 18.0,
                                      textFontWeight: FontWeight.normal)
                                ],
                              ),
                              Column(
                                children: [
                                  Lottie.asset('assets/json/humidity.json',
                                      height: 40, width: 40),
                                  strokeTextWidget(
                                      fillText: "${cityWeather.humidity}%",
                                      textFontSize: 18.0,
                                      textFontWeight: FontWeight.normal)
                                ],
                              ),
                              Column(
                                children: [
                                  Lottie.asset('assets/json/cloud.json',
                                      height: 40, width: 40),
                                  strokeTextWidget(
                                      fillText: "${cityWeather.cloud}%",
                                      textFontSize: 18.0,
                                      textFontWeight: FontWeight.normal)
                                ],
                              ),
                            ],
                          ),
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: strokeTextWidget(
                                  fillText:"Last Updated at ${formatTime(DateTime.parse(widget.updateTime))}",
                                  textFontSize: 12.0,
                                  textFontWeight: FontWeight.normal)),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    left: 16,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
              ListView.builder(
                itemCount: groupedForecast.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  // Sort the dates in ascending order
                  List<String> sortedDates = groupedForecast.keys.toList()
                    ..sort((a, b) => DateTime.parse(a).compareTo(DateTime.parse(b)));

                  String date = sortedDates[index];
                  List<Weather> dailyForecast = groupedForecast[date]!;

                  Weather? dailyCityWeather = getAvailableWeather(dailyForecast);
                  if (dailyCityWeather == null) {
                    return Container();
                  }

                  return Container(
                    margin: const EdgeInsets.all(8.0),
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.black),
                      gradient: const LinearGradient(
                        colors: [Colors.transparent, Colors.transparent],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.black.withOpacity(0.9),
                        radius: 30,
                        child: Image.asset(
                          'assets/icons/${dailyCityWeather.weatherIcon}.png',
                          height: 30,
                          width: 30,
                        ),
                      ),
                      title: Text(
                        "${formatDateName(dailyCityWeather.date)}  ${dailyCityWeather.mainWeather}",
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      trailing: Text(
                        "${dailyCityWeather.temperature}°C",
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Weather> filterOutDailyForecast(List<Weather> forecast) {
    DateTime today = DateTime.now();
    return forecast.where((weather) {
      DateTime weatherDate = DateTime.parse(weather.date.toString());
      return weatherDate.year != today.year ||
          weatherDate.month != today.month ||
          weatherDate.day != today.day;
    }).toList();
  }

  Weather? getAvailableWeather(List<Weather> forecast) {
    if (forecast.length >= 3) {
      return forecast[2];
    } else if (forecast.length >= 2) {
      return forecast[1];
    } else if (forecast.isNotEmpty) {
      return forecast[0];
    } else {
      return null;
    }
  }
}
