import 'package:intl/intl.dart';
import '../blocs/fetch_weather/model/fetch_weather_model.dart';

String formatDate(DateTime dateTime) {
  String dayName = _getDayName(dateTime.weekday);
  String monthName = _getMonthName(dateTime.month);
  return '$dayName, $monthName ${dateTime.day}, ${dateTime.year}';
}

String _getDayName(int weekday) {
  switch (weekday) {
    case DateTime.monday:
      return 'Mon';
    case DateTime.tuesday:
      return 'Tue';
    case DateTime.wednesday:
      return 'Wed';
    case DateTime.thursday:
      return 'Thur';
    case DateTime.friday:
      return 'Fri';
    case DateTime.saturday:
      return 'Sat';
    case DateTime.sunday:
      return 'Sun';
    default:
      return '';
  }
}

String formatDateName(DateTime dateTime) {
  String dayName = _getDayName(dateTime.weekday);
  return '$dayName, ${dateTime.day}';
}

String _getMonthName(int month) {
  switch (month) {
    case 1:
      return 'Jan';
    case 2:
      return 'Feb';
    case 3:
      return 'Mar';
    case 4:
      return 'Apr';
    case 5:
      return 'May';
    case 6:
      return 'Jun';
    case 7:
      return 'Jul';
    case 8:
      return 'Aug';
    case 9:
      return 'Sep';
    case 10:
      return 'Oct';
    case 11:
      return 'Nov';
    case 12:
      return 'Dec';
    default:
      throw Exception('Invalid month number.');
  }
}

String formatTime(DateTime dateTime) {
  return DateFormat.jm().format(dateTime);
}

Map<String, List<Weather>> groupForecastByDate(List<Weather> forecast) {
  Map<String, List<Weather>> groupedData = {};

  for (var weather in forecast) {
    String date = DateFormat('yyyy-MM-dd').format(weather.date);

    if (groupedData.containsKey(date)) {
      groupedData[date]!.add(weather);
    } else {
      groupedData[date] = [weather];
    }
  }

  return groupedData;
}

String capitalizeFirstLetter(String text) {
  if (text.isEmpty) return text;
  return text[0].toUpperCase() + text.substring(1);
}
