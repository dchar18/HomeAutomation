import 'package:http/http.dart';

// this function sends solid rgb values to a specific board/all boards
sendRGB(String name, String red, String green, String blue) async {
  String combination = red + "/" + green + "/" + blue;
  String address = "http://192.168.50.114:8181/";
  if (name == "all") {
    address = address + "sync/rgb/" + combination;
  } else {
    address = address + "esp8266_" + name + "/rgb/" + combination;
  }
  print("Sending combination " + combination + " to " + address);

  final response = await get(address);
  // print(response.body);
  print("Response code: " + response.statusCode.toString());
}

sendBrightness(String name, String brightness) async {
  String request;
  if (name == "all") {
    request = "sync/brightness/" + brightness;
  } else {
    request = "esp8266_" + name + "/brightness/" + brightness;
  }
  String address = "http://192.168.50.114:8181/" + request;

  print("Sending to " + address);
  final response = await get(address);
  // print(response.body);
  print("Response code: " + response.statusCode.toString());
}

// this function is used to send a mode (not solid rgb) to a specific board or to all
void sendRequest(String device, String mode) async {
  print("Received " + device + ", entering mode: " + mode);
  String url;
  if (mode.contains("twinkle")) {
    mode = mode.replaceAll(" twinkle", "");
    print("current mode: " + mode);
    mode = "twinkle_" + mode;
  } else {
    mode = mode.replaceAll(" ", "_");
  }
  if (device == "All") {
    url = "http://192.168.50.114:8181/sync/" + mode.toLowerCase();
  } else {
    url = "http://192.168.50.114:8181/esp8266_" +
        device.toLowerCase() +
        "/" +
        mode.toLowerCase();
  }

  print("Using url: " + url);
  final response = await get(url);
  // print(response.body);
  print("Response: " + response.statusCode.toString());
}
