import 'package:flutter/material.dart';
import 'package:fluttermapsapp/widgets/NewRoute.dart';
import '../StateManagement/MapsState.dart';
import 'package:provider/provider.dart';
import 'package:fluttermapsapp/Database/Database.dart';
import 'package:fluttermapsapp/Models/RouteModel.dart';
import 'package:fluttermapsapp/StateManagement/MapsState.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttermapsapp/widgets/SavedRoutesDraggableSheet.dart';

class GoogleMaps extends StatelessWidget {
  PermissionStatus permission;
  static String google_api_key = "AIzaSyD2MRJEkAHpBR2P2ZGU-bAGGvpliL4Ao34";

  static const LatLng _center = const LatLng(00.000000, 00.000000);

  LatLng _lastMapPosition = _center;

  bool _isSourceSelected = false;
  final BuildContext mContext;

  GoogleMaps(this.mContext);

  MapsState _mapController;

  List<PointLatLng> polyLatLng = [];

  static BitmapDescriptor _source, _dest;

  static BitmapDescriptor get source => _source;

  static get dest => _dest;

  _loadIcons() async {
    _source = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(24, 24)), 'assets/driving_pin.png');
    _dest = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(24, 24)),
        'assets/destination_map_marker.png');
  }

  //

  static final CameraPosition _camerapos = CameraPosition(
    bearing: 190.00,
    target: LatLng(00.0000, 00.0000),
    tilt: 60.000,
    zoom: 12.0,
  );

  _gotoCurrentLocation() {
    Future<Position> position =
        getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    position.then((position) {
      _mapController.goToCurrentLocation(position);
    });
  }

  _requestPermissions() async {
    await LocationPermissions().requestPermissions();
    permission = await LocationPermissions().checkPermissionStatus();
    if (permission == PermissionStatus.granted)
      _mapController.onPermissionGranted();
  }

  _onMapCreated(GoogleMapController controller) {
    _requestPermissions();
    _mapController.controller.complete(controller);
  }

  _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  _onMapTypeButtonPressed() {
    _mapController.mapType = _mapController.mapType == MapType.normal
        ? MapType.satellite
        : MapType.normal;
  }

  _onAddMarkerButtonPressed() {
    if (!_isSourceSelected) {
      print("called");
      _mapController.polylines.clear();
      _mapController.markers.clear();
      polyLatLng.clear();
    }
    polyLatLng.add(
        PointLatLng(_lastMapPosition.latitude, _lastMapPosition.longitude));

    if (_mapController.markers.length == 2) {
      _mapController.markers.removeAt(0);
      polyLatLng.removeAt(0);
    }

    _isSourceSelected
        ? _setPolylines()
        : _mapController.addMarker(
            Marker(
              markerId: MarkerId(_lastMapPosition.toString()),
              position: _lastMapPosition,
              infoWindow: InfoWindow(
                title: 'This is a Title',
                snippet: 'This is a snippet',
              ),
              icon: _isSourceSelected ? _dest : _source,
            ),
          );
    _isSourceSelected = _isSourceSelected ? false : true;
  }

  void _showModalBottom() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: mContext,
      builder: (cntxt) {
        return GestureDetector(
          onTap: () {},
          child: NewRoute(_saveRoute),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  _saveRoute(title, description) {
    if (_mapController.markers.length == 2) {
      DBProvider.db.newRoute(new RouteModel(
        id: 0,
        title: title,
        description: description,
        source_lat: _mapController.markers[0].position.latitude,
        source_long: _mapController.markers[0].position.longitude,
        dest_lat: _mapController.markers[1].position.latitude,
        dest_long: _mapController.markers[1].position.longitude,
      ));
      _mapController.removePolylineAndMarkers();
    } else {
      final SnackBar snackBar = SnackBar(
        content: Text("Please Select a route"),
      );
      Scaffold.of(mContext).showSnackBar(snackBar);
    }
  }

  _setPolylines() async {
    PolylinePoints polylinePoints = PolylinePoints();
    List<LatLng> polylineCoordinates = [];
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        google_api_key, polyLatLng.first, polyLatLng.last);
    print(polyLatLng);

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
    _mapController.addPolylineAndDestinationMarker(
        polyline,
        new Marker(
          markerId: MarkerId(_lastMapPosition.toString()),
          position: _lastMapPosition,
          infoWindow: InfoWindow(
            title: 'This is a Title',
            snippet: 'This is a snippet',
          ),
          icon: GoogleMaps.dest,
        ));
  }

  Widget button(Function function, IconData icon) {
    return FloatingActionButton(
      onPressed: function,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      backgroundColor: Colors.blue,
      child: Icon(
        icon,
        size: 36.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _mapController = Provider.of<MapsState>(context);
    _loadIcons();

    return Stack(alignment: Alignment.bottomCenter, children: [
      Consumer<MapsState>(
        builder: (context, mapstate, _) => GoogleMap(
          myLocationEnabled: mapstate.currentLocation,
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 11.0,
          ),
          mapType: mapstate.mapType,
          markers: mapstate.markers.toSet(),
          polylines: mapstate.polylines,
          onCameraMove: _onCameraMove,
        ),
      ),
      Padding(
        padding: EdgeInsets.all(16.0),
        child: Align(
          alignment: Alignment.topRight,
          child: Column(
            children: <Widget>[
              button(_onMapTypeButtonPressed, Icons.map),
              SizedBox(
                height: 16.0,
              ),
              button(_onAddMarkerButtonPressed, Icons.add_location),
              SizedBox(
                height: 16.0,
              ),
              button(_gotoCurrentLocation, Icons.location_searching),
              SizedBox(
                height: 16.0,
              ),
              Consumer<MapsState>(
                  builder: (context, mapState, _) {
                    if(mapState.markers.length==2)
                     return button(_showModalBottom, Icons.save);
                    else
                      return Container();
            }),
            ],
          ),
        ),
      ),
      Container(
          width: MediaQuery.of(context).size.width * 0.9,
          child: SavedRoutesDraggableSheet())
    ]);
  }
}
