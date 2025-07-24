import 'package:dio/dio.dart';
import 'package:flx_core_flutter/flx_core_flutter.dart';

class RequestHeader {
  static const String authorization = 'Authorization';
}

abstract class Api {
  static final String urlApi = flavorConfig.apiUrl;
  static const String urlAuth = 'https://auth-api.flexurio.com';

  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: urlApi,
      connectTimeout: const Duration(minutes: 3),
      receiveTimeout: const Duration(minutes: 3),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );
}

abstract class Repository {
  Repository({
    Dio? dio,
    required this.onUnauthorized,
  }) : dio = dio ?? Api.dio;

  final Dio dio;
  final void Function() onUnauthorized;

  Options bearer(String accessToken) {
    return Options(
      headers: {'Authorization': 'Bearer $accessToken'},
    );
  }

  Exception checkErrorApi(Object error) {
    if (error is DioException) {
      final statusCode = error.response?.statusCode;

      if (statusCode == 401) {
        onUnauthorized();
        return ApiException.fromType(ExceptionType.tokenExpired);
      }

      if (error.message?.contains('SocketException: Failed host lookup') ??
          false) {
        return error;
      }

      if (statusCode == 400 || statusCode == 500) {
        final data = error.response?.data as Map<String, dynamic>?;
        final errorMessage = data?['message']?.toString();

        if (errorMessage != null && errorMessage.isNotEmpty) {
          return ApiException(errorMessage);
        }
      }
    }

    return Exception('Error calling API: $error');
  }
}

// class BaseApi {
//   static const timeout = 60;
//   final baseUrl = 'https://api.your-domain.com/';
//   final authUrl = 'https://auth.your-domain.com/';
//   final dio = Dio();
//   Future<Map<String, dynamic>> request(
//     String url, {
//     required Map<String, String> headers,
//     dynamic body,
//     String method = 'GET',
//   }) async {
//     late Response<dynamic> response;
//     final options = Options(headers: headers);
//     const timeLimit = Duration(seconds: timeout);
//     final formData = jsonEncode(body);
//     try {
//       switch (method) {
//         case 'GET':
//           response = await dio
//               .get<dynamic>(url, options: options)
//               .timeout(timeLimit, onTimeout: _onTimeout);
//         case 'POST':
//           response = await dio
//               .post<dynamic>(url, data: formData, options: options)
//               .timeout(timeLimit, onTimeout: _onTimeout);
//         case 'DELETE':
//           response = await dio
//               .delete<dynamic>(
//                 url,
//                 data: formData,
//                 options: options,
//               )
//               .timeout(timeLimit, onTimeout: _onTimeout);
//         case 'PATCH':
//           response = await dio
//               .patch<dynamic>(
//                 url,
//                 data: formData,
//                 options: options,
//               )
//               .timeout(timeLimit, onTimeout: _onTimeout);
//         case 'PUT':
//           response = await dio
//               .put<dynamic>(url, data: formData, options: options)
//               .timeout(timeLimit, onTimeout: _onTimeout);
//         default:
//       }
//       try {
//         final result = response.data is String
//             ? json.decode(response.data as String) as Map<String, dynamic>
//             : response.data as Map<String, dynamic>;
//         return result;
//       } catch (e) {
//         return {};
//       }
//     } on DioException catch (e) {
//       if (e.response == null) {
//         throw PlatformException(
//           code: errorConnectionRefused,
//           message: e.message,
//         );
//       }
//       final response = e.response?.data as Map<String, dynamic>?;
//       var message = '';
//       if (response?.containsKey('message') ?? false) {
//         message = response!['message'] as String;
//       }
//       if (e.response?.statusCode == 401) {
//         throw PlatformException(code: errorUnauthorized, message: message);
//       } else {
//         throw PlatformException(code: errorInternalServer, message: message);
//       }
//     }
//   }
//
//   Future<Response<Map<String, dynamic>>> _onTimeout() {
//     throw PlatformException(code: 'TIMEOUT', message: 'Timeout during request');
//   }
// }
