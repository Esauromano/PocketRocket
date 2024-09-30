import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bike_gps_tracker/models/gps_data.dart';

class SessionHistoryScreen extends StatelessWidget {
  const SessionHistoryScreen({super.key});

  String _formatDuration(int seconds) {
    Duration duration = Duration(seconds: seconds);
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    final gpsData = Provider.of<GPSData>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Session History'),
        backgroundColor: const Color(0xFFFFD700),
      ),
      body: ListView.builder(
        itemCount: gpsData.rideHistory.length,
        itemBuilder: (context, index) {
          final ride = gpsData.rideHistory[index];
          return ListTile(
            title: Text('Session ${index + 1}'),
            subtitle: Text(
              'Distance: ${ride['distance'].toStringAsFixed(2)} km\n'
              'Time: ${_formatDuration(ride['duration'])}\n'
              'Max Speed: ${ride['maxSpeed'].toStringAsFixed(2)} km/h\n'
              'Calories: ${ride['caloriesBurned'].toStringAsFixed(2)} kcal',
            ),
            onTap: () {
              // Open session details if needed
            },
          );
        },
      ),
    );
  }
}
