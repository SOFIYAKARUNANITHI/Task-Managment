import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import "package:collection/collection.dart";

import '../../data/repositories/fetchdatarepository_impl.dart';
import '../../domain/repositories/fetchdatarespository.dart';

class DataFetchController extends GetxController {
  var isDataLoading = false.obs;
  //List<Map<String, dynamic>> fetchdataResponse = <Map<String, dynamic>>[].obs;
  List<MapEntry<dynamic, Map<dynamic, Iterable<Map<String, dynamic>>>>>
      fetchdataResponse =
      <MapEntry<dynamic, Map<dynamic, Iterable<Map<String, dynamic>>>>>[].obs;
  List<MapEntry<dynamic, Map<dynamic, Iterable<Map<String, dynamic>>>>>
      fetchdataResponseStore =
      <MapEntry<dynamic, Map<dynamic, Iterable<Map<String, dynamic>>>>>[].obs;

  List<Map<String, dynamic>> filterabledata = <Map<String, dynamic>>[].obs;

  RxString filterString = ''.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    fetchdata();
  }

  void setfiterString(String searchvalue) async {
    if (searchvalue == '') {
      fetchdataResponse = fetchdataResponseStore;
    } else {
      var filterabledatatemp = filterabledata.map((e) => e).where((element) =>
          element['name']['official']
              .toString()
              .toLowerCase()
              .contains(searchvalue.toLowerCase()));

      fetchdataResponse = groupBy(
              filterabledatatemp, (Map<String, dynamic> e) => e['region'])
          .map((key, value) => MapEntry(
              key,
              groupBy(value, (Map<String, dynamic> e) => e['name']['official'])
                  .map((key, value) =>
                      MapEntry(key, value.map((e) => e).whereNotNull()))))
          .entries
          .toList();
    }
    update();
  }

  void fetchdata() async {
    isDataLoading.value = true;
    Either<Failure, List<Map<String, dynamic>>> failureOrSuccessMessage =
        await FetchdataRepositoryImpl().fetchdata();
    _eitherErrorOrSuccessState(failureOrSuccessMessage);
  }

  _eitherErrorOrSuccessState(
    Either<Failure, List<Map<String, dynamic>>> failureOrSuccessMessage,
  ) async {
    failureOrSuccessMessage.fold(
      (l) {},
      (r) {
        var group = groupBy(r, (Map<String, dynamic> e) => e['region']).map(
            (key, value) => MapEntry(
                key,
                groupBy(value,
                        (Map<String, dynamic> e) => e['name']['official'])
                    .map((key, value) =>
                        MapEntry(key, value.map((e) => e).whereNotNull()))));
        fetchdataResponse = group.entries.toList();
        fetchdataResponseStore = fetchdataResponse;
        filterabledata = r;

        isDataLoading.value = false;
        update();
      },
    );
  }
}
