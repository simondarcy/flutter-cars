import 'package:flutter/material.dart';
import 'package:flutter_cars/utilities/constants.dart';
import 'package:flutter_cars/utilities/global_data.dart';
import 'package:flutter_cars/utilities/car.dart';
import 'package:intl/intl.dart';

class PickupInfoWidget extends StatelessWidget {
  PickupInfoWidget(this.car);
  final Car car;

  String convertDate(String date, [String time]) {
    var newFormat;

    if (time != null) {
      newFormat = DateFormat("dd MMM yyyy").format(DateTime.parse(date));
      newFormat = "$newFormat - $time";
    } else {
      newFormat =
          DateFormat("dd MMM yyyy - HH:mm").format(DateTime.parse(date));
    }

    return newFormat;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 14.0, left: 15.0),
            child: Text(
              "Pickup & return",
              style: kHeadingStyle,
              textAlign: TextAlign.left,
            ),
          ),
          ListTile(
            title: Text("Pickup"),
            subtitle: (car.reservationNumber == null)
                ? Text(
                    "${convertDate(gSearchData.pickupDate, gSearchData.pickupTime)}")
                : Text("${convertDate(car.pickupDatetime)}"),
          ),
          ListTile(
            title: Text("Return"),
            subtitle: (car.reservationNumber == null)
                ? Text(
                    "${convertDate(gSearchData.returnDate, gSearchData.returnTime)}")
                : Text("${convertDate(car.returnDatetime)}"),
          ),
        ],
      ),
    );
  }
}
