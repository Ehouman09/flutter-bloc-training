import 'package:flutter/material.dart';

const lightGrey = const Color(0xfff1f4f6);
const lightBlue = const Color(0xffb0d5ee);
const darkBlue = const Color(0xff284059);
const red = const Color(0xffe04f59);
const lightRed = const Color(0xfffab6b5);
const light = const Color(0xfff5f3eb);
const white = const Color(0xffffffff);

List<Color> colors = [lightBlue, darkBlue, lightRed, red, light, white];

extension ColorExtension on String {
  toColor() {
    var hexString = this;
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('0x', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}