import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ConnectivityNotifier with ChangeNotifier {
  bool _isConnected = true;

  bool get isConnected => _isConnected;

  Future<void> checkConnectivity(BuildContext context) async {
    bool isConnected = await checkInternetConnection();

    _isConnected = isConnected;

    notifyListeners();
    print(_isConnected);

    if (!isConnected) {
    }
  }

  Future<bool> checkInternetConnection() async {
    print("called");
    try {
      final response = await Dio().get('https://www.google.com');
      return response.statusCode == 200;
    } catch (e) {
      print("Error checking internet connectivity: $e");
      return false;
    }
  }
}
