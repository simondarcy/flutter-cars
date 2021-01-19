import 'package:flutter/material.dart';
import 'package:flutter_cars/utilities/constants.dart';

class OffersWidget extends StatelessWidget {
  OffersWidget(this.offers);
  final dynamic offers;

  Widget displayOffer(offer) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, bottom: 10.0),
      child: Row(
        children: [
          Icon(
            Icons.check,
            color: Colors.green,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            offer,
            style: TextStyle(fontSize: 16.0, color: greyColor),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 14.0, left: 15.0, bottom: 10.0),
            child: Text(
              "Whats included",
              style: kHeadingStyle,
              textAlign: TextAlign.left,
            ),
          ),
          displayOffer('Free Cancellation'),
          if (offers != null && offers.length > 1)
            for (var offer in offers) displayOffer(offer['@ShortText']),
          if (offers != null && offers.length == 1)
            displayOffer(offers['Offer']['@ShortText']),
        ],
      ),
    );
  }
}
