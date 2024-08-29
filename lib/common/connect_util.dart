import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:mhconnect/config.dart';

class ConnectUtil extends ChangeNotifier {
  String url = MH_URL;
  final SysInfo _sysInfo = SysInfo();
  SysInfo get sysInfo => _sysInfo;
  final SettingsCfg _settingsCfg = SettingsCfg();
  SettingsCfg get settingsCfg => _settingsCfg;

  Future<String> fetchDataFromUrl(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return 'Error: ${response.statusCode}';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }

  Future<void> updateSysInfo() async {
    var jsonStr = await fetchDataFromUrl('http://$url:5000/sysinfo');
    if (jsonStr.isNotEmpty) {
      Map<String, dynamic> json = jsonDecode(jsonStr);
      sysInfo.readJson(json);
    }
    notifyListeners();
  }

  Future<void> updateSettings() async {
    var jsonStr = await fetchDataFromUrl('http://$url:5000/settings');
    if (jsonStr.isNotEmpty) {
      Map<String, dynamic> json = jsonDecode(jsonStr);
      settingsCfg.readJson(json);
    }
    notifyListeners();
  }

  Future<void> modifySettings() async {
    try {
      final response = await http.post(
        Uri.parse('http://$url:5000/settings_modify'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: _settingsCfg.toJson(),
      );

      if (response.statusCode == 200) {
        notifyListeners(); // Update listeners on success
      } else {
        print('Failed to save settings. Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error saving settings: $e');
    }
  }

  // Setter methods to update settings
  void set24hClock(bool value) {
    _settingsCfg.h24Clock = value ? "true" : "false";
    notifyListeners();
  }

  void setWifiSSID(String value) {
    _settingsCfg.wifiSSID = value;
    notifyListeners();
  }

  void setBgColor(String value) {
    _settingsCfg.bgColor = value;
    notifyListeners();
  }

  void setVolume(double value) {
    _settingsCfg.volume = value.toString();
    notifyListeners();
  }

  void setWifiPass(String value) {
    _settingsCfg.wifiPass = value;
    notifyListeners();
  }

  void setUiColor(String value) {
    _settingsCfg.uiColor = value;
    print(value);
    print(_settingsCfg.uiColor);
    notifyListeners();
  }

  void setUiSound(bool value) {
    _settingsCfg.uiSound = value ? "true" : "false";
    notifyListeners();
  }

  void setTimezone(String value) {
    _settingsCfg.timezone = value;
    notifyListeners();
  }

  void setSyncClock(bool value) {
    _settingsCfg.syncClock = value ? "true" : "false";
    notifyListeners();
  }

  void setLanguage(String value) {
    _settingsCfg.language = value;
    notifyListeners();
  }
}



class SysInfo {
  String freeMemory, totalMemory, freeSpace, totalSpace;
  String wifiSSID, wifiIP;
  String batteryStatus, batteryLevel;
  String version, build;

  SysInfo({
    this.freeMemory = "0",
    this.totalMemory = "0",
    this.freeSpace = "0",
    this.totalSpace = "0",
    this.wifiSSID = "0",
    this.wifiIP = "0",
    this.batteryStatus = "0",
    this.batteryLevel = "0",
    this.version = "0",
    this.build = "0",
  });

  void readJson(Map<String, dynamic> json) {
    freeMemory = json['free_memory'];
    totalMemory = json['total_memory'];
    freeSpace = json['free_space'];
    totalSpace = json['total_space'];
    wifiSSID = json['wifi_ssid'];
    wifiIP = json['wifi_ip'];
    batteryStatus = json['battery_status'];
    batteryLevel = json['battery_level'];
    version = json['version'];
    build = json['build'];
  }
}

class SettingsCfg {
  String h24Clock, wifiSSID, bgColor, volume, wifiPass;
  String uiColor, uiSound, timezone, syncClock, language;

  SettingsCfg({
    this.h24Clock = "false",
    this.wifiSSID = "",
    this.bgColor = "2051",
    this.volume = "2",
    this.wifiPass = "",
    this.uiColor = "65430",
    this.uiSound = "true",
    this.timezone = "0",
    this.syncClock = "true",
    this.language = "en",
  });

  void readJson(Map<String, dynamic> json) {
    h24Clock = json['24h_clock'];
    wifiSSID = json['wifi_ssid'];
    bgColor = json['bg_color'];
    volume = json['volume'];
    wifiPass = json['wifi_pass'];
    uiColor = json['ui_color'];
    uiSound = json['ui_sound'];
    timezone = json['timezone'];
    syncClock = json['sync_clock'];
    language = json['language'];
  }

  String toJson() {
    return jsonEncode({
      "24h_clock": h24Clock,
      "wifi_ssid": wifiSSID,
      "bg_color": bgColor,
      "volume": volume,
      "wifi_pass": wifiPass,
      "ui_color": uiColor,
      "ui_sound": uiSound,
      "timezone": timezone,
      "sync_clock": syncClock,
      "language": language,
    });
  }
}
