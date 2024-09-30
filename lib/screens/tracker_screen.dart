import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bike_gps_tracker/models/gps_data.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:bike_gps_tracker/screens/gpx_file_manager.dart';

class TrackerScreen extends StatefulWidget {
  const TrackerScreen({super.key});

  @override
  State<TrackerScreen> createState() => TrackerScreenState();
}

class TrackerScreenState extends State<TrackerScreen> {
  Timer? _timer;
  int _countdown = 3;
  bool _isCountingDown = false;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _startCountdown(GPSData gpsData) async {
    setState(() {
      _isCountingDown = true;
      _countdown = 3;
    });

    for (int i = 3; i > 0; i--) {
      await _playBeep();
      setState(() {
        _countdown = i;
      });
      await Future.delayed(const Duration(seconds: 1));
    }

    setState(() {
      _isCountingDown = false;
    });

    await _startTracking(gpsData);
  }

  Future<void> _startTracking(GPSData gpsData) async {
    try {
      gpsData.startTracking(); // Changed from await gpsData.startTracking();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tracking started')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to start tracking: $e')),
      );
    }
  }

  Future<void> _playBeep() async {
    try {
      await _audioPlayer.play(AssetSource('audio/beep.mp3'));
    } catch (e) {
      debugPrint('Error playing audio: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bike GPS Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.folder),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const GPXFileManager()),
              );
            },
          ),
        ],
        backgroundColor: const Color(0xFFFFD700),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFFFFD700),
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.map),
              title: const Text('Tracker'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('History'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/history');
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/settings');
              },
            ),
          ],
        ),
      ),
      body: Consumer<GPSData>(
        builder: (context, gpsData, _) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_isCountingDown)
                  Text(
                    '$_countdown',
                    style: Theme.of(context).textTheme.displayLarge,
                  )
                else ...[
                  if (gpsData.isTracking)
                    const Text(
                      'Tracking Active',
                      style: TextStyle(color: Colors.green, fontSize: 20),
                    ),
                  Text(
                    'Coordinates:',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    'Lat: ${gpsData.latitude.toStringAsFixed(6)}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    'Lon: ${gpsData.longitude.toStringAsFixed(6)}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Speed: ${gpsData.currentSpeed.toStringAsFixed(2)} km/h',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Distance: ${gpsData.distance.toStringAsFixed(2)} km',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Time: ${gpsData.formatDuration(gpsData.elapsedTime)}',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Calories: ${gpsData.caloriesBurned.toStringAsFixed(2)} kcal',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: gpsData.isTracking
                      ? () {
                          gpsData.stopTracking();
                          gpsData.addRideToHistory();
                          gpsData.reset();
                        }
                      : () => _startCountdown(gpsData),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        gpsData.isTracking ? Colors.red : Colors.green,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 20),
                  ),
                  child: Text(gpsData.isTracking ? 'Stop' : 'Start'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
