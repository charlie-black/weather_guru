import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:weather_guru/environment.dart';
import 'package:weather_guru/screens/offline_data/saved_city_weather_data.dart';
import 'package:weather_guru/screens/today_weather_page.dart';
import 'package:weather_guru/utils/constants.dart';

import '../utils/api_response.dart';
import '../utils/internet_connectivity.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController cityController = TextEditingController();
  List<String> _citySuggestions = [];

  Future<ApiResponse> fetchCitySuggestions(String input) async {
    if (input.length < 3) {
      setState(() {
        _citySuggestions.clear();
      });
      return ApiResponse(
          content: null,
          errorMessage: "Input must be at least 3 characters long.");
    }

    String apiKey = citiesXApiKey;
    String apiUrl = "$citiesEndpointUrl$input";

    try {
      var connectivityNotifier = ConnectivityNotifier();
      bool isConnected = await connectivityNotifier.checkInternetConnection();
      if (!isConnected) {
        return ApiResponse(
            content: null, errorMessage: "No internet connection");
      }

      Response response = await Dio()
          .get(apiUrl, options: Options(headers: {'X-Api-Key': apiKey}));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = response.data;
        setState(() {
          _citySuggestions = jsonData.map((e) => e['name'].toString()).toList();
        });
        return ApiResponse(content: _citySuggestions, errorMessage: "");
      } else {
        return ApiResponse(
            content: null,
            errorMessage: 'Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      return ApiResponse(
          content: null, errorMessage: 'Request failed with error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop){
        exit(0);
      },
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(5.0),
          child: SpeedDial(
            icon: Icons.menu,
            activeIcon: Icons.close,
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            activeBackgroundColor: Colors.black,
            activeForegroundColor: Colors.white,
            visible: true,
            closeManually: false,
            curve: Curves.bounceIn,
            overlayColor: Colors.black,
            overlayOpacity: 0.5,
            elevation: 8.0,
            shape: const CircleBorder(),
            children: [
              SpeedDialChild(
                child: const Icon(Icons.remove_red_eye_outlined),
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                label: 'View Offline Data',
                labelStyle: TextStyle(color: kBackgroundColor, fontSize: 12),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OfflineWeatherPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        backgroundColor: kPrimaryColor,
        body: SingleChildScrollView(
          child: Container(
            color: kPrimaryColor,
            height: 100.h,
            child: Column(
              children: [
                SizedBox(
                  height: 20.h,
                ),
                Lottie.asset('assets/json/compass.json', height: 150, width: 150),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Weather Guru',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    keyboardType: TextInputType.text,
                    controller: cityController,
                    textInputAction: TextInputAction.search,
                    onEditingComplete: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WeatherPage(
                            cityName: cityController.text,
                          ),
                        ),
                      );
                    },
                    onChanged: (value) {
                      if (value.length >= 3) {
                        fetchCitySuggestions(value);
                      } else {
                        setState(() {
                          _citySuggestions.clear();
                        });
                      }
                    },
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          if (cityController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Enter city name before proceeding",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WeatherPage(
                                  cityName: cityController.text,
                                ),
                              ),
                            );
                          }
                        },
                        icon: const Icon(
                          Icons.search,
                          color: Colors.black,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      labelText: 'Type in a City',
                      labelStyle: const TextStyle(
                          fontWeight: FontWeight.normal, color: Colors.black),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(width: 0, color: Colors.black),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(width: 0, color: Colors.black),
                      ),
                    ),
                    style: const TextStyle(color: Colors.black, fontSize: 15),
                  ),
                ),
                const SizedBox(height: 16.0),
                Expanded(
                  child: ListView.builder(
                    itemCount: _citySuggestions.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          _citySuggestions[index],
                          style: const TextStyle(color: Colors.black),
                        ),
                        onTap: () {
                          cityController.text = _citySuggestions[index];
                          setState(() {
                            _citySuggestions.clear();
                          });
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
