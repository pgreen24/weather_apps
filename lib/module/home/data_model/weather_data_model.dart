import 'package:intl/intl.dart';
class  WeatherDataModel {
  WeatherDataModel({
    this.id = 0,
    this.main = '',
    this.icon = '',
    this.temp = 0.0,
    this.humidity = 0,
    this.windSpeed = 0.0,
    this.cityName = '',
    this.sunrise = 0,
    this.sunset = 0,
    this.timezone = 0,
    this.dt = 0,
    this.clouds = 0,

});
  final int id;
  final String main;
  final String icon;
  final double temp;
  final int humidity;
  final double windSpeed;
  final String cityName;
  final int sunrise;
  final int sunset;
  final int timezone;
  final int dt;
  final int clouds;

  factory WeatherDataModel.fromJson(Map<String, dynamic> json) {
    final weatherList = json['weather'] as List?;
    final weatherMap = (weatherList != null && weatherList.isNotEmpty)
        ? weatherList[0] as Map<String, dynamic>
        : null;

    return WeatherDataModel(
      id: weatherMap?['id'] ?? 0,
      main: weatherMap?['main'] ?? '',
      icon: weatherMap?['icon'] ?? '',
      temp: (json['main']?['temp'] ?? 0.0).toDouble(),
      humidity: json['main']?['humidity'] ?? 0,
      windSpeed: (json['wind']?['speed'] ?? 0.0).toDouble(),
      cityName: json['name'] ?? '',
      timezone: json['timezone'] ?? 0,
      dt: json['dt'] ?? 0,
      clouds: json['clouds']?['all'] ?? 0,
      sunrise: json['sys']?['sunrise'] ?? 0,
      sunset: json['sys']?['sunset'] ?? 0,
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
