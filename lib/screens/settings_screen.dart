import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bike_gps_tracker/models/gps_data.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: const Color(0xFFFFD700),
      ),
      body: Consumer<GPSData>(
        builder: (context, gpsData, child) {
          return ListView(
            children: [
              SwitchListTile(
                title: const Text('Dark Mode'),
                value: gpsData.isDarkMode,
                onChanged: (value) {
                  gpsData.toggleDarkMode();
                },
              ),
              ListTile(
                title: const Text('Distance Unit'),
                trailing: DropdownButton<String>(
                  value: gpsData.distanceUnit,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      gpsData.setDistanceUnit(newValue);
                    }
                  },
                  items: ['km', 'mi'].map((String unit) {
                    return DropdownMenuItem<String>(
                      value: unit,
                      child: Text(unit),
                    );
                  }).toList(),
                ),
              ),
              ListTile(
                title: const Text('GPS Update Interval'),
                trailing: DropdownButton<int>(
                  value: gpsData.gpsUpdateInterval,
                  onChanged: (int? newValue) {
                    if (newValue != null) {
                      gpsData.setGpsUpdateInterval(newValue);
                    }
                  },
                  items: [5, 10, 15, 30, 60].map((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text('$value seconds'),
                    );
                  }).toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
