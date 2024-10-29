import 'dart:convert';
import 'dart:io';

import 'package:tradelinkedai/data/app_exception.dart';
import 'package:tradelinkedai/data/network/base_api_Service.dart';
import 'package:http/http.dart' as http;

class NetworkApiServices extends BaseApiService {
  @override
  Future getApiResponse(String url) async {
    dynamic responseJson;
    try {
      final response =
          await http.get(Uri.parse(url)).timeout(Duration(seconds: 30));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException("No internet connection");
    } on HttpException {
      throw FetchDataException("Couldn't find the requested resource");
    } on FormatException {
      throw FetchDataException("Bad response format");
    }
    return responseJson;
  }

  @override
  Future postApiResponse(String url, dynamic data, String authToken) async {
    dynamic responseJson;
    try {
      final response = await http
          .post(
            Uri.parse(url),
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
              HttpHeaders.authorizationHeader: "Bearer $authToken",
            },
            body: jsonEncode(data),
          )
          .timeout(Duration(seconds: 30));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException("No internet connection");
    } catch (e) {
      throw FetchDataException("Error: $e");
    }
    return responseJson;
  }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 400:
        throw BadRequestException(response.body);
      case 401:
      case 403:
        throw UnauthorisedRequestException(response.body);
      case 500:
      default:
        throw FetchDataException(
            'Error occurred while communicating with server with status code: ${response.statusCode}');
    }
  }
}
