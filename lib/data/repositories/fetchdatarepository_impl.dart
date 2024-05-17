import 'package:dartz/dartz.dart';
import 'package:get/get.dart';

import '../../domain/repositories/fetchdatarespository.dart';
import '../datasources/fetch_remote_data.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class FetchdataRepositoryImpl implements FetchdataRepository {
  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> fetchdata() async {
    InternetConnectionChecker connectionChecker = InternetConnectionChecker();

    try {
      List<Map<String, dynamic>> datList = <Map<String, dynamic>>[];
      if (await connectionChecker.hasConnection) {
        datList = await FetchRemoteDataSourceImpl().fetchDataSource();
      }
      return Right(datList);
    } catch (e) {
      e.printError();
      throw Exception();
    }
  }
}
