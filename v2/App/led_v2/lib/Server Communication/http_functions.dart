import 'package:http/http.dart' as http;

String serverIP = '192.168.50.115';
String serverPort = '8181';
String serverAddress = 'http://' + serverIP + ":" + serverPort + '/';

var url; // used to store URI for request

sendRGB(String name, String red, String green, String blue) {
  // store RGB value combination in a url format
  String combination = red + '/' + green + '/' + blue;

  // clean the name string
  name = name.toLowerCase();
  name = name.replaceAll(" ", "");

  if (name == 'all') {
    url = Uri.http(serverIP + ':' + serverPort, 'sync/rgb/' + combination);
  } else {
    url = Uri.http(
        serverIP + ':' + serverPort, 'esp8266_' + name + 'rgb/' + combination);
  }

  sendRequest(url);
}

sendBrightness(String name, String brightness) {
  // clean the name string
  name = name.toLowerCase();
  name = name.replaceAll(" ", "");

  if (name == 'all') {
    url =
        Uri.http(serverIP + ':' + serverPort, 'sync/brightness/' + brightness);
  } else {
    url = Uri.http(serverIP + ':' + serverPort,
        'esp8266_' + name + '/brightness/' + brightness);
  }

  sendRequest(url);
}

sendMode(String name, String mode) {
  // clean the name string
  name = name.toLowerCase();
  name = name.replaceAll(" ", "");

  if (name == 'all') {
    url = Uri.http(serverIP + ':' + serverPort, 'sync/' + mode);
  } else {
    url = Uri.http(serverIP + ':' + serverPort, 'esp8266_' + name + '/' + mode);
  }

  sendRequest(url);
}

sendRequest(var url) async {
  // send the request
  print("Sending request to: " + url);
  final response = await http.get(url);

  print("Response code: " + response.statusCode.toString());
}
