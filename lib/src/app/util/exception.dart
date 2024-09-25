class ApiException implements Exception {
  ApiException.fromType(ExceptionType type) : message = type.value;
  ApiException(this.message);
  final String message;

  @override
  String toString() => 'ApiException: $message';
}

enum ExceptionType {
  tokenExpired('Token Expired'),
  invalidUsernamePassword('Invalid Username or Password'),
  accessDenied('Access Denied'),
  accountLocked('Account Locked'),
  invalidToken('Invalid Expired'),
  invalidCredentials('Invalid Credentials'),
  offline('Offline');

  const ExceptionType(this.value);
  final String value;
}
