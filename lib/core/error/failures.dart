import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  Failure({required this.message});
  @override
  List<Object> get props => [message];
}

// General failures
class ServerFailure extends Failure {
  final int statusCode;
  final String message;
  final dynamic response;
  ServerFailure({required this.statusCode, required this.message, this.response}) : super(message: message);
}

class CacheFailure extends Failure {
  CacheFailure({required super.message});
}

class PermissionFailure extends Failure {
  PermissionFailure({required super.message});
}
