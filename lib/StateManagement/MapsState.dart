import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttermapsapp/widgets/GoogleMaps.dart';
import 'package:fluttermapsapp/widgets/MapStack.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class MapsState with ChangeNotifier{

  Set<Polyline> _polylines = {};
  List<Marker> _markers = [];
  MapType _mapType = MapType.normal;
  Completer<GoogleMapController> _controller = Completer();

  MapType get mapType => _mapType;

  Set<Polyline> get polylines => _polylines;
  List<Marker> get markers => _markers;

  set mapType(MapType value) {
    _mapType = value;
    notifyListeners();
  }

  Completer<GoogleMapController> get controller => _controller;

  void addMarker(Marker value) {

    _markers.add(value);
    notifyListeners();
  }

  void addPolyline(Polyline value,LatLng position) {
    _polylines.add(value);
    addMarker( Marker(
      markerId: MarkerId(position.toString()),
      position: position,
      infoWindow: InfoWindow(
        title: 'This is a Title',
        snippet: 'This is a snippet',
      ),
      icon: GoogleMaps.dest
      ,
    ));
  }

  void removePolyline()
  {
    _polylines.clear();
    _markers.clear();
    notifyListeners();
  }

  void goToCurrentLocation(position) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      bearing: 192.833,
      target: LatLng(position.latitude, position.longitude),
      tilt: 59.440,
      zoom: 11.0,
    )));
    notifyListeners();
  }

  void displayRoute(PointLatLng point1,PointLatLng point2) async{
    _polylines.clear();
    _markers.clear();
    _markers.add(new Marker(
      markerId: MarkerId(point1.toString()),
      position: LatLng(point1.latitude,point1.longitude),
      infoWindow: InfoWindow(
        title: 'This is a Title',
        snippet: 'This is a snippet',
      ),
      icon: GoogleMaps.source,

    ));
    PolylinePoints polylinePoints = PolylinePoints();
    List<LatLng> polylineCoordinates = [];
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        GoogleMaps.google_api_key, point1, point2);

    if (result.points.isNotEmpty) {
      print("polyline found");
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print("no direction found");
      return;
    }

    Polyline polyline = Polyline(
        visible: true,
        polylineId: PolylineId("poly"),
        color: Colors.red,
        points: polylineCoordinates);
        addPolyline(polyline, new LatLng(point2.latitude, point2.longitude));
  }


}