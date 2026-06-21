import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../constants/map_constants.dart';

part 'network_provider.g.dart';

@riverpod
Dio dio(DioRef ref) {
  return Dio(
    BaseOptions(
      headers: {
        'User-Agent': MapConstants.overpassUserAgent,
      },
    ),
  );
}
