import 'package:flutter/material.dart';
import 'package:flutter_cars/utilities/car.dart';
import 'package:flutter_cars/widgets/car_block.dart';
import 'package:flutter_cars/services/ota.dart';
import 'package:flutter_cars/screens/car_details_screen.dart';

class SearchResultsScreen extends StatefulWidget {
  SearchResultsScreen({this.searchData});
  final searchData;
  @override
  _SearchResultsScreenState createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  OTA ota = new OTA();

  @override
  void initState() {
    super.initState();
  }

  Future<List<Car>> getCars() async {
    var carData = ota.getCarList(widget.searchData);
    return carData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results'),
      ),
      body: SafeArea(
        child: FutureBuilder<List<Car>>(
          future: ota.getCarList(widget.searchData),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              //If no cars were removed show error and "Search again button";
              if (snapshot.data.length == 0) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("No cars returned :/"),
                      FlatButton(
                        color: Colors.blue,
                        textColor: Colors.white,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Search Again"),
                      )
                    ],
                  ),
                );
              } else {
                //Cars returned!
                return new ListView.builder(
                    padding: new EdgeInsets.all(8.0),
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          //Pass car to car details screen
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return CarDetailsScreen(car: snapshot.data[index]);
                          }));
                        },
                        //Display car block
                        child: new CarBlock(snapshot.data[index]),
                      );
                    });
              }
              //If error from snapshot
            } else if (snapshot.hasError) {
              //add could not find cars etc
              return Container(
                alignment: AlignmentDirectional.center,
                child: new Text("Error: ${snapshot.error}"),
              );
            }
            return Center(
              child: Column(
                //Loading state
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      "Searching for cars in ${widget.searchData.locationName}",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
