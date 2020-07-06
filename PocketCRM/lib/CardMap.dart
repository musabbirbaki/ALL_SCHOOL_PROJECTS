import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';

class CardMap extends StatelessWidget {
  CardMap(this.context, this.address);

  final BuildContext context;
  final String address;
  var _geolocator = Geolocator();

  Future<LatLng> reverseLookUp(String addr) async {
    List<Placemark> places = await _geolocator.placemarkFromAddress(addr);
    print('Forward geocoding results:');
    if (places.length > 1) {
      print('There are more than one address that matches this address');
      return null;
    }

    print(
        'lat:${places[0].position.latitude}  , lng:${places[0].position.longitude}');

    return LatLng(places[0].position.latitude, places[0].position.longitude);
  }

  Widget viewMap(LatLng point) {
    return SizedBox(
        width: MediaQuery.of(context).size.width / 3.5,
        height: MediaQuery.of(context).size.height / 3.5,
        child: Container(
          child: FlutterMap(
            options: MapOptions(center: point),
            layers: [
              TileLayerOptions(
                urlTemplate: "https://api.tiles.mapbox.com/v4/"
                    "{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
                additionalOptions: {
                  'accessToken':
                      'pk.eyJ1IjoieWFzaDEwOTQiLCJhIjoiY2szaHRqY2h4MDE4MjNkcm0wYjh0MmFvdyJ9.k7WO1yBJ4AskbRBRX2e06w',
                  'id': 'mapbox.streets',
                },
              ),
              MarkerLayerOptions(
                markers: [
                  Marker(
                      width: 25.0,
                      height: 25.0,
                      point: point,
                      builder: (context) => Icon(Icons.place))
                ],
              )
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: reverseLookUp(address),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          print(snapshot.data);
          var cordinates = snapshot.data;
          return Padding(
            key: ValueKey(address),
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Card(
              child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child:
                      // Row(
                      //   children: <Widget>[
                      //     Expanded(
                      //         child: Text(
                      //       address,
                      //       textAlign: TextAlign.center,
                      //     )),
                      viewMap(cordinates)
                  //   ],
                  // ),
                  ),
            ),
          );
        }
        return LinearProgressIndicator();
      },
    );
  }
}
