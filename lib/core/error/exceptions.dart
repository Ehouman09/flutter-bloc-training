import 'dart:convert';

import 'package:dio/dio.dart';

class ServerException implements Exception {}

class CacheException implements Exception {}

class PlatformException implements Exception {}

class PermissionException implements Exception {}

class RequestException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic response;

  const RequestException({required this.message, required this.statusCode, this.response});

  factory RequestException.fromDioError(DioError error) {
    try {
      if (error.type == DioErrorType.response) {
        String message = "";
        if (error.response?.data != null) {
          final data = json.decode(error.response?.data);
          if (data is Map) {
            message = data["message"].toString();
          }
        } else {
          message = 'UNKNOW_ISSUE';
        }

        return RequestException(statusCode: error.response?.statusCode, message: message, response: error.response?.data);
      } else if ([DioErrorType.connectTimeout, DioErrorType.receiveTimeout, DioErrorType.sendTimeout].contains(error.type.runtimeType)) {
        return RequestException(statusCode: -1, message: 'CONNECTIVITY_ISSUE');
      } else {
        return RequestException(statusCode: -2, message: 'UNKNOW_ISSUE');
      }
    } on Error {
      return RequestException(statusCode: -2, message: 'UNKNOW_ISSUE');
    }
  }

  factory RequestException.fromJson(Map<String, dynamic> json) {
    if (json['waitingTime'] != null) {
      return RequestException(message: json['message'].toString(), statusCode: json['statusCode'] as int, response: json['waitingTime']);
    }
    return RequestException(message: json['message'].toString(), statusCode: json['statusCode'] as int, response: json['response']);
  }

  String toString() => "RequestException:\n\tcode: $statusCode\n\tmessage:$message \n\response:$response";
}
