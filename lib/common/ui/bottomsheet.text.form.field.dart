import 'package:flutter/material.dart';

class BottomSheetFormField extends StatelessWidget {
  const BottomSheetFormField({
    super.key,
    required this.labelText,
    required this.controller,
    required this.keyboardType,
    this.onTap,
  });

  final String labelText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      autofocus: true,
      autocorrect: false,
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter a value";
        }
        return null;
      },
      decoration: InputDecoration(labelText: labelText,),
      onTap: onTap,
    );
  }
}
