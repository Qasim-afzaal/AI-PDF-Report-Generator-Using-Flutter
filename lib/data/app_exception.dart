class AppException implements Exception {
  final _message;
  final _prefix;

  AppException([this._message, this._prefix]);

  String toString() {
    return '$_prefix$_message';
  }
}

class FetchDataException extends AppException{
  FetchDataException([String? message]) : super(message,'Error During Communication');
}

class BadRequestException extends AppException{
  BadRequestException([String? message]) : super(message,'Invalid Request');
}
class UnauthorisedRequestException extends AppException{
  UnauthorisedRequestException([String? message]) : super(message,'UnAuthorised Request');
}