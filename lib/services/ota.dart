import 'package:flutter_cars/services/networking.dart';
import 'package:flutter_cars/utilities/constants.dart';
import 'package:flutter_cars/utilities/car.dart';
import 'package:flutter_cars/utilities/driver.dart';
import 'package:flutter_cars/utilities/global_data.dart';
import 'dart:convert';
//import 'dart:developer';

// Various functions used to communicate with CarTrawler API
// Full documentation here: https://docs.cartrawler.com/docs/xml/api-reference.html
class OTA {
  //Request car availability from a specific Location at a specific Date/Time using OTA_VehAvailRate.
  Future<List<Car>> getCarList(searchData) async {
    var type = 'OTA_VehAvailRateRQ';

    final jsonEncoder = JsonEncoder();

    var data = {
      "@xmlns": "http://www.opentravel.org/OTA/2003/05",
      "@xmlns:xsi": "http://www.w3.org/2001/XMLSchema-instance",
      "@Target": "${kServer}",
      "@Version": "1.005",
      "POS": {
        "Source": {
          "@ISOCurrency": "EUR",
          "RequestorID": {
            "@Type": "16",
            "@ID": "${kClientID}",
            "@ID_Context": "CARTRAWLER"
          }
        }
      },
      "VehAvailRQCore": {
        "@Status": "Available",
        "VehRentalCore": {
          "@PickUpDateTime":
              "${searchData.pickupDate}T${searchData.pickupTime}:00",
          "@ReturnDateTime":
              "${searchData.returnDate}T${searchData.returnTime}:00",
          "PickUpLocation": {
            "@CodeContext": "GEO",
            "#text": "${searchData.latitude},${searchData.longitude}"
          },
          "ReturnLocation": {
            "@CodeContext": "GEO",
            "#text": "${searchData.latitude},${searchData.longitude}"
          }
        },
        "DriverType": {"@Age": "30"}
      },
      "VehAvailRQInfo": {
        "@PassengerQty": "1",
        "Customer": {
          "Primary": {
            "CitizenCountryName": {"@Code": "US"}
          }
        },
        "TPA_Extensions": {
          "ConsumerIP": "37.228.212.140"
        } //!todo get actual IP address
      }
    };

    var encoderString = Uri.encodeComponent(jsonEncoder.convert(data));

    //Retreive data using network helper
    NetworkHelper networkHelper =
        NetworkHelper('$otaBaseURL?type=$type&msg=$encoderString');
    var carData = await networkHelper.getData();

    //Make sure a valid availability response came back
    if (carData['VehAvailRSCore'] == null) {
      return [];
    }

    //The server will return a list of vendors
    List<dynamic> vendors = carData['VehAvailRSCore']['VehVendorAvails'];

    //Loop through each car in each vendor to create a cars array
    List<Car> cars = [];
    vendors.forEach((vendor) {
      var vendorCars = vendor['VehAvails'];
      vendorCars.forEach((vehicle) {
        //add vendor information to each car
        vehicle['supplierName'] = vendor['Vendor']['@CompanyShortName'];
        vehicle['supplierImage'] =
            "${vendor['Info']['TPA_Extensions']['VendorPictureURL']['#text']}?output=auto&w=84&q=80&dpr=2";
        vehicle['supplierAddress'] = vendor['Info']['LocationDetails']['@Name'];
        vehicle['supplierCode'] = vendor['Info']['LocationDetails']['@Code'];
        vehicle['supplierLocation'] =
            vendor['Info']['LocationDetails']['Address']['@Remark'];
        //Create a car object and to car list
        Car car = Car.fromJson(vehicle);
        cars.add(car);
      });
    });
    //Sort by recommended order
    cars.sort((a, b) => a.order.compareTo(b.order));
    //Return the car list
    return cars;
  }

  //Reserve a car using OTA_VehRes. Note: I'm proxying the request though my own site
  Future<dynamic> makeCarReservation(Car car, Driver driver) async {
    var type = 'OTA_VehResRQ';

    final jsonEncoder = JsonEncoder();

    var data = {
      "@xmlns": "http://www.opentravel.org/OTA/2003/05",
      "@xmlns:xsi": "http://www.w3.org/2001/XMLSchema-instance",
      "@Target": "${kServer}",
      "@Version": "1.005",
      "POS": {
        "Source": [
          {
            "@ISOCurrency": "EUR",
            "RequestorID": {
              "@Type": "16",
              "@ID": "${kClientID}",
              "@ID_Context": "CARTRAWLER"
            }
          }
        ]
      },
      "VehResRQCore": {
        "@Status": "Available",
        "VehRentalCore": {
          "@PickUpDateTime":
              "${gSearchData.pickupDate}T${gSearchData.pickupTime}:00",
          "@ReturnDateTime":
              "${gSearchData.returnDate}T${gSearchData.returnTime}:00",
          "PickUpLocation": {
            "@CodeContext": "CARTRAWLER",
            "@LocationCode": "${car.supplierCode}"
          },
          "ReturnLocation": {
            "@CodeContext": "CARTRAWLER",
            "@LocationCode": "${car.supplierCode}"
          }
        },
        "Customer": {
          "Primary": {
            "PersonName": {
              "NamePrefix": "Mr.",
              "GivenName": "${driver.fName}",
              "Surname": "${driver.lName}"
            },
            "Telephone": {
              "@PhoneTechType": "1",
              "@PhoneNumber": "${driver.phone}"
            },
            "Email": {"@EmailType": "2", "#text": "${driver.email}"},
            "Address": {
              //!todo figure out how to properly bypass address when not required
              "@Type": "2",
              "AddressLine": "Cartrawler",
              "CountryName": {"@Code": "${driver.residency}"}
            },
            "CitizenCountryName": {"@Code": "${driver.residency}"}
          }
        },
        "DriverType": {"@Age": "${driver.age}"}, //!todo get actual age
      },
      "VehResRQInfo": {
        "RentalPaymentPref": {},
        "Reference": car.reference,
        "TPA_Extensions": {"ConsumerIP": "127.0.0.123"}
      }
    };

    var encoderString = Uri.encodeComponent(jsonEncoder.convert(data));

    //!todo try ping CT URL directly rather than below proxy
    NetworkHelper networkHelper =
        NetworkHelper('$kReservationURL?msg=$encoderString&env=$kServer');
    var carData = await networkHelper.getData();

    //Check the response is valid
    if (carData['VehResRSCore'] == null) {
      print("No VehResRSCore");
      return null;
    } else if (carData['Success'] == null) {
      print("response was not successful");
      return null;
    }

    //Return booked car data
    return carData['VehResRSCore'];
  }

  //Cancel an existing booking with OTA_VehCancel
  Future<dynamic> cancelReservation(Car car) async {
    var type = 'OTA_VehCancelRQ';

    final jsonEncoder = JsonEncoder();

    var data = {
      "@xmlns": "http://www.opentravel.org/OTA/2003/05",
      "@xmlns:xsi": "http://www.w3.org/2001/XMLSchema-instance",
      "@Target": "${kServer}",
      "@Version": "1.007",
      "POS": {
        "Source": {
          "RequestorID": {
            "@Type": "16",
            "@ID": "${kClientID}",
            "@ID_Context": "CARTRAWLER"
          }
        }
      },
      "VehCancelRQCore": {
        "@CancelType": "Book",
        "UniqueID": {"@Type": "15", "@ID": "${car.reservationNumber}"},
        "PersonName": {
          "NamePrefix": "Mr.",
          "GivenName": "${car.customerFName}",
          "Surname": "${car.customerLName}"
        }
      },
      "VehCancelRQInfo": {
        "RentalInfo": {
          "@PickUpDateTime": "${car.pickupDatetime}",
          "@ReturnDateTime": "${car.returnDatetime}",
          "PickUpLocation": {
            "@CodeContext": "CARTRAWLER",
            "@LocationCode": "${car.supplierCode}"
          },
          "ReturnLocation": {
            "@CodeContext": "CARTRAWLER",
            "@LocationCode": "${car.supplierCode}"
          }
        },
        "TPA_Extensions": {
          "Refund": {"@Type": "FULL"}
        }
      }
    };

    var encoderString = Uri.encodeComponent(jsonEncoder.convert(data));

    NetworkHelper networkHelper =
        NetworkHelper('$otaBaseURL?type=$type&msg=$encoderString');
    var carData = await networkHelper.getData();

    return carData;
  }

  //Retrieve car/supplier specific terms & conditions using CT_RentalConditions
  Future<dynamic> getTerms(Car car) async {
    var type = 'CT_RentalConditionsRQ';

    final jsonEncoder = JsonEncoder();

    var data = {
      "@xmlns": "http://www.opentravel.org/OTA/2003/05",
      "@xmlns:xsi": "http://www.w3.org/2001/XMLSchema-instance",
      "@Target": "$kServer",
      "@Version": "1.005",
      "POS": {
        "Source": {
          "@ISOCurrency": "EUR",
          "RequestorID": {
            "@Type": "16",
            "@ID": "${kClientID}",
            "@ID_Context": "CARTRAWLER"
          }
        }
      },
      "VehResRQCore": {
        "@Status": "Available",
        "VehRentalCore": {
          "@PickUpDateTime":
              "${gSearchData.pickupDate}T${gSearchData.pickupTime}:00",
          "@ReturnDateTime":
              "${gSearchData.returnDate}T${gSearchData.returnTime}:00",
          "PickUpLocation": {
            "@CodeContext": "CARTRAWLER",
            "@LocationCode": "${car.supplierCode}"
          },
          "ReturnLocation": {
            "@CodeContext": "CARTRAWLER",
            "@LocationCode": "${car.supplierCode}"
          }
        },
        "Customer": {
          "Primary": {
            "CitizenCountryName": {"@Code": "US"}
          }
        }
      },
      "VehResRQInfo": {"Reference": car.reference}
    };

    var encoderString = jsonEncoder.convert(data);

    //Retrieve data using network helper
    NetworkHelper networkHelper =
        NetworkHelper('$otaBaseURL?type=$type&msg=$encoderString');
    var termsData = await networkHelper.getData();
    //return response !todo check response is valid
    return termsData;
  }

  //Simple function to test connection to CarTrawler API using OTA_Ping
  Future<dynamic> pingOTA(String message) async {
    var type = 'OTA_PingRQ';

    final jsonEncoder = JsonEncoder();

    var data = {
      "@xmlns": "http://www.opentravel.org/OTA/2003/05",
      "@xmlns:xsi": "http://www.w3.org/2001/XMLSchema-instance",
      "@Target": "$kServer",
      "@Version": "1.003",
      "@PrimaryLangID": "EN",
      "EchoData": "$message"
    };

    var encoderString = jsonEncoder.convert(data);

    NetworkHelper networkHelper =
        NetworkHelper('$otaBaseURL?type=$type&msg=$encoderString');
    var carData = await networkHelper.getData();
    return carData;
  }
}
