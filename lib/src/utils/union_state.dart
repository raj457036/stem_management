import 'package:flutter/widgets.dart';

enum UnionStateType {
  error,
  loading,
  data,
}

typedef ErrorBuilder<E> = Widget Function(E error);
typedef DataBuilder<T> = Widget Function(T data);
typedef LoadingBuilder<T> = Widget Function(T? lastData);
