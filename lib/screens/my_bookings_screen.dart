import 'package:flutter/material.dart';
import 'package:flutter_cars/utilities/car.dart';
import 'package:flutter_cars/utilities/global_data.dart';
import 'package:flutter_cars/widgets/car_block.dart';
import 'package:flutter_cars/screens/confirmation_screen.dart';

class BookingsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BookingsScreenState();
  }
}

class _BookingsScreenState extends State<BookingsScreen> {
  //Future<List<Map<String, dynamic>>>
  Future<List<Car>> fetchBookingsFromDatabase() async {
    List<Car> cars = [];
    final result = await dbClient.rawQuery("SELECT * FROM Cars");
    result.forEach((vehicle) {
      Car car = Car.fromMap(vehicle);
      cars.add(car);
    });
    return cars;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new SafeArea(
        child: new FutureBuilder<List<Car>>(
          future: fetchBookingsFromDatabase(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.length == 0) {
                return Center(
                  child: Text("You have no bookings :/"),
                );
              } else {
                return new ListView.builder(
                    padding: new EdgeInsets.all(8.0),
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ConfirmationScreen(
                                car: snapshot.data[index]);
                          }));
                        },
                        child: CarBlock(snapshot.data[index]),
                      );
                    });
              }
            } else if (snapshot.hasError) {
              return new Text("${snapshot.error}");
            }
            return new Container(
              alignment: AlignmentDirectional.center,
              child: new CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
