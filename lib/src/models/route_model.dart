// To parse this JSON data, do
//
//     final routeModel = routeModelFromJson(jsonString);

import 'dart:convert';

List<RouteModel> routeModelFromJsonToList(dynamic data) => List<RouteModel>.from(data.toList().map((x) => RouteModel.fromJson(x)));

RouteModel routeModelFromJson(String str) => RouteModel.fromJson(json.decode(str));

String routeModelToJson(RouteModel data) => json.encode(data.toJson());

class RouteModel {
    RouteModel({
        this.address,
        this.coordinates,
        this.idDriver,
        this.hour,
        this.idCar,
        this.schedule,
        this.status,
    });

    String address;
    Locality coordinates;
    String idDriver;
    String hour;
    String idCar;
    Schedule schedule;
    String status;

    factory RouteModel.fromJson(Map<dynamic, dynamic> json) => RouteModel(
        address: json["address"] == null ? null : json["address"],
        coordinates: json["coordinates"] == null ? null : Locality.fromJson(json["coordinates"]),
        idDriver: json["id_driver"] == null ? null : json["id_driver"],
        hour: json["hour"] == null ? null : json["hour"],
        idCar: json["id_car"] == null ? null : json["id_car"],
        schedule: json["schedule"] == null ? null : Schedule.fromJson(json["schedule"]),
        status: json["status"] == null ? null : json["status"],
    );

    Map<String, dynamic> toJson() => {
        "address": address == null ? null : address,
        "coordinates": coordinates == null ? null : coordinates.toJson(),
        "id_driver": idDriver == null ? null : idDriver,
        "hour": hour == null ? null : hour,
        "id_car": idCar == null ? null : idCar,
        "schedule": schedule == null ? null : schedule.toJson(),
        "status": status == null ? null : status,
    };
}

class Locality {
    Locality({
        this.lat,
        this.lng,
    });

    double lat;
    double lng;

    factory Locality.fromJson(Map<dynamic, dynamic> json) => Locality(
        lat: json["lat"] == null ? null : json["lat"].toDouble(),
        lng: json["lng"] == null ? null : json["lng"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "lat": lat == null ? null : lat,
        "lng": lng == null ? null : lng,
    };
}

class Schedule {
    Schedule({
        this.friday,
        this.monday,
        this.saturday,
        this.sunday,
        this.thursday,
        this.tuesday,
        this.wednesday,
    });

    bool friday;
    bool monday;
    bool saturday;
    bool sunday;
    bool thursday;
    bool tuesday;
    bool wednesday;

    factory Schedule.fromJson(Map<dynamic, dynamic> json) => Schedule(
        friday: json["friday"] == null ? null : json["friday"],
        monday: json["monday"] == null ? null : json["monday"],
        saturday: json["saturday"] == null ? null : json["saturday"],
        sunday: json["sunday"] == null ? null : json["sunday"],
        thursday: json["thursday"] == null ? null : json["thursday"],
        tuesday: json["tuesday"] == null ? null : json["tuesday"],
        wednesday: json["wednesday"] == null ? null : json["wednesday"],
    );

    Map<String, dynamic> toJson() => {
        "friday": friday == null ? null : friday,
        "monday": monday == null ? null : monday,
        "saturday": saturday == null ? null : saturday,
        "sunday": sunday == null ? null : sunday,
        "thursday": thursday == null ? null : thursday,
        "tuesday": tuesday == null ? null : tuesday,
        "wednesday": wednesday == null ? null : wednesday,
    };
}