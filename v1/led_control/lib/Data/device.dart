import 'dart:collection';

List<String> devices = ["All", "Bed", "Desk", "RC Lambo", "Door Sensor"];

class Device {
  String deviceName;
  String mode;
  var rgb;

  Device(String name) {
    this.deviceName = name;
    this.mode = "off";
    this.rgb = new Map();
    this.rgb['red'] = 0.0;
    this.rgb['green'] = 0.0;
    this.rgb['blue'] = 0.0;
    this.rgb['brightness'] = 65.0;
  }

  String getName() {
    return this.deviceName;
  }

  String getMode() {
    return this.mode;
  }

  void setMode(String mode) {
    this.mode = mode;
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

  getBrightness() {
    return this.rgb['brightness'];
  }

  void setBrightness(double brightness) {
    this.rgb['brightness'] = brightness;
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
  for (int i = 0; i < devices.length; i++) {
    deviceList[devices[i]] = new Device(devices[i]);
  }
  return deviceList;
}
