

import 'app_exception.dart';

class NetworkException extends AppException {
  NetworkException({String? message})
      : super(message: message ?? 'Vui lòng kiểm tra lại kết nối mạng');
}
