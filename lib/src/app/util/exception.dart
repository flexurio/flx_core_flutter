import 'package:equatable/equatable.dart';

class ApiException implements Exception {
  ApiException(this.message);
  final String message;

  @override
  String toString() => 'ApiException: $message';
}

class AuthException extends Equatable implements Exception {
  const AuthException(this.type);
  final AuthExceptionType type;

  @override
  String toString() => 'AuthException: $type';

  @override
  List<Object?> get props => [type];
}

enum AuthExceptionType {
  tokenExpired('Token Expired'),
  invalidUsernamePassword('Invalid Username or Password'),
  accessDenied('Access Denied'),
  accountLocked('Account Locked'),
  invalidToken('Invalid Expired'),
  invalidCredentials('Invalid Credentials');

  const AuthExceptionType(this.value);
  final String value;
}
