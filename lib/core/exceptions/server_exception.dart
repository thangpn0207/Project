import 'app_exception.dart';

class ServerException extends AppException {
  ServerException({String? message})
      : super(
          message: message ?? 'Song thing wrong, please try again',
        );
}
