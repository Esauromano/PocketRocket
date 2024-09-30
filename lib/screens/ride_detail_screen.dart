import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bike_gps_tracker/models/gps_data.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class RideDetailScreen extends StatelessWidget {
  final Map<String, dynamic> ride;

  const RideDetailScreen({super.key, required this.ride});

  @override
  Widget build(BuildContext context) {
    List<LatLng> points = [];
    if (ride['positions'] != null) {
      points = (ride['positions'] as List<dynamic>)
          .map((pos) =>
              LatLng(pos['latitude'] as double, pos['longitude'] as double))
          .toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ride Details'),
        backgroundColor: const Color(0xFFFFD700),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareRideGPX(context),
          ),
        ],
      ),
      body: Column(
        children: [
          if (points.isNotEmpty)
            Expanded(
              flex: 1,
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: points.first,
                  initialZoom: 13.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: const ['a', 'b', 'c'],
                  ),
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: points,
                        strokeWidth: 4.0,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                ],
              ),
            )
          else
            const Expanded(
              flex: 1,
              child: Center(
                child: Text('No map data available for this ride'),
              ),
            ),
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Date: ${_formatDate(ride['date'])}',
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text('Distance: ${ride['distance'].toStringAsFixed(2)} km',
                        style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(height: 8),
                    Text('Duration: ${_formatDuration(ride['duration'])}',
                        style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(height: 8),
                    Text(
                        'Max Speed: ${ride['maxSpeed'].toStringAsFixed(2)} km/h',
                        style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(height: 8),
                    Text(
                        'Calories Burned: ${ride['caloriesBurned'].toStringAsFixed(2)} kcal',
                        style: Theme.of(context).textTheme.bodyLarge),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    DateTime date = DateTime.parse(dateString);
    return DateFormat('MMMM d, y - HH:mm').format(date);
  }

  String _formatDuration(int seconds) {
    final duration = Duration(seconds: seconds);
    return '${duration.inHours}:${(duration.inMinutes % 60).toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  Future<void> _shareRideGPX(BuildContext context) async {
    final gpsData = Provider.of<GPSData>(context, listen: false);
    final gpxContent = gpsData.generateGPX(ride);

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/ride_${ride['date']}.gpx');
    await file.writeAsString(gpxContent);

    await Share.shareXFiles([XFile(file.path)],
        text: 'Check out my bike ride!');
  }
}
