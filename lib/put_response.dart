import 'dart:convert';

PutResponse putResponseFromJson(String str) => PutResponse.fromJson(json.decode(str));

String putResponseToJson(PutResponse data) => json.encode(data.toJson());

class PutResponse {
  PutResponse({
    this.name,
    this.email,
    this.hash,
  });

  String? name;
  String? email;
  String? hash;

  factory PutResponse.fromJson(Map<String, dynamic> json) => PutResponse(
    name: json["name"],
    email: json["email"],
    hash: json["hash"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "hash": hash,
  };
}
