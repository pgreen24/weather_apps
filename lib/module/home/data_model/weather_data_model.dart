import 'package:intl/intl.dart';
class  WeatherDataModel {
  WeatherDataModel({
    this.id = 0,
    this.main = '',
    this.description = '',
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
  final String description;
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
      description: weatherMap?['description'] ?? '',
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
  String get formattedLocalTime {
    final nowUtc = DateTime.now().toUtc();
    final localDateTime = nowUtc.add(Duration(seconds: timezone));
    return DateFormat('hh:mm a').format(DateTime.parse(localDateTime.toIso8601String()));
  }

  String get formattedSunrise {
    if (sunrise == 0) return '--:--';
    final dateTime = DateTime.fromMillisecondsSinceEpoch(sunrise * 1000, isUtc: true)
        .add(Duration(seconds: timezone));
    return DateFormat('hh:mm a').format(DateTime.parse(dateTime.toIso8601String()));
  }

  String get formattedSunset {
    if (sunset == 0) return '--:--';
    final dateTime = DateTime.fromMillisecondsSinceEpoch(sunset * 1000, isUtc: true)
        .add(Duration(seconds: timezone));
    return DateFormat('hh:mm a').format(DateTime.parse(dateTime.toIso8601String()));
  }

  String get lengthOfDay {
    if (sunrise == 0 || sunset == 0) return '0H 0M';
    final difference = Duration(seconds: sunset - sunrise);
    final hours = difference.inHours;
    final minutes = difference.inMinutes.remainder(60);
    return '${hours}H ${minutes}M';
  }

  String get remainingDaylight {
    if (sunrise == 0 || sunset == 0) return '0H 0M';

    final localNow = DateTime.now().toUtc().add(Duration(seconds: timezone));
    final localSunset = DateTime.fromMillisecondsSinceEpoch(sunset * 1000, isUtc: true)
        .add(Duration(seconds: timezone));

    if (localNow.isAfter(localSunset)) {
      return '0H 0M';
    }

    final difference = localSunset.difference(localNow);
    final hours = difference.inHours;
    final minutes = difference.inMinutes.remainder(60);

    if (hours < 0 || minutes < 0) return lengthOfDay;

    return '${hours}H ${minutes}M';
  }

  double get sunProgress {
    if (sunrise == 0 || sunset == 0) return 0.0;

    final localNow = DateTime.now().toUtc().add(Duration(seconds: timezone));
    final localSunrise = DateTime.fromMillisecondsSinceEpoch(sunrise * 1000, isUtc: true)
        .add(Duration(seconds: timezone));
    final localSunset = DateTime.fromMillisecondsSinceEpoch(sunset * 1000, isUtc: true)
        .add(Duration(seconds: timezone));

    if (localNow.isBefore(localSunrise)) return 0.0;
    if (localNow.isAfter(localSunset)) return 1.0;

    final totalDaySeconds = localSunset.difference(localSunrise).inSeconds;
    final currentDaySeconds = localNow.difference(localSunrise).inSeconds;

    return (currentDaySeconds / totalDaySeconds).clamp(0.0, 1.0);
  }

  static List<WeatherDataModel> fromJsonList(dynamic json) {
    if (json == null) return [];
    if (json is Map<String, dynamic>) {
      return [WeatherDataModel.fromJson(json)];
    }
    if (json is List) {
      return json.map((item) => WeatherDataModel.fromJson(item as Map<String, dynamic>)).toList();
    }
    return [];
  }
}
