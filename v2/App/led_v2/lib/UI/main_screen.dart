import 'package:flutter/material.dart';
import 'package:led_v2/Data/devices.dart';
import 'package:led_v2/Data/gridCell.dart';
import 'package:led_v2/Data/mode.dart';
import 'package:led_v2/Server%20Communication/http_functions.dart';
import 'package:led_v2/UI/colors.dart';
import 'package:flutter/services.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var deviceList;
  var modeDict; // stores a dictionary of {mode name, Mode}
  var grid;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    modeDict = getModeDict();
    deviceList = getDevices(); // stores a dictionary of {mode name, Mode}
    grid = generateGrid();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: deviceList.length,
      child: Scaffold(
        backgroundColor: pageBackgroundColor,
        appBar: AppBar(
          toolbarHeight: 125.0,
          elevation: 0,
          backgroundColor: pageBackgroundColor,
          centerTitle: false,
          title: Text(
            "LED Control",
            style: TextStyle(
              color: whiteText,
              fontSize: 35.0,
              fontFamily: "Roboto",
              fontWeight: FontWeight.normal,
            ),
          ),
          bottom: PreferredSize(
              child: TabBar(
                isScrollable: true,
                unselectedLabelColor: Colors.white.withOpacity(0.3),
                indicatorColor: Colors.white,
                tabs: List<Widget>.generate(devices.length, (int index) {
                  return new Tab(
                    child: Text(devices[index]),
                  );
                }),
              ),
              preferredSize: Size.fromHeight(50.0)),
          actions: <Widget>[
            GestureDetector(
              onTap: () {
                // navigate to "Add Devices" page
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Icon(Icons.settings),
              ),
            ),
          ],
        ),
        body: TabBarView(
          children: <Widget>[
            // All
            scrollViewModes(0),
            // Bed
            scrollViewModes(1),
            // Case
            scrollViewModes(2),
            // Desk
            scrollViewModes(3),
            // Door
            scrollViewModes(4),
            // Lego Sian
            scrollViewModes(5),
            // Maya
            scrollViewModes(6),
            // RC Lambo
            scrollViewModes(7),
          ],
        ),
      ),
    );
  }

  Widget scrollViewModes(int index) {
    return Container(
      decoration: BoxDecoration(
        color: pageBackgroundColor,
      ),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              scrollDirection: Axis.vertical,
              children: compatibleModes[index]
                  .map((mode) => cardTemplate(
                      context, deviceList[devices[index]], modeDict[mode]))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget cardTemplate(context, Device device, Mode mode) {
    if (mode.modeName == 'Cell') {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: mode.background,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(30.0),
          ),
        ),
        padding: EdgeInsets.only(
          top: 20.0,
          bottom: 10.0,
          left: 20.0,
          right: 20.0,
        ),
        margin: EdgeInsets.all(10.0),
        // cell picker ------------------------
        child: Container(
          height: 680,
          child: Column(
            children: [
              SizedBox(
                height: 5,
              ),
              sliderText("Row", device.getCell()[0].toDouble(), whiteText),
              Slider(
                value: device.getCell()[0].toDouble(),
                min: 0,
                max: 8,
                label: device.getCell()[0].round().toString(),
                onChanged: (double value) {
                  setState(() {
                    // device.setCellRow(value.toInt());
                  });
                },
                onChangeEnd: (double value) {
                  // mark that the specified row is targeted for a request
                  device.setCellRow(value.toInt());
                  // display on the grid that this row is chosen
                  // if the column was already selected, mark an individual cell
                  print('Marking row');
                  markRow(grid, device);
                  // print to console what cell was chosen
                  print(device.getCell());
                  // row = value;
                  // highlight selected row - TODO
                },
                activeColor: Colors.grey[800],
                inactiveColor: Colors.grey[300],
              ),
              sliderText("Column", device.getCell()[1].toDouble(), whiteText),
              Slider(
                value: device.getCell()[1].toDouble(),
                min: 0,
                max: 10,
                label: device.getCell()[1].round().toString(),
                onChanged: (double value) {
                  setState(() {
                    // device.setCellCol(value.toInt());
                  });
                },
                onChangeEnd: (double value) {
                  // mark that the specified column is targeted for a request
                  device.setCellCol(value.toInt());
                  // display on the grid that this column is chosen
                  // if the row was already selected, mark an individual cell
                  print('Marking column');
                  markColumn(grid, device);
                  // print to console what cell was chosen
                  print(device.getCell());
                  // highlight selected column - TODO
                },
                activeColor: Colors.grey[800],
                inactiveColor: Colors.grey[300],
              ),
              Container(
                height: 275,
                child: GridView.count(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  crossAxisCount: 10,
                  children:
                      // List.generate(80, (index) {
                      //   return Center(
                      //     child: Text(
                      //       '$index',
                      //       style: TextStyle(
                      //         color: whiteText,
                      //       ),
                      //     ),
                      //   );
                      // }),
                      gridWidget(grid),
                ),
              ),
              // rgb sliders --------------------
              Column(
                children: [
                  SizedBox(height: 5),
                  sliderText("Red", device.getRed(), Colors.red.shade900),
                  Slider(
                    value: device.getRed(),
                    min: 0,
                    max: 255,
                    label: device.getRed().round().toString(),
                    onChanged: (double value) {
                      setState(() {
                        device.setRed(value);
                      });
                    },
                    onChangeEnd: (double value) {
                      device.setMode("rgb");
                      // updateRGB(device.getName());
                    },
                    activeColor: Colors.red,
                    inactiveColor: Colors.red[300],
                  ),
                  // SizedBox(height: 5),
                  sliderText("Green", device.getGreen(), slider_text_green),
                  Slider(
                    value: device.getGreen(),
                    min: 0,
                    max: 255,
                    label: device.getGreen().round().toString(),
                    onChanged: (double value) {
                      setState(() {
                        device.setGreen(value);
                      });
                    },
                    onChangeEnd: (double value) {
                      device.setMode("rgb");
                      // updateRGB(device.getName());
                    },
                    activeColor: Colors.green,
                    inactiveColor: Colors.green[300],
                  ),
                  // SizedBox(height: 5),
                  sliderText("Blue", device.getBlue(), slider_text_blue),
                  Slider(
                    value: device.getBlue(),
                    min: 0,
                    max: 255,
                    label: device.getBlue().round().toString(),
                    onChanged: (double value) {
                      setState(() {
                        device.setBlue(value);
                      });
                    },
                    onChangeEnd: (double value) {
                      device.setMode("rgb");
                      // updateRGB(device.getName());
                    },
                    activeColor: Colors.blue,
                    inactiveColor: Colors.blue[300],
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  // for (int i = 0; i < grid.length; i++) {
                  //   print('$i: ' + grid[i].getSelected().toString());
                  // }
                  // print(device.getCell());
                  // print(device.getRGB());
                  var cells = device.getCell();
                  var rgb = device.getRGB();

                  sendCell(cells[0].toString(), cells[1].toString(),
                      rgb[0].toString(), rgb[1].toString(), rgb[2].toString());
                },
                child: Container(
                  height: 35,
                  margin: EdgeInsets.symmetric(
                    horizontal: 85.0,
                  ),
                  decoration: BoxDecoration(
                    color: slider_text_blue,
                    borderRadius: BorderRadius.all(
                      Radius.circular(30.0),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Send',
                      style: TextStyle(
                        color: whiteText,
                        fontSize: 16.5,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else if (mode.modeName == "RGB") {
      return Container(
        height: 270,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: mode.background,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(30.0),
          ),
        ),
        padding: EdgeInsets.all(20.0),
        margin: EdgeInsets.all(10.0),
        child: Column(
          // rgb sliders
          children: [
            SizedBox(height: 5),
            sliderText("Red", device.getRed(), Colors.red.shade900),
            Slider(
              value: device.getRed(),
              min: 0,
              max: 255,
              label: device.getRed().round().toString(),
              onChanged: (double value) {
                setState(() {
                  device.setRed(value);
                });
              },
              onChangeEnd: (double value) {
                device.setMode("rgb");
                sendRGB(
                    device.deviceName,
                    device.getRed().round().toString(),
                    device.getGreen().round().toString(),
                    device.getBlue().round().toString());
              },
              activeColor: Colors.red,
              inactiveColor: Colors.red[300],
            ),
            // SizedBox(height: 5),
            sliderText("Green", device.getGreen(), slider_text_green),
            Slider(
              value: device.getGreen(),
              min: 0,
              max: 255,
              label: device.getGreen().round().toString(),
              onChanged: (double value) {
                setState(() {
                  device.setGreen(value);
                });
              },
              onChangeEnd: (double value) {
                device.setMode("rgb");
                sendRGB(
                    device.deviceName,
                    device.getRed().round().toString(),
                    device.getGreen().round().toString(),
                    device.getBlue().round().toString());
              },
              activeColor: Colors.green,
              inactiveColor: Colors.green[300],
            ),
            // SizedBox(height: 5),
            sliderText("Blue", device.getBlue(), slider_text_blue),
            Slider(
              value: device.getBlue(),
              min: 0,
              max: 255,
              label: device.getBlue().round().toString(),
              onChanged: (double value) {
                setState(() {
                  device.setBlue(value);
                });
              },
              onChangeEnd: (double value) {
                device.setMode("rgb");
                sendRGB(
                    device.deviceName,
                    device.getRed().round().toString(),
                    device.getGreen().round().toString(),
                    device.getBlue().round().toString());
              },
              activeColor: Colors.blue,
              inactiveColor: Colors.blue[300],
            ),
          ],
        ),
      );
    } else {
      return GestureDetector(
        onTap: () {
          if (device.getName() == 'Lego Sian') {
            if (device.getMode() == "off") {
              device.setMode("on");
              sendMode("sian", "on");
            } else {
              device.setMode("off");
              sendMode("sian", "off");
            }
          } else {
            device.setMode(mode.modeName);
            sendMode(device.getName(), mode.modeName);
          }
        },
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: mode.background,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(30.0),
            ),
          ),
          padding: EdgeInsets.all(20.0),
          margin: EdgeInsets.all(10.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              mode.modeName,
              style: TextStyle(
                color: mode.modeName == "Brightness" ? darkText : Colors.white,
                fontSize: 30.0,
                fontFamily: "Roboto",
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ),
      );
    }
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

  Widget rgbSliders(device) {
    return Column(
      children: [
        sliderText("Red", device.getRed(), slider_text_red),
        Slider(
          value: device.getRed(),
          min: 0,
          max: 255,
          label: device.getRed().round().toString(),
          onChanged: (double value) {
            setState(() {
              device.setRed(value);
            });
          },
          onChangeEnd: (double value) {
            device.setMode("rgb");
            // updateRGB(device.getName());
          },
          activeColor: Colors.red,
          inactiveColor: Colors.red[300],
        ),
        SizedBox(height: 10),
        sliderText("Green", device.getGreen(), slider_text_green),
        Slider(
          value: device.getGreen(),
          min: 0,
          max: 255,
          label: device.getGreen().round().toString(),
          onChanged: (double value) {
            setState(() {
              device.setGreen(value);
            });
          },
          onChangeEnd: (double value) {
            device.setMode("rgb");
            // updateRGB(device.getName());
          },
          activeColor: Colors.green,
          inactiveColor: Colors.green[300],
        ),
        SizedBox(height: 10),
        sliderText("Blue", device.getBlue(), slider_text_blue),
        Slider(
          value: device.getBlue(),
          min: 0,
          max: 255,
          label: device.getBlue().round().toString(),
          onChanged: (double value) {
            setState(() {
              device.setBlue(value);
            });
          },
          onChangeEnd: (double value) {
            device.setMode("rgb");
            // updateRGB(device.getName());
          },
          activeColor: Colors.blue,
          inactiveColor: Colors.blue[300],
        ),
        sliderText("Brightness", device.getBrightness(), whiteText),
        Slider(
          value: device.getBrightness(),
          min: 0,
          max: 255,
          label: device.getBrightness().round().toString(),
          onChanged: (double value) {
            setState(() {
              device.setBrightness(value);
            });
          },
          onChangeEnd: (double value) {
            // setBrightnessSharedPref(
            // device.deviceName.toLowerCase(), device.getBrightness());
          },
          activeColor: Colors.grey[800],
          inactiveColor: Colors.grey[300],
        ),
      ],
    );
  }

  // List<Widget> gridWidget(List<GridCell> g) {
  //   List<Widget> w = [];
  //   for (int i = 0; i < g.length; i++) {
  //     w.add(Center(
  //       child: Text(
  //         g[i].getCoordinates().toString(),
  //         style: TextStyle(
  //           color: g[i].getSelected() ? whiteText : darkText,
  //         ),
  //       ),
  //     ));
  //   }
  //   return w;
  // }
  List<Widget> gridWidget(List<GridCell> g) {
    List<Widget> w = [];
    for (int i = 0; i < g.length; i++) {
      w.add(Container(
        margin: EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: g[i].getSelected() ? slider_text_blue : Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ),
        ),
      ));
    }
    return w;
  }
}
