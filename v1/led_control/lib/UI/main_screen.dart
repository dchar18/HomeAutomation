import 'package:flutter/material.dart';
import 'package:led_control/Data/device.dart';
import 'package:led_control/Data/mode_list.dart';
// import 'package:led_control/Widgets/card.dart';
import 'package:expandable/expandable.dart';
import 'package:led_control/HTTP/http_functions.dart';
import 'package:led_control/UI/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var deviceList = getDevices();

  List<Mode> modeList = [
    new Mode("Off", off, devices),
    new Mode("Brightness", brightness, devices),
    new Mode("RGB", blue, ["All", "Bed", "Desk", "RC Lambo"]),
    new Mode("Party", party, ["All", "Bed", "Desk"]),
    new Mode("Lava", lava, ["All", "Bed", "Desk"]),
    new Mode("Fire", fire, ["All", "Bed", "Desk"]),
    new Mode("Christmas", sunset, ["All", "Bed", "Desk"]),
    new Mode("Christmas twinkle", christmas, ["All", "Bed", "Desk"]),
    new Mode("Green twinkle", green_twinkle, ["All", "Bed", "Desk"]),
    new Mode("Blue Fire", sea, ["All", "Bed", "Desk"]),
    new Mode("Blue twinkle", blue_twinkle, ["All", "Bed", "Desk"]),
    new Mode("Study", study, ["All", "Bed", "Desk"]),
    new Mode("Snow", snow, ["All", "Bed", "Desk"]),
  ];

  // @override
  // void initState() {
  //   super.initState();
  //   deviceList = getDevices();
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: pageBackgroundColor,
      ),
      child: Column(
        children: [
          SizedBox(
            height: 40,
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(
              left: 15,
              top: 15,
              bottom: 5,
            ),
            child: Text(
              "LED Control",
              style: TextStyle(
                color: whiteText,
                fontSize: 35.0,
                fontFamily: "Roboto",
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              scrollDirection: Axis.vertical,
              children:
                  modeList.map((mode) => cardTemplate(context, mode)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget cardTemplate(context, mode) {
    return ExpandableNotifier(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 5,
        ),
        child: Card(
          color: pageBackgroundColor,
          clipBehavior: Clip.antiAlias,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: mode.background,
              ),
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            child: Column(
              children: [
                ScrollOnExpand(
                  scrollOnExpand: true,
                  scrollOnCollapse: false,
                  child: ExpandablePanel(
                    theme: const ExpandableThemeData(
                      headerAlignment: ExpandablePanelHeaderAlignment.center,
                      tapBodyToCollapse: true,
                    ),
                    header: Padding(
                      padding: EdgeInsets.only(
                        top: 35,
                        left: 25,
                        bottom: 25,
                      ),
                      child: Text(
                        mode.modeName,
                        style: TextStyle(
                          color: mode.modeName == "Brightness"
                              ? darkText
                              : Colors.white,
                          fontSize: 30.0,
                          fontFamily: "Roboto",
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    // collapsed: Text(
                    //   "Something...",
                    //   softWrap: true,
                    //   maxLines: 2,
                    //   overflow: TextOverflow.ellipsis,
                    // ),
                    // expanded: Column(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: <Widget>[
                    //     for (var _ in Iterable.generate(5))
                    //       Padding(
                    //         padding: EdgeInsets.only(bottom: 10),
                    //         child: Text(
                    //           "loremIpsum",
                    //           softWrap: true,
                    //           overflow: TextOverflow.fade,
                    //         ),
                    //       ),
                    //   ],
                    // ),
                    expanded: getCardWidget(mode),
                    builder: (_, collapsed, expanded) {
                      return Padding(
                        padding:
                            EdgeInsets.only(left: 10, right: 10, bottom: 10),
                        child: Expandable(
                          collapsed: collapsed,
                          expanded: expanded,
                          theme: const ExpandableThemeData(crossFadePoint: 0),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getCardWidget(mode) {
    String name = mode.modeName.toLowerCase();
    // print("a. " +
    //     mode.modeName +
    //     ": " +
    //     mode.compatibleDevices.length.toString());
    if (name == "off") {
      return standardOptions(mode);
    } else if (name == "brightness") {
      return brightnessWidget(mode);
    } else if (name == "rgb") {
      return rgbOption(mode);
    } else if (name == "christmas") {
      return standardOptions(mode);
    } else if (name == "study") {
      return standardOptions(mode);
    } else if (name == "party") {
      return standardOptions(mode);
    } else if (name == "christmas twinkle") {
      return standardOptions(mode);
    } else if (name == "blue twinkle") {
      return standardOptions(mode);
    } else if (name == "green twinkle") {
      return standardOptions(mode);
    } else if (name == "snow") {
      return standardOptions(mode);
    } else if (name == "fire") {
      return standardOptions(mode);
    } else if (name == "blue fire") {
      return standardOptions(mode);
    } else if (name == "lava") {
      return standardOptions(mode);
    }
  }

  Widget standardOptions(mode) {
    // print("b. " +
    //     mode.modeName +
    //     ": " +
    //     mode.compatibleDevices.length.toString());

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        // padding: EdgeInsets.only(top: 15.0),
        itemCount: mode.compatibleDevices.length,
        itemBuilder: (BuildContext context, int index) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                mode.compatibleDevices[index],
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.normal,
                ),
              ),
              Switch(
                onChanged: (bool value) {
                  print("Changing to: " + value.toString());
                  String name = mode.compatibleDevices[index];
                  if (value) {
                    setState(() {
                      if (name == "All") {
                        // update all the boards
                        for (var c in mode.compatibleDevices) {
                          deviceList[c].setMode(mode.modeName.toLowerCase());
                        }
                        print("Yippy");
                      } else {
                        deviceList[name].setMode(mode.modeName.toLowerCase());
                        if (deviceList[name] != "off") {
                          deviceList["All"].setMode("n/a");
                        }
                      }
                      sendRequest(name, mode.modeName.toLowerCase());
                    });
                  }
                },
                value: mode.compatibleDevices[index] == "All" &&
                        mode.modeName.toLowerCase() == "off"
                    ? areAllOff()
                    : deviceList[mode.compatibleDevices[index]].getMode() ==
                        mode.modeName.toLowerCase(),
                activeColor: Colors.blue,
              ),
            ],
          );
        },
      ),
    );
  }

  bool areAllOff() {
    bool allOff = true;
    for (int i = 0; i < deviceList.length; i++) {
      if (deviceList[devices[i]].getMode().toLowerCase() != "off") {
        allOff = false;
      }
    }
    // print("areAllOff() returning: " + allOff.toString());
    return allOff;
  }

  Widget brightnessWidget(mode) {
    return Container(
      child: ListView.builder(
        itemCount: devices.length,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              sliderText(
                  devices[index],
                  deviceList[mode.compatibleDevices[index]].getBrightness(),
                  darkText),
              Slider(
                value:
                    deviceList[mode.compatibleDevices[index]].getBrightness(),
                min: 0,
                max: 255,
                label: deviceList[mode.compatibleDevices[index]]
                    .getBrightness()
                    .round()
                    .toString(),
                onChanged: (double value) {
                  setState(() {
                    deviceList[mode.compatibleDevices[index]]
                        .setBrightness(value);
                  });
                },
                onChangeEnd: (double value) {
                  sendBrightness(
                      devices[index].toLowerCase(),
                      deviceList[mode.compatibleDevices[index]]
                          .getBrightness()
                          .round()
                          .toString());
                },
                activeColor: Colors.grey[800],
                inactiveColor: Colors.grey[300],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget rgbOption(mode) {
    return Container(
      // height: 50,
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: mode.compatibleDevices.length,
        itemBuilder: (BuildContext context, int index) {
          return ExpandableNotifier(
            child: Container(
              padding: EdgeInsets.only(
                left: 10,
                right: 10,
                bottom: 5,
              ),
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.all(Radius.circular(10.0)),
              // ),
              // color: index % 2 == 0 ? Colors.orange : Colors.red,
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: Container(
                  // decoration: BoxDecoration(
                  //   gradient: LinearGradient(
                  //     begin: Alignment.topLeft,
                  //     end: Alignment.bottomRight,
                  //     colors: [Colors.blue[300], Colors.blue[100]],
                  //   ),
                  //   borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  // ),
                  color: pageBackgroundColor,
                  child: ScrollOnExpand(
                    scrollOnExpand: true,
                    scrollOnCollapse: false,
                    child: ExpandablePanel(
                      theme: const ExpandableThemeData(
                        headerAlignment: ExpandablePanelHeaderAlignment.center,
                        tapBodyToCollapse: true,
                      ),
                      header: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.only(
                            top: 10, bottom: 10, left: 15, right: 10),
                        child: Text(
                          deviceList[mode.compatibleDevices[index]].getName(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                              fontFamily: 'Roboto'),
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                      expanded: Column(
                        children: [
                          sliderText(
                              "Red",
                              deviceList[mode.compatibleDevices[index]]
                                  .getRed(),
                              slider_text_red),
                          Slider(
                            value: deviceList[mode.compatibleDevices[index]]
                                .getRed(),
                            min: 0,
                            max: 255,
                            label: deviceList[mode.compatibleDevices[index]]
                                .getRed()
                                .round()
                                .toString(),
                            onChanged: (double value) {
                              setState(() {
                                deviceList[mode.compatibleDevices[index]]
                                    .setRed(value);
                              });
                            },
                            onChangeEnd: (double value) {
                              deviceList[mode.compatibleDevices[index]]
                                  .setMode("rgb");
                              updateRGB(
                                  mode,
                                  deviceList[mode.compatibleDevices[index]]
                                      .getName());
                            },
                            activeColor: Colors.red,
                            inactiveColor: Colors.red[300],
                          ),
                          SizedBox(height: 10),
                          sliderText(
                              "Green",
                              deviceList[mode.compatibleDevices[index]]
                                  .getGreen(),
                              slider_text_green),
                          Slider(
                            value: deviceList[mode.compatibleDevices[index]]
                                .getGreen(),
                            min: 0,
                            max: 255,
                            label: deviceList[mode.compatibleDevices[index]]
                                .getGreen()
                                .round()
                                .toString(),
                            onChanged: (double value) {
                              setState(() {
                                deviceList[mode.compatibleDevices[index]]
                                    .setGreen(value);
                              });
                            },
                            onChangeEnd: (double value) {
                              deviceList[mode.compatibleDevices[index]]
                                  .setMode("rgb");
                              updateRGB(
                                  mode,
                                  deviceList[mode.compatibleDevices[index]]
                                      .getName());
                            },
                            activeColor: Colors.green,
                            inactiveColor: Colors.green[300],
                          ),
                          SizedBox(height: 10),
                          sliderText(
                              "Blue",
                              deviceList[mode.compatibleDevices[index]]
                                  .getBlue(),
                              slider_text_blue),
                          Slider(
                            value: deviceList[mode.compatibleDevices[index]]
                                .getBlue(),
                            min: 0,
                            max: 255,
                            label: deviceList[mode.compatibleDevices[index]]
                                .getBlue()
                                .round()
                                .toString(),
                            onChanged: (double value) {
                              setState(() {
                                deviceList[mode.compatibleDevices[index]]
                                    .setBlue(value);
                              });
                            },
                            onChangeEnd: (double value) {
                              deviceList[mode.compatibleDevices[index]]
                                  .setMode("rgb");
                              updateRGB(
                                  mode,
                                  deviceList[mode.compatibleDevices[index]]
                                      .getName());
                            },
                            activeColor: Colors.blue,
                            inactiveColor: Colors.blue[300],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  _loadData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      // for every device
      for (int i = 0; i < deviceList.length; i++) {
        deviceList[devices[i]].getMode(pref.get(devices[i] + '_mode') ?? "off");
        deviceList[devices[i]]
            .setBrightness(pref.get(devices[i] + '_brightness') ?? "off");
        deviceList[devices[i]].getRed(pref.get(devices[i] + '_red') ?? 0.0);
        deviceList[devices[i]].getGreen(pref.get(devices[i] + '_green') ?? 0.0);
        deviceList[devices[i]].getBlue(pref.get(devices[i] + '_blue') ?? 0.0);
      }
    });
  }

  updateRGB(mode, String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> compatible = mode.compatibleDevices;
    if (name == "All") {
      setState(() {
        for (int i = 0; i < mode.compatibleDevices.length; i++) {
          deviceList[compatible[i]].setRed(deviceList["All"].getRed());
          deviceList[compatible[i]].setGreen(deviceList["All"].getGreen());
          deviceList[compatible[i]].setBlue(deviceList["All"].getBlue());
          deviceList[compatible[i]]
              .setBrightness(deviceList["All"].getBrightness());

          prefs.setDouble(deviceList[compatible[i]].getName() + '_red',
              deviceList[compatible[i]].getRed());
          prefs.setDouble(deviceList[compatible[i]].getName() + '_green',
              deviceList[compatible[i]].getGreen());
          prefs.setDouble(deviceList[compatible[i]].getName() + '_blue',
              deviceList[compatible[i]].getBlue());
          prefs.setDouble(deviceList[compatible[i]].getName() + '_brightness',
              deviceList[compatible[i]].getBrightness());
        }
      });
    } else {
      setState(() {
        prefs.setDouble(
            deviceList[name].getName() + '_red', deviceList[name].getRed());
        prefs.setDouble(
            deviceList[name].getName() + '_green', deviceList[name].getGreen());
        prefs.setDouble(
            deviceList[name].getName() + '_blue', deviceList[name].getBlue());
        prefs.setDouble(deviceList[name].getName() + '_brightness',
            deviceList[name].getBrightness());
      });
    }
    sendRGB(
        name.toLowerCase(),
        deviceList[name].getRed().round().toString(),
        deviceList[name].getGreen().round().toString(),
        deviceList[name].getBlue().round().toString());
  }

  sliderText(String title, double val, Color color) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: 15),
      child: Row(
        children: [
          Text(
            title + ": ",
            style: TextStyle(
                color: color,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto'),
          ),
          Text(
            val.round().toString(),
            style: TextStyle(
                color: color,
                fontSize: 18,
                // fontWeight: FontWeight.bold,
                fontFamily: 'Roboto'),
          ),
        ],
      ),
    );
  }
}
