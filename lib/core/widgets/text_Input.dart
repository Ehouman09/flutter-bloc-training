import 'package:flutter/material.dart';

import 'colors.dart';

const textInputDecoration = InputDecoration(
  fillColor: lightGrey,
  filled: true,
  hintStyle: TextStyle(fontFamily: 'ceraMedium', fontSize: 17),
  contentPadding: EdgeInsets.all(20),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: lightGrey, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(10))
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: darkBlue, width: 2.0),
      borderRadius: BorderRadius.all(Radius.circular(10))
  ),
);

const addTextInputDecoration = InputDecoration(
  fillColor: Colors.transparent,
    border: InputBorder.none,
    focusedBorder: InputBorder.none,
    enabledBorder: InputBorder.none,
    errorBorder: InputBorder.none,
    disabledBorder: InputBorder.none,
  contentPadding: EdgeInsets.all(20),
);