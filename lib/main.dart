import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bike_gps_tracker/models/gps_data.dart';
import 'package:bike_gps_tracker/screens/tracker_screen.dart';
import 'package:bike_gps_tracker/screens/history_screen.dart';
import 'package:bike_gps_tracker/screens/settings_screen.dart';
import 'package:bike_gps_tracker/screens/gpx_file_manager.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => GPSData(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GPSData(),
      child: Consumer<GPSData>(
        builder: (context, gpsData, child) {
          return MaterialApp(
            title: 'Bike GPS Tracker',
            theme: ThemeData(
              primarySwatch: Colors.yellow,
              brightness: Brightness.light,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: const TrackerScreen(),
            routes: {
              '/history': (context) => const HistoryScreen(),
              '/settings': (context) => const SettingsScreen(),
              '/gpx_files': (context) =>
                  const GPXFileManager(), // Add this line
            },
          );
        },
      ),
    );
  }
}
