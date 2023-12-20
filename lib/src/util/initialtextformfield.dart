import 'package:flutter/material.dart';

TextFormField textFormField(
        {required TextEditingController textcontroller,
        required String? Function(String?) validator,
        required String text,
        required IconData icon}) =>
    TextFormField(
      controller: textcontroller,
      decoration: InputDecoration(
        icon: Icon(icon),
        labelText: text,
      ),
      obscureText: true,
      autocorrect: false,
      autovalidateMode: AutovalidateMode.always,
      validator: validator,
    );
