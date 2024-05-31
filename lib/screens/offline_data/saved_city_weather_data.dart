import 'package:flutter/material.dart';
import 'package:weather_guru/screens/offline_data/detailed_city_weather.dart';
import 'package:weather_guru/screens/select_city_page.dart';
import 'package:weather_guru/utils/constants.dart';
import 'package:weather_guru/utils/database/database_helper.dart';
import 'package:weather_guru/utils/helpers.dart';

class OfflineWeatherPage extends StatefulWidget {
  const OfflineWeatherPage({super.key});

  @override
  _OfflineWeatherPageState createState() => _OfflineWeatherPageState();
}

class _OfflineWeatherPageState extends State<OfflineWeatherPage> {
  List<Map<String, dynamic>> _weatherData = [];
  final dbHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    _fetchOfflineData();
  }

  Future<void> _fetchOfflineData() async {
    final dbHelper = DatabaseHelper.instance;
    List<Map<String, dynamic>> weatherData = await dbHelper.getAllWeatherData();
    setState(() {
      _weatherData = weatherData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Recent Cities Weather',
              style: TextStyle(color: kBackgroundColor)),
        ),
        body: _buildWeatherList(),
      ),
    );
  }

  Widget _buildWeatherList() {
    if (_weatherData.isEmpty) {
      return Center(
        child: Text(
          'No offline weather data available.',
          style: TextStyle(color: kBackgroundColor),
        ),
      );
    } else {
      Map<String, List<Map<String, dynamic>>> groupedWeatherData = {};

      for (var weather in _weatherData) {
        String cityName = weather['cityName'];
        if (!groupedWeatherData.containsKey(cityName)) {
          groupedWeatherData[cityName] = [];
        }
        groupedWeatherData[cityName]!.add(weather);
      }

      return ListView.builder(
        itemCount: groupedWeatherData.length,
        itemBuilder: (context, index) {
          String cityName = groupedWeatherData.keys.toList()[index];
          List<Map<String, dynamic>> cityWeatherData =
              groupedWeatherData[cityName]!;
          var todayForecast = cityWeatherData.first;

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
              onTap: () async {
                    String? updatedTime = await dbHelper
                        .getUpdatedTimeForCity(cityName);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailedSavedCityWeather(
                          cityName: cityName,
                          savedWeatherData: cityWeatherData,
                          updatedTime: updatedTime!,
                        ),
                      ),
                    );
              },
              leading: CircleAvatar(
                backgroundColor: Colors.black.withOpacity(0.9),
                radius: 30,
                child: Image.asset(
                  'assets/icons/${todayForecast['weatherIcon']}.png',
                  height: 30,
                  width: 30,
                ),
              ),
              title: Text(
                capitalizeFirstLetter(cityName),
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: Text(
                "${todayForecast['temperature']}°C",
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );


        },
      );
    }
  }
}
