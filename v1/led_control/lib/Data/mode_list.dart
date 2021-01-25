import 'package:flutter/material.dart';

List<String> modes = [
  "Off",
  "Christmas",
  "Study",
  "Party",
  "Christmas twinkle",
  "Blue twinkle",
  "Green twinkle",
  "Snow",
  "Fire",
  "Blue Fire",
  "Lava"
];

class Mode {
  String modeName;
  List<Color> background;
  List<String> compatibleDevices;

  Mode(this.modeName, this.background, this.compatibleDevices);
}
