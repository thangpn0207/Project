import 'app_exception.dart';

class NetworkException extends AppException {
  NetworkException({String? message})
      : super(message: message ?? 'Please check your network');
}
