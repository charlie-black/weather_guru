

import 'dart:convert';


List<CitiesModel> citiesModelFromJson(List<dynamic>items) => List<CitiesModel>.from(items.map((x) => CitiesModel.fromJson(x)));
String citiesModelToJson(List<CitiesModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));


class CitiesModel {
  String name;
  double latitude;
  double longitude;
  String country;
  int population;
  bool isCapital;

  CitiesModel({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.country,
    required this.population,
    required this.isCapital,
  });

  factory CitiesModel.fromJson(Map<String, dynamic> json) => CitiesModel(
    name: json["name"],
    latitude: json["latitude"]?.toDouble(),
    longitude: json["longitude"]?.toDouble(),
    country: json["country"],
    population: json["population"],
    isCapital: json["is_capital"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "latitude": latitude,
    "longitude": longitude,
    "country": country,
    "population": population,
    "is_capital": isCapital,
  };
}
