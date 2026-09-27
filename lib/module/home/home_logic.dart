import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import '../../provider/api_service.dart';
import '../../utils/asset_constant.dart';
import 'data_model/weather_data_model.dart';

class HomeLogic extends GetxController {
  RxBool isLoading = true.obs;
  RxBool isSearchLoading = false.obs;
  var weatherList = <WeatherDataModel>[].obs,
      searchHistory = <String>[].obs;
  var searchedCity = ''.obs,
      temperature = ''.obs,
      weatherIconPath = ''.obs;
  var homeCity = ''.obs,
      homeTemp = ''.obs,
      homeIcon = ''.obs;
  RxBool isDarkMode = false.obs;
  final TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> allApiDistricts = [];
  var addedCitiesList = <Map<String, String>>[].obs;
  RxString cityName = 'dhaka'.obs;

  @override
  void onInit() {
    super.onInit();
    isDarkMode.value = Get.isDarkMode;
    Future.delayed(const Duration(seconds: 3), () {
      isLoading.value = false;
      fetchWeatherData();
      fetchAllDistrictsFromApi();
    });
  }
  Future<void> fetchWeatherData() async {
    isLoading.value = true;
    final dio.Response? response = await ApiServices().apiGetCall(cityName: cityName.value);

    if (response != null && response.statusCode == 200 && response.data != null) {
      weatherList.assignAll(WeatherDataModel.fromJsonList(response.data));
      if (weatherList.isNotEmpty) {
        homeTemp.value = "${response.data['main']['temp'].round()}°";
        homeCity.value = response.data['name'] ?? 'Dhaka';
        String iconCode = '';
        if (response.data['weather'] != null && (response.data['weather'] as List).isNotEmpty) {
          iconCode = response.data['weather'][0]['icon'] ?? '';
        }
        homeIcon.value = getWeatherIcon(iconCode);
      }
    }
    isLoading.value = false;
  }
  String getWeatherIcon(String iconCode) {
    if (['01d', '01n'].contains(iconCode)) return AssetConstants.sunny;
    if (['02d', '02n', '03d', '03n'].contains(iconCode)) return AssetConstants.partyCloudy;
    if (['04d', '04n'].contains(iconCode)) return AssetConstants.cloudy;
    if (['09d', '09n', '10d', '10n', '11d', '11n'].contains(iconCode)) return AssetConstants.rain;return AssetConstants.sunny;
  }

  Future<void> fetchAllDistrictsFromApi() async {
    try {

      final res = await ApiServices().getCity();

      if (res?.statusCode == 200) {
        final List<dynamic> dataList = res?.data?['data'] ?? [];

        allApiDistricts = dataList.map((item) =>
        {
          'id': item['id'] ?? 0,
          'text': item['text'] ?? item['name'] ?? ''
        }).toList();

        if (allApiDistricts.isNotEmpty) {
          searchHistory.assignAll(
            allApiDistricts.take(10).map((item) =>
                item['text'].toString().split('-').first.trim()),
          );
        }
        debugPrint("Successfully loaded ${allApiDistricts.length} districts.");
      }
    } catch (e) {
      debugPrint("Dynamic Dropdown API Error: $e");
    }
  }

  Future<void> performSearch(String query) async {
    if (query.trim().isEmpty) return;
    String formattedQuery = query.split('-').first.trim();
    isSearchLoading.value = true;

    final dio.Response? response = await ApiServices().apiGetCall(
        cityName: formattedQuery);

    if (response != null && response.statusCode == 200) {
      homeCity.value = response.data['name'] ?? formattedQuery;
      homeTemp.value = "${response.data['main']['temp'].round()}°";

      if (response.data['weather'] != null &&
          (response.data['weather'] as List).isNotEmpty) {
        String iconCode = response.data['weather'][0]['icon'] ?? '';
        weatherIconPath.value = getWeatherIcon(iconCode);
      }
      searchHistory.remove(searchedCity.value);
      searchHistory.insert(0, searchedCity.value);
      if (searchHistory.length > 10) searchHistory.removeLast();

      searchController.clear();

      Get.back();
    }
  }


  void removeFromHistory(String city) => searchHistory.remove(city);

}
