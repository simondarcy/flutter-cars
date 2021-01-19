import 'package:flutter/material.dart';
import 'package:flutter_cars/utilities/car.dart';
import 'package:flutter_cars/utilities/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CarBlock extends StatelessWidget {
  CarBlock(this.car);
  final Car car;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(children: <Widget>[
        ListTile(
          title: Text('${car.size} Car', style: kHeadingStyle),
          subtitle: Text(
            car.name,
            style: TextStyle(
              color: greyColor,
            ),
          ),
          trailing: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Image(
              image: NetworkImage(car.supplierImage),
              width: 70.0,
            ),
          ),
        ),
        CachedNetworkImage(
          imageUrl: car.image,
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        Row(
          //Divider line
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                child: Divider(color: greyColor),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 10.0, left: 20.0, right: 20.0),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 7,
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.card_travel),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        '${car.bags.toString()}',
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Icon(
                        Icons.person,
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        '${car.passengers.toString()}',
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Icon(
                        Icons.tune,
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        '${car.transmission}',
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      // padding: EdgeInsets.all(8.0),
                      child: Text(
                        '${car.currencySymbol}${car.price}',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontSize: 22.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      //color: Colors.red,
                      // padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Total',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: greyColor,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
