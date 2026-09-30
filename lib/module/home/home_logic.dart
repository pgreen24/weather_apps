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
  RxString description=''.obs;
  RxString  temp = ''.obs;
  RxString icon = ''.obs;
  RxString weatherMain = ''.obs;
  RxString feelslike =''.obs;
  RxString tempmin =''.obs;
  RxString tempmax =''.obs;
  RxBool isDarkMode = false.obs;
  List<Map<String, dynamic>> allApiDistricts = [];
  RxString cityName = 'chandpur'.obs;
  final RxList<dynamic> searchDistricts = <dynamic>[].obs;
  final RxBool isSearching = false.obs;
  var selectedDistrict = ''.obs;
  RxList<String> searchHistory = <String>[].obs;

  @override
  Future <void> onInit()  async{
    super.onInit();
    isDarkMode.value = Get.isDarkMode;
    await allDistrictsFromApi();
    if (district.isNotEmpty) {
      // cityName.value = district.first;
      final defaultCity = district.firstWhere(
              (c) => c.toString().toLowerCase() == 'chandpur',
          orElse: () => district.first.toString()
      );
      cityName.value = defaultCity;
      selectedDistrict.value = defaultCity;
    }
    await weatherData();
  }

  void lima (dynamic data, String cityName) {
    city.value = data['name'] ?? 'Chandpur';
    temp.value = "${data['main']['temp'].round()}";
    icon.value = getWeatherIcon(data['weather']?[0]?['icon'] ?? '');
    weatherMain.value = (data['weather']?[0]?['main'] ?? '').toString().capitalizeFirst ?? '';
    feelslike.value = "${data['main']['feels_like'].round()}";
    tempmin.value = "${data['main']['temp_min'].round()}";
    tempmax.value = "${data['main']['temp_max'].round()}";

  }

  Future<void> weatherData() async {
    final res = await ApiServices().weatherData(cityName: cityName.value);

    if ( res.statusCode == 200 ) {
      lima(res!.data, cityName.value);
      weatherList.assignAll(WeatherDataModel.fromJsonList([res.data]));
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

        if ( res.statusCode == 200) {
          final List<dynamic> dataList = res.data?['data'] ?? [];
          allApiDistricts = dataList.map((item) => {
            'id': item['id'] ?? 0,
            'name': item['name'] ?? ''
          }).toList();

            district .assignAll(allApiDistricts.map<String>((item) =>
                item['name'].toString().split('-').first.trim()),);

        }
      }

      String targetCity = name ?? cityName.value;
      if (name != null) {
        selectedDistrict.value = name;
      }
      if (targetCity.toLowerCase() == 'chattogram') {
        targetCity = 'Chittagong';
      } else if (targetCity.toLowerCase() == 'coxsbazar') {
        targetCity = "Cox's bazar";
      }

      isWeatherLoading.value = true;

      final res = await ApiServices().weatherData(cityName: targetCity);
      if (res?.statusCode == 200) {
        lima(res!.data, targetCity);
        weatherList.assignAll(WeatherDataModel.fromJsonList([res.data]));
      }
    } catch (e) {
      debugPrint("Error:$e");
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
