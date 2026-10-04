import 'package:intl/intl.dart';

class WeatherDataModel {
  WeatherDataModel({
    this.id = 0,
    this.main = '',
    this.icon = '',
    this.description = '',
    this.temp = 0.0,
    this.humidity = 0,
    this.windSpeed = 0.0,
    this.cityName = '',
    this.sunrise = 0,
    this.sunset = 0,
    this.timezone = 0,
    this.feelslike = 0,
    this.dt = 0,
    this.clouds = 0,
    this.tempmin = 0,
    this.tempmax = 0,
    this.pressure =0,
  });

  final int id;
  final String main;
  final String icon;
  final String description;
  final double temp;
  final int humidity;
  final double windSpeed;
  final String cityName;
  final int sunrise;
  final int sunset;
  final int timezone;
  final int dt;
  final int clouds;
  final double feelslike;
  final double tempmin;
  final double tempmax;
  final int pressure;

  factory WeatherDataModel.fromJson(Map<String, dynamic> json) {

    final cityMap = json['city'] as Map<String, dynamic>?;


    final list = json['list'] as List?;
    final firstBlock = (list != null && list.isNotEmpty)
        ? list[0] as Map<String, dynamic>
        : <String, dynamic>{};

    final weatherList = firstBlock['weather'] as List?;
    final weatherMap = (weatherList != null && weatherList.isNotEmpty)
        ? weatherList[0] as Map<String, dynamic>
        : null;

    return WeatherDataModel(
      id: weatherMap?['id'] ?? 0,
      main: weatherMap?['main'] ?? '',
      icon: weatherMap?['icon'] ?? '',
      description: weatherMap?['description'] ?? '',


      temp: (firstBlock['main']?['temp'] ?? 0.0).toDouble(),
      feelslike: (firstBlock['main']?['feels_like'] ?? 0.0).toDouble(),
      tempmin: (firstBlock['main']?['temp_min'] ?? 0.0).toDouble(),
      tempmax: (firstBlock['main']?['temp_max'] ?? 0.0).toDouble(),
      humidity: firstBlock['main']?['humidity'] ?? 0,
      windSpeed: (firstBlock['wind']?['speed'] ?? 0.0).toDouble(),
      pressure: firstBlock['main']?['pressure'] ?? 0,
      dt: firstBlock['dt'] ?? 0,
      clouds: firstBlock['clouds']?['all'] ?? 0,
      cityName: cityMap?['name'] ?? '',
      timezone: cityMap?['timezone'] ?? 0,
      sunrise: cityMap?['sunrise'] ?? 0,
      sunset: cityMap?['sunset'] ?? 0,

    );
  }

  DateTime _loc(int ts) => DateTime.fromMillisecondsSinceEpoch(ts * 1000, isUtc: true).add(Duration(seconds: timezone));
  String _fmt(DateTime dt) => DateFormat('hh:mm a').format(dt);
  String _dur(Duration d) => '${d.inHours}H ${d.inMinutes.remainder(60)}M';
  DateTime get _now => DateTime.now().toUtc().add(Duration(seconds: timezone));

  String get formattedLocalTime => _fmt(_now);
  String get formattedSunrise => sunrise == 0 ? '--:--' : _fmt(_loc(sunrise));
  String get formattedSunset => sunset == 0 ? '--:--' : _fmt(_loc(sunset));
  String get lengthOfDay => sunrise == 0 || sunset == 0 ? '0H 0M' : _dur(Duration(seconds: sunset - sunrise));

  String get remainingDaylight => sunrise == 0 || sunset == 0 || _now.isAfter(_loc(sunset))
      ? '0H 0M' : _dur(_loc(sunset).difference(_now));

  double get sunProgress => sunrise == 0 || sunset == 0 ? 0.0
      : ((_now.millisecondsSinceEpoch - sunrise * 1000) / ((sunset - sunrise) * 1000)).clamp(0.0, 1.0);

  // --- JSON Parser ---
  static List<WeatherDataModel> fromJsonList(dynamic json) =>
      json is Map<String, dynamic> ? [WeatherDataModel.fromJson(json)] :
      json is List ? json.map((e) => WeatherDataModel.fromJson(e as Map<String, dynamic>)).toList() : [];
}
