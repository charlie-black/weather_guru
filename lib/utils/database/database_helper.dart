import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../../blocs/fetch_weather/model/fetch_weather_model.dart';

class DatabaseHelper {
  static const _databaseName = 'weather.db';
  static const _databaseVersion = 1;

  // Define the column names for the weather table
  static const String weatherTable = 'weather';
  static const String columnId = 'id';
  static const String columnCityName = 'cityName';
  static const String columnTemperature = 'temperature';
  static const String columnWeatherDescription = 'weatherDescription';
  static const String columnHumidity = 'humidity';
  static const String columnWindSpeed = 'windSpeed';
  static const String columnCloud = 'cloud';
  static const String columnDate = 'date';
  static const String columnWeatherIcon = 'weatherIcon';
  static const String columnCreatedAt = 'created_at';
  static const String columnUpdatedAt = 'updated_at';
  static const String columnMainWeather = 'mainWeather';

  // Make this a singleton class
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only allow a single open connection to the database
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await _initDatabase();
    return _database;
  }

  // Open the database, creating if it doesn't exist
  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  // SQL string to create the initial weather table
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $weatherTable (
            $columnId INTEGER PRIMARY KEY,
            $columnCityName TEXT,
            $columnTemperature REAL,
            $columnWeatherDescription TEXT,
            $columnHumidity REAL,
            $columnWindSpeed REAL,
            $columnCloud REAL,
            $columnDate TEXT,
            $columnWeatherIcon TEXT,
            $columnCreatedAt TEXT,
            $columnUpdatedAt TEXT,
            $columnMainWeather TEXT
          )
          ''');
  }

  // Query to check if a city already exists in the database
  Future<Map<String, dynamic>?> queryCity(String cityName) async {
    Database? db = await instance.database;
    List<Map<String, dynamic>> result = await db!.query(weatherTable,
        where: '$columnCityName = ?', whereArgs: [cityName.toLowerCase()]);
    return result.isNotEmpty ? result.first : null;
  }

  Future<List<Map<String, dynamic>>> getAllWeatherData() async {
    Database? db = await instance.database;
    return await db!.query(weatherTable);
  }

  // Add these methods to the DatabaseHelper class

// Batch insert weather data into the database
  Future<void> insertWeatherDataBatch(String cityName, List<Weather> weatherData) async {
    Database? db = await instance.database;
    Batch batch = db!.batch();
    for (var weather in weatherData) {
      batch.insert(weatherTable, {
        'cityName': cityName,
        'temperature': weather.temperature,
        'weatherDescription': weather.weatherDescription,
        'humidity': weather.humidity,
        'windSpeed': weather.windSpeed,
        'cloud': weather.cloud,
        'date': weather.date.toIso8601String(),
        'mainWeather':weather.mainWeather,
        'weatherIcon': weather.weatherIcon,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });
    }
    await batch.commit();
  }

// Batch update weather data in the database
  Future<void> updateWeatherDataBatch(int cityId, List<Weather> weatherData) async {
    Database? db = await instance.database;
    Batch batch = db!.batch();
    for (var weather in weatherData) {
      batch.update(weatherTable, {
        'temperature': weather.temperature,
        'weatherDescription': weather.weatherDescription,
        'humidity': weather.humidity,
        'windSpeed': weather.windSpeed,
        'cloud': weather.cloud,
        'mainWeather':weather.mainWeather,
        'date': weather.date.toIso8601String(),
        'weatherIcon': weather.weatherIcon,
        'updated_at': DateTime.now().toIso8601String(),
      }, where: '$columnId = ?', whereArgs: [cityId]);
    }
    await batch.commit();
  }

  Future<String?> getUpdatedTimeForCity(String cityName) async {
    Database? db = await instance.database;
    List<Map<String, dynamic>> result = await db!.query(
      weatherTable,
      columns: [columnUpdatedAt],
      where: '$columnCityName = ?',
      whereArgs: [cityName.toLowerCase()],
    );
    if (result.isNotEmpty) {
      return result.first[columnUpdatedAt] as String?;
    } else {
      return null;
    }
  }


}
