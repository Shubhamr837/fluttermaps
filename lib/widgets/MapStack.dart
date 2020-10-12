import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttermapsapp/StateManagement/MapsState.dart';
import 'package:fluttermapsapp/widgets/GoogleMaps.dart';


import 'package:provider/provider.dart';

class MapStack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        ChangeNotifierProvider(
          builder: (context) => MapsState(),
          child: GoogleMaps(context),
        ),

      ],
    );
  }
}
