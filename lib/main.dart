import 'package:flutter/material.dart';
import 'package:flutter_cars/utilities/driver.dart';
import 'package:flutter_cars/utilities/car.dart';
import 'package:flutter_cars/screens/home_screen.dart';
import 'package:flutter_cars/utilities/sqlite.dart';
import 'package:flutter_cars/utilities/global_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Initialize sq-lite
  final db = SqliteDB();
  var tables = await db.countTable();

  //initialse DB
  dbClient = await SqliteDB().db;

  //if table hasn't been created yet, create it
  if (tables == 0) {
    var res = await dbClient.execute("""
      CREATE TABLE Cars(
        id INTEGER PRIMARY KEY,
        name TEXT,
        image TEXT,
        size TEXT,
        transmission TEXT,
        fuel TEXT,
        price TEXT,
        currencySymbol TEXT,
        carOrder INTEGER,
        passengers INTEGER,
        bags INTEGER,
        offers TEXT,
        supplierName TEXT,
        supplierImage TEXT,
        supplierAddress TEXT,
        supplierLocation TEXT,
        supplierCode TEXT,
        pickupDatetime TEXT,
        returnDatetime TEXT,
        reservationNumber TEXT,
        customerEmail TEXT,
        customerFName TEXT,
        customerLName TEXT
      )""");
  }

  //Test insert into mysqlDB
  // var car = Car.dummy();
  // int res = await dbClient.insert("Cars", car.toMap());

  /// Runs the app
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      darkTheme: new ThemeData.dark(),
      routes: {
        '/': (BuildContext context) => HomeScreen(),
      },
    );
  }
}
