import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_cars/utilities/constants.dart';
import 'package:flutter_cars/utilities/car.dart';

class MapWidget extends StatelessWidget {
  final Car car;

  MapWidget(this.car)
      : _kGooglePlex = CameraPosition(
            target: LatLng(double.parse(car.supplierLocation.split(',')[0]),
                double.parse(car.supplierLocation.split(',')[1])),
            zoom: 14.4746);

  final _kGooglePlex;

  Completer<GoogleMapController> _controller = Completer();

  Set<Marker> markers = Set();

  @override
  Widget build(BuildContext context) {
    //Add single marker using vendor info
    final Marker resultMarker = Marker(
      markerId: MarkerId(car.supplierCode),
      infoWindow:
          InfoWindow(title: car.supplierName, snippet: car.supplierAddress),
      position: LatLng(double.parse(car.supplierLocation.split(',')[0]),
          double.parse(car.supplierLocation.split(',')[1])),
    );

    markers.add(resultMarker);

    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 14.0, left: 15.0, bottom: 14.0),
            child: Text(
              "Supplier location",
              style: kHeadingStyle,
              textAlign: TextAlign.left,
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 200.0,
            child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              markers: markers,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              car.supplierAddress,
              style: TextStyle(
                fontSize: 14.0,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
