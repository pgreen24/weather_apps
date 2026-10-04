import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class ApiServices {
  final _dio = Dio();
  final String apiKey = "5bb2fad344d660b556f0e152837cdb89";

  Future<dynamic> weatherData({required String cityName}) async {
    try {
      final response = await _dio.get(
        'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&appid=5bb2fad344d660b556f0e152837cdb89&units=metric',
      );
      return response;
    } catch (e) {
      FlutterError.onError;
    }
  }

  Future<dynamic> getCity() async {
    final String url =
        "https://api.emedicinebd.com/api/CommonAPI/GetDropdownList?ProcedureName=SP_SelectGetAllDropDown&CallName=GETALLDISTRICT&Param1=1&Param2=0&Param3=0&Param4=0&Param5=0";

    try {
      final response = await _dio.get(url);

      return response;
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>?> weatherLocation(double lat, double lon) async {
    final String url = "https://openweathermap.org";

    try {
      final response = await _dio.get(url);

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        debugPrint("Server Error: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      debugPrint("Location Forecast Exception: $e");
      return null;
    }  }
}
