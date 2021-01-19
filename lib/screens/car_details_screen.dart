import 'package:flutter/material.dart';
import 'package:flutter_cars/utilities/car.dart';
import 'package:flutter_cars/widgets/car_block.dart';
import 'package:flutter_cars/widgets/map_widget.dart';
import 'package:flutter_cars/widgets/offers_widget.dart';
import 'package:flutter_cars/widgets/pickup_info.dart';
import 'package:flutter_cars/screens/driver_details_screen.dart';
import 'package:flutter_cars/screens/terms_screen.dart';
import 'package:flutter_cars/utilities/constants.dart';

class CarDetailsScreen extends StatefulWidget {
  CarDetailsScreen({this.car});
  final Car car;

  @override
  _CarDetailsScreenState createState() => _CarDetailsScreenState();
}

class _CarDetailsScreenState extends State<CarDetailsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Car Details'),
      ),
      body: SafeArea(
        child: ListView(
          padding: new EdgeInsets.all(8.0),
          children: [
            CarBlock(widget.car),
            OffersWidget(widget.car.offers),
            PickupInfoWidget(widget.car),
            MapWidget(widget.car),
            Divider(),
            FlatButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return TermsScreen(car: widget.car);
                }));
              },
              child: ListTile(
                title: Text("Rental terms"),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
            ),
            Divider(),
            SizedBox(
              height: kInputSpacing,
            ),
            Padding(
              padding: kFixedButtonPadding,
              child: FlatButton(
                color: Colors.blue,
                textColor: Colors.white,
                padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return DriverDetailsScreen(car: widget.car);
                  }));
                },
                child: Text(
                  'Book now, pay later!',
                  style: kButtonTextStyle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
