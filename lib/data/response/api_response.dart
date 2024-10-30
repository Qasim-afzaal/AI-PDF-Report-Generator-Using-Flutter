import 'status.dart';

class ApiResponse<T> {
  Status? status;
  T? data;
  String? message;
  ApiResponse(this.status, this.data, this.message);
  ApiResponse.loading() : status = Status.Loading;
  ApiResponse.success() : status = Status.Success;
  ApiResponse.error() : status = Status.Error;

  @override
  String toString() {
    return 'Status : $status \n Message : $message \n Data:$data';
  }
}
