import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:get/get.dart';
import '../../provider/api_service.dart';
import '../../utils/asset_constant.dart';
import 'data_model/weather_data_model.dart';
import 'package:geolocator/geolocator.dart';

class HomeLogic extends GetxController {
  RxBool isLoading = true.obs;
  RxBool isWeatherLoading = false.obs;
  RxList weatherList = <WeatherDataModel>[].obs;
  RxList district = <String>[].obs;
  RxString city = ''.obs;
  RxString description = ''.obs;
  RxString temp = ''.obs;
  RxString icon = ''.obs;
  RxString weatherMain = ''.obs;
  RxString feelslike = ''.obs;
  RxString tempmin = ''.obs;
  RxString tempmax = ''.obs;
  RxString pressure = ''.obs;
  RxBool isDarkMode = false.obs;
  List<Map<String, dynamic>> allApiDistricts = [];
  RxString cityName = ''.obs;
  final RxList<dynamic> searchDistricts = <dynamic>[].obs;
  final RxBool isSearching = false.obs;
  var selectedDistrict = ''.obs;
  RxList<String> searchHistory = <String>[].obs;
  RxList hourlyForecastList = [].obs;
  RxString selectedForecastDate = ''.obs;


  RxString locationError = ''.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isDarkMode.value = Get.isDarkMode;
    await loadLocationWeather();
  }


  Future<void> loadLocationWeather() async {
    isLoading.value = true;
    locationError.value = '';


    final results = await Future.wait([
      loadDistricts(),
      _determinePosition(),
    ]);
    final position = results[1] as Position?;

    if (position != null) {
      final ok = await weatherByLocation(position.latitude, position.longitude);
      if (ok) {
        isLoading.value = false;
        return;
      }
      if (locationError.value.isEmpty) {
        locationError.value = 'Error';
      }
    }


    isLoading.value = false;
  }

  void applyForecast(dynamic data, String currentCityName) {
    lima(data, currentCityName);
    hourlyForecastList.assignAll(data['list'] ?? []);
    if (hourlyForecastList.isNotEmpty) {
      final String dtTxt = hourlyForecastList.first['dt_txt'] ?? '';
      if (dtTxt.length >= 10) {
        selectedForecastDate.value = dtTxt.substring(0, 10);
      }
    }
    hourlyForecastList.refresh();

    if (data is Map<String, dynamic>) {
      weatherList.assignAll(WeatherDataModel.fromJsonList(data));
    }
  }

  void lima(dynamic data, String currentCityName) {
    final cityMap = data['city'];
    city.value = cityMap?['name'] ?? currentCityName;
    final list = data['list'] as List?;
    if (list != null && list.isNotEmpty) {
      final currentBlock = list[0];

      temp.value = "${currentBlock['main']['temp'].round()}";
      icon.value = getWeatherIcon(currentBlock['weather']?[0]?['icon'] ?? '');
      weatherMain.value =
          (currentBlock['weather']?[0]?['main'] ?? '').toString().capitalizeFirst ?? '';
      feelslike.value = "${currentBlock['main']['feels_like'].round()}";
      tempmin.value = "${currentBlock['main']['temp_min'].round()}";
      tempmax.value = "${currentBlock['main']['temp_max'].round()}";
      pressure.value = "${currentBlock['main']['pressure']}";
    }
  }

  Future<void> weatherData() async {
    if (cityName.value.isEmpty) {
      isLoading.value = false;
      return;
    }
    final res = await ApiServices().weatherData(cityName: cityName.value);
    if (res?.statusCode == 200) {
      applyForecast(res.data, cityName.value);
    }
    isLoading.value = false;
  }

  String getWeatherIcon(String iconCode) {
    if (['01d', '01n'].contains(iconCode)) return AssetConstants.sunny;
    if (['02d', '02n', '03d', '03n'].contains(iconCode)) return AssetConstants.partyCloudy;
    if (['04d', '04n'].contains(iconCode)) return AssetConstants.cloudy;
    if (['09d', '09n', '10d', '10n', '11d', '11n'].contains(iconCode)) return AssetConstants.rain;
    return AssetConstants.sunny;
  }

  Future<Position?> _determinePosition() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        locationError.value = 'The device location (GPS) is off. Turn it on.';
        return null;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied) {
        locationError.value = 'Location permission not granted.';
        return null;
      }
      if (permission == LocationPermission.deniedForever) {
        locationError.value = 'Location permission permanently blocked.';
        return null;
      }

      try {
        return await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            timeLimit: Duration(seconds: 15),
          ),
        );
      } catch (e) {
        debugPrint('getCurrentPosition failed: $e');
        final last = await Geolocator.getLastKnownPosition();
        if (last != null) return last;
        locationError.value = 'Current location not found. Please try again.';
        return null;
      }
    } catch (e) {
      debugPrint('Location error: $e');
      locationError.value = 'Location access error.';
      return null;
    }
  }

  Future<bool> weatherByLocation(double lat, double lon) async {
    final res = await ApiServices().weatherByCoords(lat: lat, lon: lon);
    if (res?.statusCode != 200) return false;

    final apiCity = (res.data['city']?['name'] ?? '').toString();

    final match = district.firstWhere(
          (d) => d.toString().toLowerCase() == apiCity.toLowerCase(),
      orElse: () => '',
    );

    final finalCityName = match.toString().isNotEmpty ? match.toString() : apiCity;

    selectedDistrict.value = finalCityName;
    cityName.value = finalCityName;
    applyForecast(res.data, finalCityName);

    return true;
  }

  Future<void> allDistrictsFromApi([String? name]) async {
    try {
      await loadDistricts();

      String targetCity = name ?? cityName.value;
      if (targetCity.trim().isEmpty) return;
      if (name != null) {
        selectedDistrict.value = name;
        cityName.value = name;
      }

      String apiCityName = targetCity.trim();
      if (apiCityName.toLowerCase().replaceAll(' ', '') == 'coxsbazar') {
        apiCityName = "Cox's Bazar";
      } else if (apiCityName.toLowerCase().replaceAll(' ', '') == 'chattogram') {
        apiCityName = 'Chittagong';
      }

      isWeatherLoading.value = true;
      locationError.value = '';

      final res = await ApiServices().weatherData(cityName: apiCityName);
      if (res?.statusCode == 200) {
        applyForecast(res.data, apiCityName);
      }
    } catch (e) {
      debugPrint("Error:$e");
    } finally {
      isWeatherLoading.value = false;
    }
  }

  Future<void> loadDistricts() async {
    if (allApiDistricts.isNotEmpty) return;
    final res = await ApiServices().getCity();
    if (res?.statusCode == 200) {
      final List<dynamic> dataList = res.data?['data'] ?? [];
      allApiDistricts = dataList
          .map((item) => {'id': item['id'] ?? 0, 'name': item['name'] ?? ''})
          .toList();
      district.assignAll(
        allApiDistricts.map<String>(
                (item) => item['name'].toString().split('-').first.trim()),
      );
    }
  }

  void removeFromHistory(String city) {
    searchHistory.remove(city);
  }

  void addToHistory(String city) {
    if (!searchHistory.contains(city)) {
      searchHistory.insert(0, city);
    }
  }

  @override
  void onClose() {
    searchDistricts.clear();
    isSearching.value = false;
    super.onClose();
  }
}