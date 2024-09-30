import 'package:bike_gps_tracker/models/oldgps.old';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TopNumbersScreen extends StatelessWidget {
  const TopNumbersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gpsData = Provider.of<GPSData>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Numbers'),
        backgroundColor: const Color(0xFFFFD700),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildTopDataTile('Total Rides', gpsData.totalRides.toString()),
            _buildTopDataTile('Total Distance',
                '${gpsData.totalDistance.toStringAsFixed(2)} m'),
            _buildTopDataTile('Total Time', _formatDuration(gpsData.totalTime)),
            _buildTopDataTile(
                'Max Speed', '${gpsData.maxSpeed.toStringAsFixed(2)} km/h'),
            _buildTopDataTile('Average Speed',
                _arrowIndicator(gpsData.currentSpeed, gpsData.previousSpeed)),
            _buildTopDataTile('Total Ascension',
                '${gpsData.totalAscension.toStringAsFixed(2)} m'),
            _buildTopDataTile('Total Descent',
                '${gpsData.totalDescent.toStringAsFixed(2)} m'),
            _buildTopDataTile('Total Calories',
                '${gpsData.totalCalories.toStringAsFixed(2)} kcal'),
          ],
        ),
      ),
    );
  }

  Widget _buildTopDataTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  String _arrowIndicator(double current, double previous) {
    if (current > previous) {
      return '↑ ${current.toStringAsFixed(2)} km/h';
    } else if (current < previous) {
      return '↓ ${current.toStringAsFixed(2)} km/h';
    } else {
      return '${current.toStringAsFixed(2)} km/h';
    }
  }

  String _formatDuration(Duration duration) {
    final int hours = duration.inHours;
    final int minutes = duration.inMinutes % 60;
    final int seconds = duration.inSeconds % 60;

    if (hours > 0) {
      return '${hours.toStringAsFixed(0)}h ${minutes.toStringAsFixed(0)}m ${seconds.toStringAsFixed(0)}s';
    } else if (minutes > 0) {
      return '${minutes.toStringAsFixed(0)}m ${seconds.toStringAsFixed(0)}s';
    } else {
      return '${seconds.toStringAsFixed(0)}s';
    }
  }
}
