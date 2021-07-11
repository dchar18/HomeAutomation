import 'package:http/http.dart' as http;

// All boards other than esp8266_maya are connected to the server
// esp8266_maya is a stand-alone board that opens its own access point
// Thus, the board is not associated with the Pi server

String serverIP = '192.168.50.115';
String serverPort = '8181';
String serverAddress = 'http://' + serverIP + ":" + serverPort + '/';

var url; // used to store URI for request

sendRGB(String name, String red, String green, String blue) {
  // store RGB value combination in a url format
  String combination;

  // clean the name string
  name = name.toLowerCase();
  name = name.replaceAll(" ", "");

  if (name == 'maya') {
    var params = {
      'mode': 'rgb',
      'red': red,
      'green': green,
      'blue': blue,
    };
    url = Uri.http('192.168.4.1', '', params);
  } else {
    // store RGB value combination in a url format
    combination = red + '/' + green + '/' + blue;
    if (name == 'all') {
      url = Uri.http(serverIP + ':' + serverPort, 'sync/rgb/' + combination);
    } else {
      url = Uri.http(serverIP + ':' + serverPort,
          'esp8266_' + name + 'rgb/' + combination);
    }
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

  mode = mode.toLowerCase();
  mode = mode.replaceAll(" ", "_");

  if (name == 'maya') {
    var params = {
      'mode': mode,
    };
    url = Uri.http('192.168.4.1', '', params);
  } else {
    if (name == 'all') {
      url = Uri.http(serverIP + ':' + serverPort, 'sync/' + mode);
    } else {
      url =
          Uri.http(serverIP + ':' + serverPort, 'esp8266_' + name + '/' + mode);
    }
  }

  sendRequest(url);
}

sendCell(String row, String col, String red, String green, String blue) {
  String cellRequest =
      'cell/' + row + '/' + col + '/' + red + '/' + green + '/' + blue;
  url = Uri.http(serverIP + ':' + serverPort, 'esp8266_case/' + cellRequest);
  print('Sending: ' + url.toString());
  sendRequest(url);
}

sendRequest(var url) async {
  // send the request
  print("Sending request to: " + url.toString());
  final response = await http.get(url);

  print("Response code: " + response.statusCode.toString());
}
