import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttermapsapp/Database/Database.dart';
import 'package:fluttermapsapp/Models/RouteModel.dart';
import 'package:fluttermapsapp/StateManagement/MapsState.dart';
import 'package:fluttermapsapp/StateManagement/SavedRoutesSheetState.dart';
import 'package:fluttermapsapp/widgets/RouteListItem.dart';
import 'package:provider/provider.dart';

class SavedRoutesDraggableSheet extends StatelessWidget {
  MapsState _mapsState;

  @override
  Widget build(BuildContext context) {
    _mapsState = Provider.of<MapsState>(context);

    return Consumer<MapsState>(
      builder: (context, mapstate, _) =>
          FutureBuilder(
            future: DBProvider.db.getAllRoutes(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.data.length > 0)
                return DraggableScrollableSheet(
                  initialChildSize: 0.1,
                  minChildSize: 0.1,
                  maxChildSize: 0.5,
                  builder: (context, scrollController) {
                    return Container(
                      padding: EdgeInsets.all(10),
                      decoration: new BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: new BorderRadius.only(
                          topLeft: const Radius.circular(40.0),
                          topRight: const Radius.circular(40.0),
                        ),
                      ),
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.95,
                      child: ListView.builder(
                        itemCount: snapshot.data.length,
                        controller: scrollController,
                        itemBuilder: (context, index) =>
                            GestureDetector(child: RouteListItem(snapshot
                                .data[index]), onTap:(){
                              RouteModel route =snapshot.data[index];
                              PointLatLng point1  = new PointLatLng(route.source_lat, route.source_long);
                              PointLatLng point2 = new PointLatLng(route.dest_lat, route.dest_long);
                              _mapsState.displayRoute(point1,point2);
                            },),
                      ),
                    );
                  },
                );
              else
                return Container();
            },
          ),
    );
  }
}
