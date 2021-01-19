import 'package:flutter/material.dart';
import 'package:flutter_cars/settings.dart';

const kClientID = CARTRAWLER_CLIENT_ID;
const kGoogleMapsKey = GOOGLE_MAPS_API_KEY;

const kServer = 'Test';
const otaBaseURL = (kServer == "Test")
    ? 'https://external-dev-avail.cartrawler.com/cartrawlerota/json'
    : 'https://otageo.cartrawler.com/cartrawlerota/json';

//Using a php file on personal server as proxy to get around CORS issue
const kReservationURL =
    "https://simondarcyonline.com/cartrawler/vehres/booking.php";

const kVoucherBaseURL = "https://voucher.cartrawler.com/voucher";

const kButtonTextStyle = TextStyle(
  fontSize: 20.0,
);

const kCardMargin = 8.0;

const kFixedButtonPadding =
    EdgeInsets.only(left: 10.0, right: 10.0, bottom: 15.0);

const kTitleStyle = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 25.0,
);

Color greyColor = Colors.black.withOpacity(0.6);

const kHeadingStyle = TextStyle(
  fontSize: 20.0,
  fontWeight: FontWeight.bold,
);

const kEnabledBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(10.0)),
  borderSide: const BorderSide(
    color: Colors.grey,
  ),
);

const kFocusedBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(10.0)),
  borderSide: BorderSide(color: Colors.blue),
);

const kErrorBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(10.0)),
  borderSide: BorderSide(color: Colors.red),
);

const kInputSpacing = 16.0;

const currencySymbols = {
  'EUR': '€',
  'USD': '\$',
  'GBP': '£',
};

const carSizes = {
  "1": "Mini",
  "2": "Subcompact",
  "3": "Economy",
  "4": "Compact",
  "5": "Midsize",
  "6": "Intermediate",
  "7": "Standard",
  "8": "Fullsize",
  "9": "Luxury",
  "10": "Premium",
  "11": "Minivan",
  "12": "12 passenger van",
  "13": "Moving van",
  "14": "15 passenger van",
  "15": "Cargo van",
  "16": "12 foot truck",
  "17": "20 foot truck",
  "18": "24 foot truck",
  "19": "26 foot truck",
  "20": "Moped",
  "21": "Stretch",
  "22": "Regular",
  "23": "Unique",
  "24": "Exotic",
  "25": "Small/medium truck",
  "26": "Large truck",
  "27": "Small SUV",
  "28": "Medium SUV",
  "29": "Large SUV",
  "30": "Exotic SUV",
  "31": "Four-wheel drive",
  "32": "Special",
  "33": "Mini elite",
  "34": "Economy elite",
  "35": "Compact elite",
  "36": "Intermediate elite",
  "37": "Standard elite",
  "38": "Fullsize elite",
  "39": "Premium elite",
  "40": "Luxury elite",
  "41": "Oversize",
  "42": "50 passenger coach",
  "43": "Convertible",
  "44": "Estate Car",
  "45": "5 Seat People Carrier",
  "46": "7 Seat People Carrier",
  "47": "9 seat minivan",
  "48": "SUV",
};

const List<String> availableTimes = [
  '10:00',
  '10:30',
  '11:00',
  '11:30',
  '12:00',
  '12:30',
  '13:00',
  '13:30',
  '14:00',
  '14:30',
  '15:00',
  '15:30',
  '16:00',
  '16:30',
  '17:00',
  '17:30',
  '18:00',
  '18:30',
  '19:00',
  '19:30',
  '20:00',
  '20:30',
  '23:00',
  '23:30',
  '00:00',
  '07:00',
  '07:30',
  '08:00',
  '08:30',
  '09:00',
  '09:30',
];
