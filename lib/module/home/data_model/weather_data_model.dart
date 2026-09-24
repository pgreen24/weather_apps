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
}
