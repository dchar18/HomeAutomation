List<String> devices = [
  "All",
  "Bed",
  "Case",
  "Desk",
  "Door",
  "Lego Sian",
  "Maya",
  "RC Lambo",
];

List<List<String>> compatibleModes = [
  // All --------------------
  [
    "Off",
    "RGB",
    "Color Fade",
    "Party",
    "Lava",
    "Fire",
    "Christmas",
    "Christmas twinkle",
    "Green twinkle",
    "Blue Fire",
    "Blue twinkle",
    "Study",
    "Red Stable",
    "Red Pulse",
    "Green Stable",
    "Green Pulse"
  ],
  // Bed --------------------
  [
    "Off",
    "RGB",
    "Color Fade",
    "Party",
    "Lava",
    "Fire",
    "Christmas",
    "Christmas twinkle",
    "Green twinkle",
    "Blue Fire",
    "Blue twinkle",
    "Study"
  ],
  // Case -------------------
  [
    "Off",
    "Cell",
    "Color Fade",
    "Party",
    "Lava",
    "Green twinkle",
    "Blue twinkle",
    "Study"
  ],
  // Desk -------------------
  [
    "Off",
    "RGB",
    "Color Fade",
    "Party",
    "Lava",
    "Fire",
    "Christmas",
    "Christmas twinkle",
    "Green twinkle",
    "Blue Fire",
    "Blue twinkle",
    "Study"
  ],
  // Door -------------------
  ["Off", "Red Stable", "Red Pulse", "Green Stable", "Green Pulse"],
  // Lego Sian --------------
  ["Off/On"],
  // Maya -------------------
  ["Off", "RGB", "Speed", "Color Fade", "Party", "Blue twinkle"],
  // RC Lambo ---------------
  ["Off", "RGB", "Color Fade"]
];

class Device {
  var deviceName;
  var currMode;
  var modes;
  var rgb;
  var currCell; // unused for all but esp8266_case

  Device(String name, List<String> modes) {
    this.deviceName = name;
    this.currMode = "off";
    this.modes = modes;
    this.rgb = new Map();
    this.rgb['red'] = 0.0;
    this.rgb['green'] = 0.0;
    this.rgb['blue'] = 0.0;
    this.rgb['brightness'] = 65.0;
    this.currCell = [0, 0];
  }

  String getName() {
    return this.deviceName;
  }

  String getMode() {
    return this.currMode;
  }

  void setMode(String mode) {
    this.currMode = mode;
  }

  List<String> getModes() {
    return this.modes;
  }

  getRed() {
    return this.rgb['red'];
  }

  void setRed(double red) {
    this.rgb['red'] = red;
  }

  getGreen() {
    return this.rgb['green'];
  }

  void setGreen(double green) {
    this.rgb['green'] = green;
  }

  getBlue() {
    return this.rgb['blue'];
  }

  void setBlue(double blue) {
    this.rgb['blue'] = blue;
  }

  getRGB() {
    return [
      this.rgb['red'].round(),
      this.rgb['green'].round(),
      this.rgb['blue'].round()
    ];
  }

  getBrightness() {
    return this.rgb['brightness'];
  }

  void setBrightness(double brightness) {
    this.rgb['brightness'] = brightness;
  }

  List<int> getCell() {
    return this.currCell;
  }

  void setCellRow(int row) {
    this.currCell[0] = row;
  }

  void setCellCol(int col) {
    this.currCell[1] = col;
  }
}

// creates a list of Device objects using the device titles listed in devices
// getDevices() {
//   List<Device> deviceList = [];
//   for (int i = 0; i < devices.length; i++) {
//     deviceList.add(new Device(devices[i]));
//   }
//   return deviceList;
// }
// creates a dictionary of Device objects where the key is the device name
getDevices() {
  var deviceList = {};
  print('Making the list...');
  for (int i = 0; i < devices.length; i++) {
    deviceList[devices[i]] = new Device(devices[i], compatibleModes[i]);
    print(i.toString() + ": " + compatibleModes[i].toString());
  }
  return deviceList;
}
