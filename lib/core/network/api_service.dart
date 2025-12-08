import 'package:crypto_tracker/core/network/result.dart';
import 'package:dio/dio.dart';
import '../errors/failures.dart';

class ApiService {
  final Dio dio;

  ApiService(this.dio);

  Future<Result<Response>> get(String path, {Map<String, dynamic>? query}) async {
    try {
      final response = await dio.get(path, queryParameters: query);
      return Success(response);
    } on DioException catch (e) {
      return FailureResult(ServerFailure.fromDioException(dioException: e));
    } catch (e) {
      return FailureResult(GeneralFailure(errMessage: e.toString()));
    }
  }

  Future<Result<Response>> post(String path, {dynamic data, Map<String, dynamic>? query,}) async {
    try {
      final response =
      await dio.post(path, data: data, queryParameters: query);
      return Success(response);
    } on DioException catch (e) {
      return FailureResult(ServerFailure.fromDioException(dioException: e));
    } catch (e) {
      return FailureResult(GeneralFailure(errMessage: e.toString()));
    }
  }

  Future<Result<Response>> put(String path, {dynamic data,}) async {
    try {
      final response = await dio.put(path, data: data);
      return Success(response);
    } on DioException catch (e) {
      return FailureResult(ServerFailure.fromDioException(dioException: e));
    } catch (e) {
      return FailureResult(GeneralFailure(errMessage: e.toString()));
    }
  }

  Future<Result<Response>> delete(String path, {Map<String, dynamic>? query,}) async {
    try {
      final response = await dio.delete(path, queryParameters: query);
      return Success(response);
    } on DioException catch (e) {
      return FailureResult(ServerFailure.fromDioException(dioException: e));
    } catch (e) {
      return FailureResult(GeneralFailure(errMessage: e.toString()));
    }
  }
}
