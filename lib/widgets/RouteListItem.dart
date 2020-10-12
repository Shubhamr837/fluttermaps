import 'package:flutter/material.dart';
import '../Models/RouteModel.dart';

class RouteListItem extends StatelessWidget {
  final RouteModel route;

  RouteListItem(this.route);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: MediaQuery.of(context).size.height*0.17,
      width: MediaQuery.of(context).size.width * 0.6,
      child: Card(
        color: Colors.blueAccent,
        margin: EdgeInsets.all(6),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.6,
          child: Row(
            children: [Image.asset("assets/routeIcon.png"),Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  child: Text(
                    route.title,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(8),
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Text(
                    route.description,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                        fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 4,
                  ),
                )
              ],
            ),
          ],),
        ),
      ),
    );
  }
}
