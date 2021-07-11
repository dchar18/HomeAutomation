import 'package:flutter/material.dart';
import 'package:led_v2/UI/colors.dart';

class Mode {
  String modeName;
  List<Color> background;

  Mode(this.modeName, this.background);
}

List<Mode> modes = [
  new Mode("Off", off),
  new Mode("Off/On", off),
  new Mode("RGB", rgb),
  new Mode("Color Fade", fade),
  new Mode("Party", party),
  new Mode("Lava", lava),
  new Mode("Fire", fire),
  new Mode("Christmas", christmas),
  new Mode("Christmas twinkle", sunset),
  new Mode("Green twinkle", green_twinkle),
  new Mode("Blue Fire", sea),
  new Mode("Blue twinkle", blue_twinkle),
  new Mode("Study", study),
  new Mode("Red Stable", red),
  new Mode("Red Pulse", red_pulse),
  new Mode("Green Stable", green),
  new Mode("Green Pulse", green_pulse),
  new Mode("Cell", cell),
  new Mode("Speed", speed)
];

getModeDict() {
  var modeDict = {};
  for (int i = 0; i < modes.length; i++) {
    modeDict[modes[i].modeName] = modes[i];
  }
  return modeDict;
}
