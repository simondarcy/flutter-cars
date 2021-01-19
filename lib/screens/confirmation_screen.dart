import 'package:flutter/material.dart';
import 'package:flutter_cars/utilities/constants.dart';
import 'package:flutter_cars/utilities/car.dart';
import 'package:flutter_cars/services/ota.dart';
import 'package:flutter_cars/utilities/global_data.dart';
import 'package:flutter_cars/widgets/car_block.dart';
import 'package:flutter_cars/widgets/pickup_info.dart';
import 'package:flutter_cars/widgets/map_widget.dart';
import 'package:flutter_cars/screens/voucher_screen.dart';
import 'package:flutter_cars/screens/home_screen.dart';
import 'package:progress_dialog/progress_dialog.dart';

class ConfirmationScreen extends StatefulWidget {
  ConfirmationScreen({this.car, this.referrer});
  final Car car;
  final String referrer;

  @override
  _ConfirmationScreenState createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  var pr = null;

  @override
  void initState() {
    super.initState();
  }

  cancelReservation() async {
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);

    pr.style(
      message: 'Cancelling reservation...',
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(),
      insetAnimCurve: Curves.easeInOut,
    );

    await pr.show();

    OTA ota = new OTA();
    var carData = await ota.cancelReservation(widget.car);

    pr.hide().then((isHidden) {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: (carData.containsKey("Errors"))
                ? Text('Error!')
                : Text('Reservation cancelled.'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  (carData.containsKey("Errors"))
                      ? Text("${carData['Errors']['Error']['@ShortText']}.")
                      : Text("Thanks for using our app."),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('OK!'),
                onPressed: () async {
                  //If an error was returned, just close alert
                  if (carData.containsKey("Errors")) {
                    Navigator.of(context).pop();
                  } else {
                    //If all ok, delete from DB and return to home/search screen
                    final result = await dbClient.rawDelete(
                        "DELETE FROM Cars WHERE reservationNumber = ?",
                        ["${widget.car.reservationNumber}"]);
                    //Navigator.of(context).pop();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return HomeScreen();
                    }));
                  } //end if/else
                },
              ),
            ],
          );
        },
      ); //End return dialog
    }); //end hide loader
  } //end cancel reservation function

  Widget getBackButton() {
    if (widget.referrer == "DriverDetailsScreen") {
      return IconButton(
        icon: Icon(Icons.home),
        onPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) {
              return HomeScreen(
                idx: 1,
              );
            }),
            (route) => false,
          );
        },
      );
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Confirmed'),
        leading: getBackButton(),
      ),
      body: SafeArea(
        child: ListView(
          padding: new EdgeInsets.all(8.0),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(kCardMargin),
                child: Column(
                  children: [
                    Text('Booking Reference'),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      '${widget.car.reservationNumber}',
                      style: kHeadingStyle,
                    ),
                  ],
                ),
              ),
            ),
            CarBlock(widget.car),
            PickupInfoWidget(widget.car),
            MapWidget(widget.car),
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
                    return VoucherScreen(
                      reservationNumber: widget.car.reservationNumber,
                      email: widget.car.customerEmail,
                    );
                  }));
                },
                child: Text(
                  'View eVoucher',
                  style: kButtonTextStyle,
                ),
              ),
            ),
            FlatButton(
              onPressed: () {
                cancelReservation();
              },
              child: Text("Cancel Reservation"),
            )
          ],
        ),
      ),
    );
  }
}
