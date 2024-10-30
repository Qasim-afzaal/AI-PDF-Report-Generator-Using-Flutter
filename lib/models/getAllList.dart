// To parse this JSON data, do
//
//     final getAllList = getAllListFromJson(jsonString);

import 'dart:convert';

GetAllList getAllListFromJson(String str) => GetAllList.fromJson(json.decode(str));

String getAllListToJson(GetAllList data) => json.encode(data.toJson());

class GetAllList {
    bool success;
    String message;
    List<Datum> data;

    GetAllList({
        required this.success,
        required this.message,
        required this.data,
    });

    factory GetAllList.fromJson(Map<String, dynamic> json) => GetAllList(
        success: json["success"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    String fileUrl;
    String name;

    Datum({
        required this.fileUrl,
        required this.name,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        fileUrl: json["file_url"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "file_url": fileUrl,
        "name": name,
    };
}
