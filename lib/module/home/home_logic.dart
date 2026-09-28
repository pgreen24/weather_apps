import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import '../../provider/api_service.dart';
import '../../utils/asset_constant.dart';
import 'data_model/weather_data_model.dart';

class HomeLogic extends GetxController {
  RxBool isLoading = true.obs;
  RxBool isSearchLoading = false.obs;
  RxList weatherList = <WeatherDataModel>[].obs,
        District = <String>[].obs;
  RxString homeCity = ''.obs,
          homeTemp = ''.obs,
          homeIcon = ''.obs;
  RxBool isDarkMode = false.obs;
  final TextEditingController textController = TextEditingController();
  List<Map<String, dynamic>> allApiDistricts = [];

  RxString cityName = 'comilla'.obs;

  @override
  void onInit() {
    super.onInit();
    isDarkMode.value = Get.isDarkMode;
      //isLoading.value = false;
      WeatherData();
      AllDistrictsFromApi();
  }
  Future<void> WeatherData() async {
    // isLoading.value = true;
    final dio.Response? response = await ApiServices().weatherData(cityName: cityName.value);

    if (response != null && response.statusCode == 200 && response.data != null) {
        homeTemp.value = "${response.data['main']['temp'].round()}°";
        homeCity.value = response.data['name'] ?? 'comilla';
        String iconCode = '';
        if (response.data['weather'] != null && (response.data['weather'] as List).isNotEmpty) {
          iconCode = response.data['weather'][0]['icon'] ?? '';
        }
        homeIcon.value = getWeatherIcon(iconCode);
        weatherList.assignAll(WeatherDataModel.fromJsonList([response.data]));
      }

    isLoading.value = false;
  }
  String getWeatherIcon(String iconCode) {
    print("object : ${AssetConstants.sunny}");
    if (['01d', '01n'].contains(iconCode)) return AssetConstants.sunny;
    if (['02d', '02n', '03d', '03n'].contains(iconCode)) return AssetConstants.partyCloudy;
    if (['04d', '04n'].contains(iconCode)) return AssetConstants.cloudy;
    if (['09d', '09n', '10d', '10n', '11d', '11n'].contains(iconCode)) return AssetConstants.rain;return AssetConstants.sunny;
  }

  Future<void> AllDistrictsFromApi([String? name]) async {
    try {

      if (allApiDistricts.isEmpty) {
        final res = await ApiServices().getCity();

        if (res != null && res.statusCode == 200) {
          final List<dynamic> dataList = res.data?['data'] ?? [];
          allApiDistricts = dataList.map((item) => {
            'id': item['id'] ?? 0,
            'name': item['name'] ?? ''
          }).toList();

          if (allApiDistricts.isNotEmpty) {
            District .assignAll(
              allApiDistricts.map<String>((item) =>
                  item['name'].toString().split('-').first.trim()),
            );
          }
        }
      }

      String targetCity = name ?? (District .isNotEmpty ? District .first : 'comilla');


      if (targetCity.toLowerCase() == 'chattogram') {
        targetCity = 'Chittagong';
      } else if (targetCity.toLowerCase() == 'coxsbazar') {
        targetCity = "Cox's bazar";
      }

      isSearchLoading.value = true;


      final dio.Response? response = await ApiServices().weatherData(cityName: targetCity);

      if (response != null && response.statusCode == 200) {
        homeCity.value = response.data['name'] ?? targetCity;
        homeTemp.value = "${response.data['main']['temp'].round()}°";

        if (response.data['weather'] != null && (response.data['weather'] as List).isNotEmpty) {
          String iconCode = response.data['weather'][0]['icon'] ?? '';
          homeIcon.value = getWeatherIcon(iconCode);
        }
        textController.clear();
      }
    } catch (e) {

    } finally {
      isSearchLoading.value = false;
    }
  }


}
