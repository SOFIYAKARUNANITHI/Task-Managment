import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

abstract class FetchdataRepository {
  Future<Either<Failure, List<Map<String, dynamic>>>> fetchdata();
}

abstract class Failure extends Equatable {
  @override
  List<Object> get props => [];
}
