import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;
import 'package:tradelinkedai/core/constants/constants.dart';

class ApiRepository {
  const ApiRepository._();

  static ApiRepository get instance => const ApiRepository._();

  static Future<dynamic> sendPostRequest(
    dynamic requestData,
    String port,
    String url,
    String? authToken,
  ) async {
    String apiUrl = Constants.baseUrl+port+url;

    try {
      http.Response response = await http
          .post(
            Uri.parse(apiUrl),
            headers: authToken != null
                ? {
                    HttpHeaders.contentTypeHeader: 'application/json',
                    HttpHeaders.authorizationHeader: "Bearer $authToken"
                  }
                : {HttpHeaders.contentTypeHeader: 'application/json'},
            body: json.encode(requestData),
          )
          .timeout(const Duration(seconds: 30));

      return json.decode(response.body);
    } on TimeoutException {
      return {
        "statusCode": 500,
        "message": "Request Timeout",
      };
    } catch (error) {
      return {
        "statusCode": 400,
        "message": "No internet connection",
      };
    }
  }

  static Future<dynamic> sendGetRequest(
    String port,
    String url,
    String? authToken,
  ) async {
  String apiUrl = Constants.baseUrl+port+url;

    try {
      http.Response response = await http
          .get(
            Uri.parse(apiUrl),
            headers: authToken != null
                ? {
                    HttpHeaders.contentTypeHeader: 'application/json',
                    HttpHeaders.authorizationHeader: "Bearer $authToken"
                  }
                : {HttpHeaders.contentTypeHeader: 'application/json'},
          )
          .timeout(const Duration(seconds: 30));

      return json.decode(response.body);
    } on TimeoutException {
      return {
        "statusCode": 500,
        "message": "Request Timeout",
      };
    } catch (error) {
      return {
        "statusCode": 400,
        "message": "No internet connection",
      };
    }
  }

  static Future<dynamic> sendPatchRequest(
    dynamic requestData,
    String port,
    String url,
    String? authToken,
  ) async {
   String apiUrl = Constants.baseUrl+port+url;

    try {
      http.Response response = await http
          .patch(
            Uri.parse(apiUrl),
            headers: authToken != null
                ? {
                    HttpHeaders.contentTypeHeader: 'application/json',
                    HttpHeaders.authorizationHeader: "Bearer $authToken"
                  }
                : {HttpHeaders.contentTypeHeader: 'application/json'},
            body: json.encode(requestData),
          )
          .timeout(const Duration(seconds: 30));
      return json.decode(response.body);
    } on TimeoutException catch (_) {
      // Handle timeout
      return {
        "statusCode": 500,
        "message": "Request Timeout",
      };
    } catch (e) {
      // Handle other errors
      print(e);
      return {
        "statusCode": 400,
        "message": "No internet connection",
      };
    }
  }

  static Future<dynamic> sendPatchRequestWithoutBody(
    String port,
    String url,
    String? authToken,
  ) async {
   String apiUrl = Constants.baseUrl+port+url;

    try {
      http.Response response = await http
          .patch(
            Uri.parse(apiUrl),
            headers: authToken != null
                ? {
                    HttpHeaders.contentTypeHeader: 'application/json',
                    HttpHeaders.authorizationHeader: "Bearer $authToken"
                  }
                : {HttpHeaders.contentTypeHeader: 'application/json'},
          )
          .timeout(const Duration(seconds: 30));
      return json.decode(response.body);
    } on TimeoutException catch (_) {
      // Handle timeout
      return {
        "statusCode": 500,
        "message": "Request Timeout",
      };
    } catch (e) {
      // Handle other errors
      print(e);
      return {
        "statusCode": 400,
        "message": "No internet connection",
      };
    }
  }

  static Future<dynamic> sendPutRequest(
    dynamic requestData,
    String port,
    String url,
    String? authToken,
  ) async {
   String apiUrl = Constants.baseUrl+port+url;

    try {
      http.Response response = await http
          .put(
            Uri.parse(apiUrl),
            headers: authToken != null
                ? {
                    HttpHeaders.contentTypeHeader: 'application/json',
                    HttpHeaders.authorizationHeader: "Bearer $authToken"
                  }
                : {HttpHeaders.contentTypeHeader: 'application/json'},
            body: json.encode(requestData),
          )
          .timeout(const Duration(seconds: 30));
      return json.decode(response.body);
    } on TimeoutException catch (_) {
      // Handle timeout
      return {
        "statusCode": 500,
        "message": "Request Timeout",
      };
    } catch (e) {
      // Handle other errors
      print(e);
      return {
        "statusCode": 400,
        "message": "No internet connection",
      };
    }
  }

  static Future<dynamic> sendDeleteRequest(
    String port,
    String url,
    String? authToken,
  ) async {
   String apiUrl = Constants.baseUrl+port+url;

    try {
      http.Response response = await http
          .delete(
            Uri.parse(apiUrl),
            headers: authToken != null
                ? {
                    HttpHeaders.contentTypeHeader: 'application/json',
                    HttpHeaders.authorizationHeader: "Bearer $authToken"
                  }
                : {HttpHeaders.contentTypeHeader: 'application/json'},
          )
          .timeout(const Duration(seconds: 30));
      return json.decode(response.body);
    } on TimeoutException catch (_) {
      // Handle timeout
      return {
        "statusCode": 500,
        "message": "Request Timeout",
      };
    } catch (e) {
      // Handle other errors
      print(e);
      return {
        "statusCode": 400,
        "message": "No internet connection",
      };
    }
  }

  static Future<dynamic> sendPutRequestWithFormData(
    String name,
    String lastName,
    String email,
    dynamic avatar,
    String phoneNumber,
    String role,
    String port,
    String url,
    String? authToken,
  ) async {
    String apiUrl = Constants.baseUrl+port+url;
    // Helpers.url.apiUrl(url: port + url);

    try {
      // Create multipart request
      final request = http.MultipartRequest(
        'PUT',
        Uri.parse(apiUrl),
      );

      // Add fields to the request
      request.fields['firstname'] = name;
      request.fields['lastname'] = lastName;
      request.fields['email'] = email;
      request.fields['phone'] = phoneNumber;
      request.fields['contact_role_id'] = role;

      // Add avatar file to the request
      if (avatar != null) {
        final avatarFile = await http.MultipartFile.fromBytes(
          'avatar',
          await avatar.readAsBytes(),
          filename: path.basename(avatar.path),
          contentType: MediaType('image', 'jpeg'),
        );
        request.files.add(avatarFile);
      }

      // Add auth token if provided
      if (authToken != null) {
        request.headers[HttpHeaders.authorizationHeader] = "Bearer $authToken";
      }

      // Send the request
      final streamedResponse = await request.send();

      // Get response
      final response = await http.Response.fromStream(streamedResponse);
      print(response.body);
      // Check the status code of the response
      if (response.statusCode == 200) {
        // Success
        final responseData = json.decode(response.body);
        return responseData;
      } else {
        // Error
        return {
          "statusCode": response.statusCode,
          "message": response.body,
        };
      }
    } on TimeoutException catch (_) {
      // Handle timeout
      return {
        "statusCode": 500,
        "message": "Request Timeout",
      };
    } catch (e) {
      // Handle other errors
      print(e);
      return {
        "statusCode": 400,
        "message": "No internet connection",
      };
    }
  }

  static Future<dynamic> sendPatchRequestWithFormDataForMarkVisited(
    String id,
    dynamic likeStatus,
    double neighborhood,
    double houseLayout,
    double appliances,
    double finishes,
    double noVisibleDefects,
    double vibe,
    String personalNotes,
    List<File> customImageURLs,
    String port,
    String url,
    String? authToken,
  ) async {
   String apiUrl = Constants.baseUrl+port+url;
    print("data $id $likeStatus $neighborhood");
    try {
      // Create multipart request
      final request = http.MultipartRequest(
        'PATCH',
        Uri.parse(apiUrl),
      );

      // Add fields to the request
      request.fields['property_id'] = id;
      request.fields['liked'] = likeStatus.toString();
      request.fields['visited'] = true.toString();
      request.fields['neighborhood_rating'] = neighborhood.toString();
      request.fields['layout_rating'] = houseLayout.toString();
      request.fields['appliances_rating'] = appliances.toString();
      request.fields['finishes_rating'] = finishes.toString();
      request.fields['condition_rating'] = noVisibleDefects.toString();
      request.fields['vibe_rating'] = vibe.toString();
      request.fields['notes'] = personalNotes;

      // Add files to the request
      for (final file in customImageURLs) {
        final photo = await http.MultipartFile.fromBytes(
          'photo_urls',
          await file.readAsBytes(),
          filename: path.basename(file.path),
          contentType: MediaType('image', 'jpeg'),
        );
        request.files.add(photo);
      }

      // Add auth token if provided
      if (authToken != null) {
        request.headers[HttpHeaders.authorizationHeader] = "Bearer $authToken";
      }

      // Send the request
      final streamedResponse = await request.send();

      // Get response
      final response = await http.Response.fromStream(streamedResponse);
      print("this is reposne$response");
      // Check the status code of the response
      if (response.statusCode == 200) {
        // Success
        final responseData = json.decode(response.body);
        return responseData;
      } else {
        // Error
        return {
          "statusCode": response.statusCode,
          "message": response.body,
        };
      }
    } on TimeoutException catch (_) {
      // Handle timeout
      return {
        "statusCode": 500,
        "message": "Request Timeout",
      };
    } catch (e) {
      // Handle other errors
      print(e);
      return {
        "statusCode": 400,
        "message": "No internet connection",
      };
    }
  }

  static Future<dynamic> sendPatchRequestWithFormDataForUpdateImages(
    String id,
    List<File> customImageURLs,
    String port,
    String url,
    String? authToken,
  ) async {
    String apiUrl = Constants.baseUrl+port+url;
    try {
      // Create multipart request
      final request = http.MultipartRequest(
        'PATCH',
        Uri.parse(apiUrl),
      );
      request.fields['property_id'] = id;
      request.fields['visited'] = true.toString();
      print("this is reposne${customImageURLs}...$id");
      for (final file in customImageURLs) {
        final photo = await http.MultipartFile.fromBytes(
          'photo_urls',
          await file.readAsBytes(),
          filename: path.basename(file.path),
          contentType: MediaType('image', 'jpeg'),
        );
        request.files.add(photo);
      }

      // Add auth token if provided
      if (authToken != null) {
        request.headers[HttpHeaders.authorizationHeader] = "Bearer $authToken";
      }

      final streamedResponse = await request.send();

      final response = await http.Response.fromStream(streamedResponse);
      print("this is reposne${response.body}");

      if (response.statusCode == 200) {
        // Success
        final responseData = json.decode(response.body);
        return responseData;
      } else {
        // Error
        return {
          "statusCode": response.statusCode,
          "message": response.body,
        };
      }
    } on TimeoutException catch (_) {
      // Handle timeout
      return {
        "statusCode": 500,
        "message": "Request Timeout",
      };
    } catch (e) {
      // Handle other errors
      print(e);
      return {
        "statusCode": 400,
        "message": "No internet connection",
      };
    }
  }

  static Future<dynamic> updateProfileImage(
    dynamic profileImage,
    String port,
    String url,
    String? authToken,
  ) async {
   String apiUrl = Constants.baseUrl+port+url;
    try {
      // Create multipart request
      final request = http.MultipartRequest(
        'PATCH',
        Uri.parse(apiUrl),
      );

      // Add profile image file to the request
      if (profileImage != null) {
        final profileImageFile = await http.MultipartFile.fromBytes(
          'profile_image_url',
          await profileImage.readAsBytes(),
          filename: path.basename(profileImage.path),
          contentType: MediaType('image', 'jpeg'),
        );
        request.files.add(profileImageFile);
      }

      // Add auth token if provided
      if (authToken != null) {
        request.headers[HttpHeaders.authorizationHeader] = "Bearer $authToken";
      }

      // Send the request
      final streamedResponse = await request.send();

      // Get response
      final response = await http.Response.fromStream(streamedResponse);

      // Check the status code of the response
      if (response.statusCode == 200) {
        // Success
        final responseData = json.decode(response.body);
        return responseData;
      } else {
        // Error
        return {
          "statusCode": response.statusCode,
          "message": response.body,
        };
      }
    } on TimeoutException catch (_) {
      // Handle timeout
      return {
        "statusCode": 500,
        "message": "Request Timeout",
      };
    } catch (e) {
      // Handle other errors
      print(e);
      return {
        "statusCode": 400,
        "message": "No internet connection",
      };
    }
  }
}
