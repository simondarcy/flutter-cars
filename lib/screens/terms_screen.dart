import 'package:flutter/material.dart';
import 'package:flutter_cars/utilities/car.dart';
import 'package:flutter_cars/services/ota.dart';

class TermsScreen extends StatefulWidget {
  TermsScreen({this.car});
  final Car car;

  @override
  _TermsScreenState createState() => _TermsScreenState();
}

// stores ExpansionPanel state information
class Term {
  Term({
    this.expandedValue,
    this.headerValue,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
}

//Generate a list of terms from API data.
List<Term> generateTerms(dynamic termsData) {
  return List.generate(termsData.length, (int index) {
    return Term(
      headerValue: "${termsData[index]['@Title']}",
      expandedValue: "${termsData[index]['Paragraph']}",
    );
  });
}

class _TermsScreenState extends State<TermsScreen> {
  List<Term> _data = [];

  @override
  void initState() {
    var terms = OTA().getTerms(widget.car).then((result) {
      setState(() {
        //update _data with terms retrieved from API
        _data = generateTerms(result['RentalConditions']);
      });
      return;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rental Conditions'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: _buildPanel(),
          ),
        ),
      ),
    );
  } //end build

  //Function to create expansion panels
  Widget _buildPanel() {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        //On tap expand panel
        setState(() {
          _data[index].isExpanded = !_data[index].isExpanded;
        });
      },
      //Create panel for each term returned
      children: _data.map<ExpansionPanel>((Term term) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(term.headerValue),
            );
          },
          body: Padding(
            padding: EdgeInsets.only(left: 18.0, right: 18.0, bottom: 18.0),
            child: Text(term.expandedValue),
          ),
          isExpanded: term.isExpanded,
        );
      }).toList(),
    );
  }
} //
