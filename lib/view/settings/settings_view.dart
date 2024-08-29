import 'package:flutter/material.dart';
import 'package:mhconnect/common/color_extension.dart';
import 'package:mhconnect/common/connect_util.dart';
import 'package:provider/provider.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  // Controllers for TextFields
  late TextEditingController _ssidController;
  late TextEditingController _bgColorController;
  late TextEditingController _wifiPassController;
  late TextEditingController _uiColorController;
  late TextEditingController _timezoneController;

  late ConnectUtil connectUtil;
  bool isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();

    connectUtil = ConnectUtil();

    // Fetch initial settings from the server once
    connectUtil.updateSettings().then((_) {
      // Initialize controllers with fetched settings data
      _ssidController = TextEditingController(text: connectUtil.settingsCfg.wifiSSID);
      _bgColorController = TextEditingController(text: connectUtil.settingsCfg.bgColor);
      _wifiPassController = TextEditingController(text: connectUtil.settingsCfg.wifiPass);
      _uiColorController = TextEditingController(text: connectUtil.settingsCfg.uiColor);
      _timezoneController = TextEditingController(text: connectUtil.settingsCfg.timezone);

      setState(() {
        isLoading = false; // Data is loaded
      });
    });
  }

  @override
  void dispose() {
    _ssidController.dispose();
    _bgColorController.dispose();
    _wifiPassController.dispose();
    _uiColorController.dispose();
    _timezoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: connectUtil,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Settings",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () {
                // Save settings to server
                connectUtil.modifySettings();
              },
              icon: Icon(
                Icons.save,
                color: TColor.unselect,
                size: 25,
              ),
            )
          ],
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator()) // Show loading while fetching data
            : Consumer<ConnectUtil>(
                builder: (context, connectUtil, child) {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 30),
                          // 24-hour Clock Toggle
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "24h Clock",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: TColor.text,
                                ),
                              ),
                              Switch(
                                value: connectUtil.settingsCfg.h24Clock == "true",
                                onChanged: (bool value) {
                                  connectUtil.set24hClock(value);
                                },
                                activeColor: TColor.primary,
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),
                          // WiFi SSID TextField
                          Text(
                            "WiFi SSID",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: TColor.text,
                            ),
                          ),
                          TextField(
                            controller: _ssidController,
                            decoration: const InputDecoration(
                              hintText: "Enter WiFi SSID",
                            ),
                            onChanged: (String value) {
                              connectUtil.setWifiSSID(value);
                            },
                          ),

                          const SizedBox(height: 20),
                          // Background Color TextField
                          Text(
                            "Background Color",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: TColor.text,
                            ),
                          ),
                          TextField(
                            controller: _bgColorController,
                            decoration: const InputDecoration(
                              hintText: "Enter Background Color",
                            ),
                            onChanged: (String value) {
                              connectUtil.setBgColor(value);
                            },
                          ),

                          const SizedBox(height: 20),
                          // Volume Slider
                          Text(
                            "Volume",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: TColor.text,
                            ),
                          ),
                          Slider(
                            value: double.parse(connectUtil.settingsCfg.volume),
                            min: 0,
                            max: 10,
                            onChanged: (double value) {
                              connectUtil.setVolume(value);
                            },
                            activeColor: TColor.primary,
                          ),

                          const SizedBox(height: 20),
                          // WiFi Password TextField
                          Text(
                            "WiFi Password",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: TColor.text,
                            ),
                          ),
                          TextField(
                            controller: _wifiPassController,
                            decoration: const InputDecoration(
                              hintText: "Enter WiFi Password",
                            ),
                            onChanged: (String value) {
                              connectUtil.setWifiPass(value);
                            },
                            obscureText: true,
                          ),

                          const SizedBox(height: 20),
                          // UI Color TextField
                          Text(
                            "UI Color",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: TColor.text,
                            ),
                          ),
                          TextField(
                            controller: _uiColorController,
                            decoration: const InputDecoration(
                              hintText: "Enter UI Color",
                            ),
                            onChanged: (String value) {
                              connectUtil.setUiColor(value);
                            },
                          ),

                          const SizedBox(height: 20),
                          // UI Sound Toggle
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "UI Sound",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: TColor.text,
                                ),
                              ),
                              Switch(
                                value: connectUtil.settingsCfg.uiSound == "true",
                                onChanged: (bool value) {
                                  connectUtil.setUiSound(value);
                                },
                                activeColor: TColor.primary,
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),
                          // Timezone TextField
                          Text(
                            "Timezone",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: TColor.text,
                            ),
                          ),
                          TextField(
                            controller: _timezoneController,
                            decoration: const InputDecoration(
                              hintText: "Enter Timezone",
                            ),
                            onChanged: (String value) {
                              connectUtil.setTimezone(value);
                            },
                          ),

                          const SizedBox(height: 20),
                          // Sync Clock Toggle
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Sync Clock",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: TColor.text,
                                ),
                              ),
                              Switch(
                                value: connectUtil.settingsCfg.syncClock == "true",
                                onChanged: (bool value) {
                                  connectUtil.setSyncClock(value);
                                },
                                activeColor: TColor.primary,
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),
                          // Language Dropdown Menu
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Language",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: TColor.text,
                                ),
                              ),
                              DropdownButton<String>(
                                value: connectUtil.settingsCfg.language,
                                items: <String>['en', 'zh', 'ja']
                                    .map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    connectUtil.setLanguage(newValue);
                                  }
                                },
                              ),
                            ],
                          ),

                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
