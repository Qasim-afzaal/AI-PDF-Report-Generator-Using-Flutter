// To parse this JSON data, do
//
//     final userDataModel = userDataModelFromJson(jsonString);

import 'dart:convert';

UserDataModel userDataModelFromJson(String str) => UserDataModel.fromJson(json.decode(str));

String userDataModelToJson(UserDataModel data) => json.encode(data.toJson());

class UserDataModel {
    bool success;
    String message;
    Data data;

    UserDataModel({
        required this.success,
        required this.message,
        required this.data,
    });

    factory UserDataModel.fromJson(Map<String, dynamic> json) => UserDataModel(
        success: json["success"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.toJson(),
    };
}

class Data {
    String? id;
    bool? isActive;
    String? name;
    String? email;
    String? password;
    String? authProvider;
    String? profileImageUrl;
    DateTime? createdAt;
    DateTime? updatedAt;
    String? accessToken;

    Data({
        required this.id,
        required this.isActive,
        required this.name,
        required this.email,
        required this.password,
        required this.authProvider,
        required this.profileImageUrl,
        required this.createdAt,
        required this.updatedAt,
        required this.accessToken,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        isActive: json["is_active"],
        name: json["name"],
        email: json["email"],
        password: json["password"],
        authProvider: json["auth_provider"],
        profileImageUrl: json["profile_image_url"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        accessToken: json["access_token"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "is_active": isActive,
        "name": name,
        "email": email,
        "password": password,
        "auth_provider": authProvider,
        "profile_image_url": profileImageUrl,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "access_token": accessToken,
    };
}
