import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';
import 'package:weather_guru/environment.dart';
import 'package:weather_guru/screens/today_weather_page.dart';
import 'package:weather_guru/utils/constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController cityController = TextEditingController();
  List<String> _citySuggestions = [];

  void fetchCitySuggestions(String input) async {
    if (input.length < 3) {
      setState(() {
        _citySuggestions.clear();
      });
      return;
    }

    String apiKey = citiesXApiKey;
    String apiUrl = "$citiesEndpointUrl$input";
    Map<String, String> headers = {
      'X-Api-Key': apiKey,
    };
    http.Response response =
    await http.get(Uri.parse(apiUrl), headers: headers);
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      setState(() {
        _citySuggestions =
            jsonData.map((e) => e['name']).toList().cast<String>();
      });
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,

      body: SingleChildScrollView(
        child: Container(
          color: kPrimaryColor,
          height: 100.h,
          child: Column(
            children: [
              SizedBox(
                height: 10.h,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Weather Guru',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
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
                        if(cityController.text.isEmpty){
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Enter city name before proceeding",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15),),
                            ),
                          );
                        }else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  WeatherPage(
                                    cityName: cityController.text,
                                  ),
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.search,color: Colors.black,),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    labelText: 'Enter City',
                    labelStyle: const TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.black),
                    enabledBorder: const OutlineInputBorder(
                      borderSide:
                      BorderSide(width: 0, color: Colors.black),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide:
                      BorderSide(width: 0, color: Colors.black),
                    ),
                  ),
                  style: const TextStyle(
                      color: Colors.black, fontSize: 15),
                ),
              ),
              const SizedBox(height: 16.0),
              Expanded(
                child: ListView.builder(
                  itemCount: _citySuggestions.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_citySuggestions[index],style: const TextStyle(color: Colors.black),),
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
    );
  }
}
