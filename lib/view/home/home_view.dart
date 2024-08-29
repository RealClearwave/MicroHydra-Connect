import 'package:flutter/material.dart';
import 'package:mhconnect/common/color_extension.dart';
import 'package:mhconnect/common_widget/device_row.dart';
import 'package:mhconnect/view/files/files_view.dart';
import 'package:mhconnect/common_widget/detail_button.dart';
import 'package:mhconnect/common/connect_util.dart';
import 'package:mhconnect/view/settings/settings_view.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int selectPage = 0;
  var pages = <Widget>[
    const HomePage(),
    const SettingsView(),
  ];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ConnectUtil()..updateSysInfo(),
      child: Scaffold(
        body: pages[selectPage],
        bottomNavigationBar: BottomAppBar(
          notchMargin: 8,
          shape: const CircularNotchedRectangle(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    selectPage = 0;
                  });
                },
                icon: Icon(
                  Icons.home_filled,
                  size: 30,
                  color: selectPage == 0 ? TColor.primary : TColor.unselect,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    selectPage = 1;
                  });
                },
                icon: Icon(
                  Icons.settings,
                  size: 30,
                  color: selectPage == 1 ? TColor.primary : TColor.unselect,
                ),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: SizedBox(
          height: 65,
          width: 65,
          child: FittedBox(
            child: FloatingActionButton(
              onPressed: () {},
              child: const Icon(
                Icons.terminal,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectUtil>(
      builder: (context, connectUtil, child) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 70),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Text(
                  "MicroHydra Connect",
                  style: TextStyle(
                      color: TColor.text,
                      fontSize: 28,
                      fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: 35),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: SizedBox(
                  height: 175,
                  child: Row(
                    children: [
                      Expanded(
                        child: DetailCellButton(
                          bgColor: TColor.color5,
                          name: "Free\nMemory",
                          val: connectUtil.sysInfo.freeMemory,
                          icon: Icons.memory,
                          onPressed: () {},
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: DetailCellButton(
                          bgColor: TColor.color6,
                          name: "Free\nSpace",
                          val: connectUtil.sysInfo.freeSpace,
                          icon: Icons.drive_eta,
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: SizedBox(
                  height: 100,
                  child: Row(
                    children: [
                      Expanded(
                        child: DetailCellButton(
                          bgColor: Colors.cyan,
                          name: "File Browser",
                          val: "",
                          icon: Icons.file_copy,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const FilesView(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 35),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    {
                      "icon": Icons.wifi,
                      "name": connectUtil.sysInfo.wifiSSID,
                      "sub_name": connectUtil.sysInfo.wifiIP,
                      "speed": "OK"
                    },
                    {
                      "icon": Icons.battery_charging_full,
                      "name": "Battery",
                      "sub_name": connectUtil.sysInfo.batteryStatus,
                      "speed": connectUtil.sysInfo.batteryLevel
                    },
                    {
                      "icon": Icons.system_security_update,
                      "name": "MicroHydra Version",
                      "sub_name": connectUtil.sysInfo.build,
                      "speed": connectUtil.sysInfo.version
                    },
                  ].map((lObj) {
                    return DeviceRow(lObj: lObj);
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
