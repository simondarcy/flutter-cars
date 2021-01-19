import 'package:flutter/material.dart';
import 'package:flutter_cars/utilities/constants.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:io';

class VoucherScreen extends StatefulWidget {
  VoucherScreen({this.reservationNumber, this.email});
  final reservationNumber;
  final email;

  @override
  _VoucherScreenState createState() => _VoucherScreenState();
}

class _VoucherScreenState extends State<VoucherScreen> {
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Voucher'),
        ),
        body: WebView(
          initialUrl:
              '${kVoucherBaseURL}?resid=${widget.reservationNumber}&email=${widget.email}',
        ));
  }
}
