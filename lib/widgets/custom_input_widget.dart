import 'package:flutter/material.dart';
import 'package:flutter_cars/utilities/constants.dart';

class CustomInputWidget extends StatelessWidget {
  CustomInputWidget(this.name, this.controller, this.type, this.caps);
  final String name;
  final TextEditingController controller;
  final TextInputType type;
  final bool caps;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      textCapitalization:
          (caps) ? TextCapitalization.words : TextCapitalization.none,
      autocorrect: false,
      keyboardType: type,
      autofocus: true,
      decoration: new InputDecoration(
        hintText: name,
        labelText: name,
        enabledBorder: kEnabledBorder,
        focusedBorder: kFocusedBorder,
        errorBorder: kErrorBorder,
        focusedErrorBorder: kErrorBorder,
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'This field is required';
        }
        return null;
      },
    );
  }
}
