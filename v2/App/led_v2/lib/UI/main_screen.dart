import 'package:flutter/material.dart';
import 'package:led_v2/Data/devices.dart';
import 'package:led_v2/UI/colors.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var deviceList = getDevices();

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
          // 'LED Control' text -----------------
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
          // scrolling tab bar ------------------
          Container(
            child: DefaultTabController(
              length: deviceList.length,
              child: TabBar(
                isScrollable: true,
                unselectedLabelColor: Colors.white.withOpacity(0.3),
                indicatorColor: Colors.white,
                tabs: [
                  Tab(
                    child: Text('All'),
                  ),
                  Tab(
                    child: Text('Bed'),
                  ),
                  Tab(
                    child: Text('Case'),
                  ),
                  Tab(
                    child: Text('Desk'),
                  ),
                  Tab(
                    child: Text('Door'),
                  ),
                  Tab(
                    child: Text('Lego Sian'),
                  ),
                  Tab(
                    child: Text('RC Lambo'),
                  )
                ],
              ),
            ),
          ),
          // scrolling column of modes ----------
          TabBarView(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.orange,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.yellow,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.green,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.purple,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
