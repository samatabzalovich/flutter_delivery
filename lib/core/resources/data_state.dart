import 'package:flutter_delivery/core/error/state_exception.dart';

abstract class DataState<T> {
  final T? data;
  final StateException? error;
  const DataState({
    this.data,
    this.error,
  });
  
}

class DataSuccess<T> extends DataState<T> {
  const DataSuccess(T data) : super(data: data);
}

class DataFailed<T> extends DataState<T> {
  const DataFailed(StateException error) : super(error: error);
}
