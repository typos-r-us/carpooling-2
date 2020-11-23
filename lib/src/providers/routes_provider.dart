import 'package:flutter/material.dart';
import 'package:flutter_carpooling/src/utils/utils.dart';
import 'package:flutter_carpooling/src/prefs/user_prefs.dart';
import 'package:flutter_carpooling/src/models/user_model.dart';
import 'package:flutter_carpooling/src/models/route_model.dart';
import 'package:flutter_carpooling/src/services/route_service.dart';

class RoutesProvider with ChangeNotifier {

  final prefs = UserPreferences(); 

  List<RouteModel> _myGroupRoutes = List<RouteModel>();
  List<RouteModel> _myPaxRoutes = List<RouteModel>();
  List<RouteModel> _myDriverRoutes = List<RouteModel>();
  double _ratingDriver = 0;
  bool _loading = true;

  RoutesProvider() {
    this.readGroupRoute();
  }

  List<RouteModel> get myGroupRoutes => this._myGroupRoutes;
  List<RouteModel> get myPaxRoutes => this._myPaxRoutes;
  List<RouteModel> get myDriverRoutes => this._myDriverRoutes;
  double get ratingDriver => this._ratingDriver;
  bool get loading => this._loading;

  set ratingDriver(double rate) {
    this._ratingDriver = rate;
    notifyListeners();
  }

  set addMyPaxRoutes(RouteModel route) {
    this.myPaxRoutes.insert(0, route);
    notifyListeners();
  }

  set removeMyPaxRoutes(RouteModel route) {
    this.myPaxRoutes.removeWhere((myRoute) => myRoute.id == route.id);
    notifyListeners();
  }

  set addMyDriverRoutes(RouteModel route) {
    this._myGroupRoutes.add(route);
    this._myDriverRoutes.insert(0, route);
    notifyListeners();
  }

  set editMyDriverRoutes(RouteModel route) {
    this._myGroupRoutes = this._myGroupRoutes.map((myRoute) => (myRoute.id == route.id) ? route : myRoute).toList();
    this._myDriverRoutes.removeWhere((myRoute) => myRoute.id == route.id);
    this._myDriverRoutes.insert(0, route);
    notifyListeners();
  }

  set removeMyDriverRoutes(RouteModel route) {
    this._myGroupRoutes.removeWhere((myRoute) => myRoute.id == route.id);
    this._myDriverRoutes.removeWhere((myRoute) => myRoute.id == route.id);
    notifyListeners();
  }

  void orderMyPaxRoutes() {
    this._myPaxRoutes.clear();
    for (RouteModel route in this._myGroupRoutes) {
      if (prefs.lat != "") {
        route.distance = getKilometers(double.tryParse(prefs.lat), double.tryParse(prefs.lng), route.coordinates.lat, route.coordinates.lng);
      }
      if (route.users != null) {
        for (UserModel user in route.users) {
          if (user.id == prefs.uid) {
            this._myPaxRoutes.add(route);
            break;
          }
        }
      }
    }
    // ordena a la ruta mas reciente registrada por el pasajero
    this._myPaxRoutes.sort((b, a) => a.idUsers[prefs.uid].compareTo(b.idUsers[prefs.uid]));
    if (prefs.lat != "") {
      // ordena ascedentemente a la ruta mas corta de la ruta usual
      this._myGroupRoutes.sort((a, b) => a.distance.compareTo(b.distance));
    }
    notifyListeners();
  }
  
  void orderMyDriverRoutes() {
    this._myDriverRoutes = this._myGroupRoutes.where((route) => (route.idDriver == prefs.uid)).toList();
    if (this._myDriverRoutes.length > 0) {
      // ordena a la ruta mas reciente creada por el conductor
      this._myDriverRoutes.sort((b, a) => a.date.compareTo(b.date));
    }
    notifyListeners();
  }


  Future<void> readGroupRoute() async {
    this._loading = true;
    this._myPaxRoutes.clear();
    this._myGroupRoutes.clear();
    this._myDriverRoutes.clear();
    final routeService = RouteService();
    final result = await routeService.readGroupRoute();
    if (result["ok"]) {
      this._myGroupRoutes = result["value"];
      if (prefs.mode == "PASAJERO") {
        this.orderMyPaxRoutes();
      } else {
        this.orderMyDriverRoutes();
      }
      this._loading = false;
    }
    notifyListeners();
  }

}