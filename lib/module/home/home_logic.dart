import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:get/get.dart';
import '../../provider/api_service.dart';
import '../../utils/asset_constant.dart';
import 'data_model/weather_data_model.dart';

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
  RxString cityName = 'chandpur'.obs;
  final RxList<dynamic> searchDistricts = <dynamic>[].obs;
  final RxBool isSearching = false.obs;
  var selectedDistrict = ''.obs;
  RxList<String> searchHistory = <String>[].obs;
  RxList hourlyForecastList = [].obs;
  RxString selectedForecastDate = ''.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isDarkMode.value = Get.isDarkMode;
    await allDistrictsFromApi();
    if (district.isNotEmpty) {
      final defaultCity = district.firstWhere(
              (c) => c.toString().toLowerCase() == 'chandpur',
          orElse: () => district.first.toString());
      cityName.value = defaultCity;
      selectedDistrict.value = defaultCity;
    }
    await weatherData();
  }

  void lima(dynamic data, String currentCityName) {
    final cityMap = data['city'];
    city.value = cityMap?['name'] ?? currentCityName;
    final list = data['list'] as List?;
    if (list != null && list.isNotEmpty) {
      final currentBlock = list[0];

      temp.value = "${currentBlock['main']['temp'].round()}";
      icon.value = getWeatherIcon(currentBlock['weather']?[0]?['icon'] ?? '');
      weatherMain.value = (currentBlock['weather']?[0]?['main'] ?? '').toString().capitalizeFirst ?? '';
      feelslike.value = "${currentBlock['main']['feels_like'].round()}";
      tempmin.value = "${currentBlock['main']['temp_min'].round()}";
      tempmax.value = "${currentBlock['main']['temp_max'].round()}";
      pressure.value = "${currentBlock['main']['pressure']}";
    }
  }

  Future<void> weatherData() async {
    final res = await ApiServices().weatherData(cityName: cityName.value);

    if (res?.statusCode == 200) {
      lima(res.data, cityName.value);
      hourlyForecastList.assignAll(res.data['list'] ?? []);
      if (hourlyForecastList.isNotEmpty) {
        final String dtTxt = hourlyForecastList.first['dt_txt'] ?? '';
        if (dtTxt.length >= 10) {
          selectedForecastDate.value = dtTxt.substring(0, 10);
        }
      }
      hourlyForecastList.refresh();

      if (res.data is Map<String, dynamic>) {
        weatherList.assignAll(WeatherDataModel.fromJsonList(res.data));
      }
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

  Future<void> allDistrictsFromApi([String? name]) async {
    try {
      if (allApiDistricts.isEmpty) {
        final res = await ApiServices().getCity();

        if (res.statusCode == 200) {
          final List<dynamic> dataList = res.data?['data'] ?? [];
          allApiDistricts = dataList.map((item) => {
            'id': item['id'] ?? 0,
            'name': item['name'] ?? ''
          }).toList();

          district.assignAll(
            allApiDistricts.map<String>((item) =>
                item['name'].toString().split('-').first.trim()),
          );
        }
      }

      String targetCity = name ?? cityName.value;
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

      final res = await ApiServices().weatherData(cityName: apiCityName);
      if (res?.statusCode == 200) {
        lima(res.data, apiCityName);
        hourlyForecastList.assignAll(res.data['list'] ?? []);
        if (hourlyForecastList.isNotEmpty) {
          final String dtTxt = hourlyForecastList.first['dt_txt'] ?? '';
          if (dtTxt.length >= 10) {
            selectedForecastDate.value = dtTxt.substring(0, 10);
          }
        }
        hourlyForecastList.refresh();
        if (res.data is Map<String, dynamic>) {
          weatherList.assignAll(WeatherDataModel.fromJsonList(res.data));
        }
      }
    } catch (e) {
      debugPrint("Error:$e");
    } finally {
      isWeatherLoading.value = false;
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
