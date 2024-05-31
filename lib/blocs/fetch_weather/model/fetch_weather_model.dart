class Weather {
  final DateTime date;
  final double temperature;
  final String weatherDescription;
  final String weatherIcon;
  dynamic windSpeed;
  dynamic humidity;
  dynamic cloud;
  final String mainWeather;


  Weather({
    required this.date,
    required this.temperature,
    required this.weatherDescription,
    required this.weatherIcon,
    required this.windSpeed,
    required this.humidity,
    required this.cloud,
    required this.mainWeather
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      date: DateTime.parse(json["dt_txt"]),
      temperature: json['main']['temp'].toDouble(),
      weatherDescription: json['weather'][0]['description'],
      mainWeather: json['weather'][0]['main'],
      weatherIcon: json['weather'][0]['icon'],
      windSpeed: json['wind']['speed'],
      humidity: json['main']['humidity'],
      cloud: json['clouds']['all']
    );
  }
}
