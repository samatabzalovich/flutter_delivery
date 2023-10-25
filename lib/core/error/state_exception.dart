

import 'package:dio/dio.dart';

class StateException implements Exception {
  final DioException? error;
  final String message;

  StateException({this.error,required this.message});
}
