import 'package:flutter/material.dart';
import 'package:flutter_cars/utilities/car.dart';
import 'package:flutter_cars/utilities/driver.dart';
import 'package:flutter_cars/utilities/constants.dart';
import 'package:flutter_cars/widgets/car_block.dart';
import 'package:flutter_cars/utilities/global_data.dart';
import 'package:flutter_cars/services/ota.dart';
import 'package:flutter_cars/screens/confirmation_screen.dart';
import 'package:flutter_cars/widgets/custom_input_widget.dart';
import 'package:progress_dialog/progress_dialog.dart';

class DriverDetailsScreen extends StatefulWidget {
  DriverDetailsScreen({this.car});
  final Car car;

  @override
  _DriverDetailsScreenState createState() => _DriverDetailsScreenState();
}

class _DriverDetailsScreenState extends State<DriverDetailsScreen> {
  //Form controllers
  final _formKey = GlobalKey<FormState>();
  final fnameController = TextEditingController();
  final lnameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  var _scaffoldKey;
  var pr = null;

  //Function to pass form data to CT reservation API
  makeReservation(driver) async {
    //Show a progress dialog
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);

    pr.style(
      message: 'Reserving you car...',
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(),
      insetAnimCurve: Curves.easeInOut,
    );

    await pr.show();

    OTA ota = new OTA();
    var carData = await ota.makeCarReservation(widget.car, driver);

    //error with booking
    if (carData == null) {
      //hide progress dialog and show error message within SnackBar
      pr.hide().then((isHidden) {
        final snackBar = SnackBar(
            content: Text(
                'There was an error reserving this vehicle, please try again later or select another.'));
        _scaffoldKey.currentState.showSnackBar(snackBar);
      });
    } else {
      //Add reservation info to the car object. This info can be used for the e-voucher and to cancel the booking later.
      widget.car.reservationNumber =
          carData['VehReservation']['VehSegmentCore']['ConfID']['@ID'];
      widget.car.customerEmail = driver.email;
      widget.car.customerFName = driver.fName;
      widget.car.customerLName = driver.lName;
      widget.car.pickupDatetime = carData['VehReservation']['VehSegmentCore']
          ['VehRentalCore']['@PickUpDateTime'];
      widget.car.returnDatetime = carData['VehReservation']['VehSegmentCore']
          ['VehRentalCore']['@ReturnDateTime'];

      //save to db, car object needs to be converted to map
      int res = await dbClient.insert("Cars", widget.car.toMap());

      //Dismiss progress dialog
      pr.hide().then((isHidden) {
        //Move to confirmation screen
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ConfirmationScreen(
            car: widget.car,
            referrer: "DriverDetailsScreen",
          );
        }));
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _detailsFormKey = GlobalKey<FormState>();
    _scaffoldKey = GlobalKey<ScaffoldState>();
    final ProgressDialog pr = ProgressDialog(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Driver Details'),
      ),
      body: ListView(
        padding: EdgeInsets.all(20.0),
        children: [
          Form(
              key: _formKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Flexible(
                          child: CustomInputWidget(
                            "First Name",
                            fnameController,
                            TextInputType.text,
                            true,
                          ),
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        Flexible(
                          child: CustomInputWidget(
                            "Last Name",
                            lnameController,
                            TextInputType.text,
                            true,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: kInputSpacing,
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: CustomInputWidget(
                            "Email Address",
                            emailController,
                            TextInputType.emailAddress,
                            false,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: kInputSpacing,
                    ),
                    Row(
                      children: <Widget>[
                        Flexible(
                          child: CustomInputWidget(
                            "Phone Number",
                            phoneController,
                            TextInputType.phone,
                            false,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: kInputSpacing,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: FlatButton(
                        color: Colors.blue,
                        textColor: Colors.white,
                        padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        onPressed: () {
                          // Validate returns true if the form is valid, otherwise false.
                          if (_formKey.currentState.validate()) {
                            //Create a driver object to use with vehicle reservation
                            var driver = Driver(
                              fName: fnameController.text,
                              lName: lnameController.text,
                              email: emailController.text,
                              phone: phoneController.text,
                              residency: 'US',
                              age: 30,
                            );
                            makeReservation(driver);
                          } //end if
                        },
                        child: Text(
                          'Book now!',
                          style: kButtonTextStyle,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: kInputSpacing,
                    ),
                    CarBlock(widget.car),
                  ]))
        ],
      ),
    );
  }
}
