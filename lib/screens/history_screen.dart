import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bike_gps_tracker/models/gps_data.dart';
import 'package:intl/intl.dart';
import 'package:bike_gps_tracker/screens/ride_detail_screen.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  String _formatDate(String dateString) {
    DateTime date = DateTime.parse(dateString);
    return DateFormat('MMM d, y - HH:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final gpsData = Provider.of<GPSData>(context);

    print(
        'Number of rides in history: ${gpsData.rideHistory.length}'); // Add this line

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ride History'),
        backgroundColor: const Color(0xFFFFD700),
      ),
      body: gpsData.rideHistory.isEmpty
          ? const Center(child: Text('No rides recorded yet.'))
          : ListView.builder(
              itemCount: gpsData.rideHistory.length,
              itemBuilder: (context, index) {
                final ride = gpsData.rideHistory[index];
                return ListTile(
                  title: Text('Ride on ${_formatDate(ride['date'])}'),
                  subtitle: Text(
                      'Distance: ${ride['distance'].toStringAsFixed(2)} km'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RideDetailScreen(ride: ride),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
