import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../presentation/controllers/datafetchcontroller.dart';

abstract class FetchRemoteDataSource {
  Future<List<Map<String, dynamic>>> fetchDataSource();
}

class FetchRemoteDataSourceImpl extends FetchRemoteDataSource {
  RxList<Map<String, dynamic>> finalCountryList = <Map<String, dynamic>>[].obs;
  DataFetchController datasourcecontroller = Get.find();

  List<Map<String, dynamic>> finalCountryMap = <Map<String, dynamic>>[].obs;

  RxList<Map<String, dynamic>> get filterdata => finalCountryList;

  @override
  Future<List<Map<String, dynamic>>> fetchDataSource() async {
    http.Response response;

    response = await http.get(Uri.parse('https://restcountries.com/v3.1/all'));

    //print("FetchCityResponseBody: ${response.body}");

    if (response.statusCode == 200) {
      List<Map<String, dynamic>>? temp = (jsonDecode(response.body) as List)
          .map((e) => e as Map<String, dynamic>)
          .toList();

      return temp;
    } else {
      throw Exception();
    }
  }
}
