import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
class ApiServices {
  final _dio = Dio();

  Future<dynamic> apiGetCall({required String cityName}) async {
    try {
      final response = await _dio.get(
          'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=5bb2fad344d660b556f0e152837cdb89&units=metric');
      return response;
    }
    catch (e) {
      FlutterError.onError;
    }
  }
}