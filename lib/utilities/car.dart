import 'package:flutter_cars/utilities/constants.dart';

class Car {
  final String name;
  final String image;
  final String size;
  final String transmission;
  final String fuel;
  final String price;
  final String currencySymbol;
  final int order;
  final int passengers;
  final int bags;
  final dynamic offers;
  final dynamic reference;
  final supplierName;
  final supplierImage;
  final supplierAddress;
  final supplierLocation;
  final supplierCode;
  //Follow data is added when car is booked
  String pickupDatetime;
  String returnDatetime;
  String reservationNumber;
  String customerEmail;
  String customerFName;
  String customerLName;

  Car(
      {this.name,
      this.image,
      this.size,
      this.transmission,
      this.fuel,
      this.price,
      this.currencySymbol,
      this.order,
      this.passengers,
      this.bags,
      this.offers,
      this.reference,
      this.supplierName,
      this.supplierImage,
      this.supplierAddress,
      this.supplierLocation,
      this.supplierCode,
      this.pickupDatetime,
      this.returnDatetime,
      this.reservationNumber,
      this.customerEmail,
      this.customerFName,
      this.customerLName});

  //Convert JSON object (API) to Car Object
  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
        name: json['VehAvailCore']['Vehicle']['VehMakeModel']['@Name'],
        image: json['VehAvailCore']['Vehicle']['PictureURL'],
        size: carSizes[json['VehAvailCore']['Vehicle']['VehClass']['@Size']],
        transmission: json['VehAvailCore']['Vehicle']['@TransmissionType'],
        fuel: json['VehAvailCore']['Vehicle']['@FuelType'],
        price: json['VehAvailCore']['TotalCharge']['@RateTotalAmount'],
        currencySymbol: currencySymbols[json['VehAvailCore']['TotalCharge']
            ['@CurrencyCode']],
        order: int.parse(
            json['VehAvailCore']['TPA_Extensions']['OrderBy']['@Index']),
        passengers:
            int.parse(json['VehAvailCore']['Vehicle']['@PassengerQuantity']),
        bags: int.parse(json['VehAvailCore']['Vehicle']['@BaggageQuantity']),
        offers: json['VehAvailCore']['TPA_Extensions']['SpecialOffers'],
        reference: json['VehAvailCore']['Reference'],
        supplierName: json['supplierName'],
        supplierImage: json['supplierImage'],
        supplierAddress: json['supplierAddress'],
        supplierLocation: json['supplierLocation'],
        supplierCode: json['supplierCode']);
  }

  //Create car object from SQLite data
  factory Car.fromMap(Map<String, dynamic> map) {
    return Car(
        name: map['name'],
        image: map['image'],
        size: map['size'],
        transmission: map['transmission'],
        fuel: map['fuel'],
        price: map['price'],
        currencySymbol: map['currencySymbol'],
        order: map['carOrder'],
        passengers: map['passengers'],
        bags: map['bags'],
        offers: {},
        reference: {},
        supplierName: map['supplierName'],
        supplierImage: map['supplierImage'],
        supplierAddress: map['supplierAddress'],
        supplierLocation: map['supplierLocation'],
        supplierCode: map['supplierCode'],
        pickupDatetime: map['pickupDatetime'],
        returnDatetime: map['returnDatetime'],
        reservationNumber: map['reservationNumber'],
        customerEmail: map['customerEmail'],
        customerFName: map['customerFName'],
        customerLName: map['customerLName']);
  }

  //Convert Car object to a key-value map which can be stored in SQLite DB
  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'image': this.image,
      'size': this.size,
      'transmission': this.transmission,
      'fuel': this.fuel,
      'price': this.price,
      'currencySymbol': this.currencySymbol,
      'carOrder': this.order,
      'passengers': this.passengers,
      'bags': this.bags,
      'offers': this.offers.toString(),
      'supplierName': this.supplierName,
      'supplierImage': this.supplierImage,
      'supplierAddress': this.supplierAddress,
      'supplierLocation': this.supplierLocation,
      'supplierCode': this.supplierCode,
      'pickupDatetime': this.pickupDatetime,
      'returnDatetime': this.returnDatetime,
      'reservationNumber': this.reservationNumber,
      'customerEmail': this.customerEmail,
      'customerFName': this.customerFName,
      'customerLName': this.customerLName
    };
  }

  //for test purposes
  factory Car.dummy() {
    return Car(
        name: 'Fiat 500 or similar',
        image: 'https://ctimg-fleet.cartrawler.com/fiat/500/primary.png',
        size: 'Mini',
        transmission: 'Automatic',
        fuel: 'Petrol',
        price: '136.58',
        currencySymbol: '€',
        order: 1,
        passengers: 2,
        bags: 2,
        offers: {},
        reference: {
          '@Type': '16',
          '@ID': '1117029556',
          '@ID_Context': 'CARTRAWLER',
          '@DateTime': '2020-12-18T10:12:38.786Z',
          '@URL': 'da9d6878-3b28-47a8-8db1-4788096db9c7.63'
        },
        supplierName: 'EUROPCAR',
        supplierImage:
            'https://ctimg-supplier.cartrawler.com/europcar.pdf?output=auto&w=84&q=80&dpr=2',
        supplierLocation: '51.6642000, -0.0446000',
        supplierAddress: '428 HERTFORD ROAD, ENFIELD, ENFIELD, EN3 5QS',
        supplierCode: '0:283068',
        pickupDatetime: '2020-11-13T10:00:00',
        returnDatetime: '2021-11-15T10:00:00',
        reservationNumber: 'US529662160',
        customerEmail: 'sidarcy@gmail.com',
        customerFName: 'Simon',
        customerLName: 'Darcy');
  }
}
