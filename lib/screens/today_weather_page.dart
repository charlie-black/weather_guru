import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:weather_guru/screens/offline_data/saved_city_weather_data.dart';
import 'package:weather_guru/screens/select_city_page.dart';
import 'package:weather_guru/utils/constants.dart';
import 'package:weather_guru/utils/gradient_button.dart';
import 'package:weather_guru/utils/helpers.dart';
import '../../../../utils/widgets.dart';
import '../blocs/fetch_weather/bloc/weather_bloc.dart';
import '../blocs/fetch_weather/model/fetch_weather_model.dart';
import '../utils/database/database_helper.dart';
import 'five_day_weather_page.dart';

class WeatherPage extends StatefulWidget {
  final String cityName;
  const WeatherPage({super.key, required this.cityName});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final WeatherBloc _weatherBloc = WeatherBloc();

  @override
  void initState() {
    super.initState();
    _weatherBloc.add(FetchWeather(widget.cityName));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kPrimaryColor,
        body: SingleChildScrollView(child: Container(child: _buildWeatherDetails())));
  }

  Widget _buildWeatherDetails() {
    return BlocProvider(
      create: (_) => _weatherBloc,
      child: BlocListener<WeatherBloc, WeatherState>(
        listener: (context, state) {
          if (state is WeatherErrorState) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text(
                    "Oops!",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  content: Container(
                    height: 20.h,
                    child: Column(
                      children: [
                        state.message == "No internet connection"
                            ? Container(
                                height: 10.h,
                                child: Lottie.asset(
                                  'assets/json/no_internet.json',
                                ),
                              )
                            : Container(
                                height: 10.h,
                                child: Lottie.asset(
                                  'assets/json/not_found.json',
                                ),
                              ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            state.message,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    state.message == "No internet connection"
                        ? TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const OfflineWeatherPage(),
                                ),
                              );
                            },
                            child: const Text(
                              "View Offline Data",
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 15),
                            ),
                          )
                        : const SizedBox(
                            height: 1,
                            width: 1,
                          ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ),
                        );
                      },
                      child: const Text(
                        "Retry",
                        style: TextStyle(color: Colors.teal, fontSize: 15),
                      ),
                    ),
                  ],
                );
              },
            );
          }
        },
        child: BlocBuilder<WeatherBloc, WeatherState>(
          builder: (context, state) {
            if (state is WeatherInitial) {
              return _buildLoading();
            } else if (state is WeatherLoadingState) {
              return _buildLoading();
            } else if (state is WeatherSuccessState) {
              _saveWeatherData(state.weatherForecast);
              return _buildWeatherBody(context, state.weatherForecast);
            } else if (state is WeatherErrorState) {
              return Container();
            } else {
              return Container();
            }
          },
        ),
      ),
    );
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
        width: double.infinity,
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
                    )
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
                            builder: (context) => FiveDayForecastPage(
                              forecast: forecast,
                              cityName: widget.cityName,
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

  Widget _buildLoading() => Center(child: buildLoader());

  Future<void> _saveWeatherData(List<Weather> forecast) async {
    final dbHelper = DatabaseHelper.instance;
    bool dataUpdated = false;
    Map<String, List<Weather>> groupedData = {};
    for (var weather in forecast) {
      String cityNameLowercase = widget.cityName.toLowerCase();
      if (!groupedData.containsKey(cityNameLowercase)) {
        groupedData[cityNameLowercase] = [];
      }
      groupedData[cityNameLowercase]!.add(weather);
    }
    for (var cityName in groupedData.keys) {
      var existingCity = await dbHelper.queryCity(cityName);
      if (existingCity != null) {
        List<Weather> cityWeatherData = groupedData[cityName]!;
        await dbHelper.updateWeatherDataBatch(
            existingCity['id'], cityWeatherData);
        dataUpdated = true;
      } else {
        List<Weather> cityWeatherData = groupedData[cityName]!;
        await dbHelper.insertWeatherDataBatch(cityName, cityWeatherData);
      }
    }

    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(dataUpdated
            ? ' Update synced successfully'
            : 'Data saved successfully'),
      ),
    );
  }
}
