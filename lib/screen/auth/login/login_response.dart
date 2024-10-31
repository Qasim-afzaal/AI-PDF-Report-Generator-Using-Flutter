class LoginResponse {
  bool? success;
  String? message;
  Data? data;

  LoginResponse({this.success, this.message, this.data});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? id;
  String? name;
  String? email;
  String? authProvider;
  String? gender;
  String? age;
  String? profileImageUrl;
  String? createdAt;
  String? updatedAt;
  String? accessToken;

  Data({this.id, this.name, this.email, this.authProvider, this.gender, this.age, this.profileImageUrl, this.createdAt, this.updatedAt, this.accessToken});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    authProvider = json['auth_provider'];
    gender = json['gender'];
    age = json['age'];
    profileImageUrl = json['profile_image_url'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    accessToken = json['access_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['auth_provider'] = authProvider;
    data['gender'] = gender;
    data['age'] = age;
    data['profile_image_url'] = profileImageUrl;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['access_token'] = accessToken;
    return data;
  }
}
