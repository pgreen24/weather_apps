import 'package:flutter/material.dart';
import 'package:weather_apps/module/home/widgets/home_district_search.dart';
import 'package:get/get.dart';

class HomeSearch extends StatelessWidget{
  const HomeSearch ({super.key});

  @override
  Widget build(BuildContext context) {

       return Align(
         alignment: Alignment.centerRight,
         child:IconButton( onPressed: () {Get.to(() => const HomeDistrictSearch());},
           icon: const Icon(
             Icons.search,
             size:28.0,
           ) ,
         ),
       );

  }
}
