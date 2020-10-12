import 'dart:convert';

RouteModel routeFromJson(String str) {
  final jsonData = json.decode(str);
  return RouteModel.fromMap(jsonData);
}

String routeToJson(RouteModel data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class RouteModel {
  int id;
  String title;
  String description;
  double source_lat;
  double source_long;
  double dest_long;
  double dest_lat;

  RouteModel({
    this.id,
    this.title,
    this.description,
    this.source_lat,
    this.source_long,
    this.dest_lat,
    this.dest_long
  });

  factory RouteModel.fromMap(Map<String, dynamic> json) => new RouteModel(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    source_lat: json["source_lat"] ,
    source_long: json["source_long"],
    dest_lat: json["dest_lat"],
    dest_long: json["dest_long"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "title": title,
    "description": description,
    "source_lat": source_lat,
    "source_long": source_long,
    "dest_lat":dest_lat,
    "dest_long":dest_long,
  };
}