import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class GPSData extends ChangeNotifier {
  bool _isTracking = false;
  double _distance = 0;
  double _currentSpeed = 0;
  double _maxSpeed = 0;
  double _caloriesBurned = 0;
  Duration _elapsedTime = Duration.zero;
  double _latitude = 0;
  double _longitude = 0;
  List<Position> _positions = [];
  Timer? _elapsedTimeTimer;
  List<Map<String, dynamic>> _rideHistory = [];

  // Settings
  bool _isDarkMode = false;
  String _distanceUnit = 'km';
  int _gpsUpdateInterval = 10;

  // Getters
  bool get isTracking => _isTracking;
  double get distance => _distance;
  double get currentSpeed => _currentSpeed;
  double get maxSpeed => _maxSpeed;
  double get caloriesBurned => _caloriesBurned;
  Duration get elapsedTime => _elapsedTime;
  double get latitude => _latitude;
  double get longitude => _longitude;
  List<Map<String, dynamic>> get rideHistory => _rideHistory;
  bool get isDarkMode => _isDarkMode;
  String get distanceUnit => _distanceUnit;
  int get gpsUpdateInterval => _gpsUpdateInterval;

  // Setter
  set isTracking(bool value) {
    _isTracking = value;
    notifyListeners();
  }

  GPSData() {
    _loadRideHistory();
    _loadSettings();
  }

  void startTracking() {
    isTracking = true;
    _positions = []; // Clear previous positions
    _distance = 0;
    _elapsedTime = Duration.zero;
    _currentSpeed = 0;
    _maxSpeed = 0;
    _caloriesBurned = 0;

    _elapsedTimeTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _elapsedTime += const Duration(seconds: 1);
      notifyListeners();
    });

    // Start location updates here
    // ...

    notifyListeners();
  }

  void stopTracking() {
    _isTracking = false;
    _elapsedTimeTimer?.cancel();
    notifyListeners();
  }

  void reset() {
    _distance = 0;
    _currentSpeed = 0;
    _maxSpeed = 0;
    _caloriesBurned = 0;
    _elapsedTime = Duration.zero;
    _latitude = 0;
    _longitude = 0;
    _positions.clear();
    notifyListeners();
  }

  double _calculateCalories() {
    // This is a simplified calculation. You might want to use a more accurate formula.
    double weightKg =
        70; // Assume 70kg rider weight. You could make this configurable.
    double metValue = 8.0; // MET value for cycling (moderate effort)
    double durationHours = _elapsedTime.inSeconds / 3600;
    return (metValue * weightKg * durationHours);
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  void addRideToHistory() {
    final ride = {
      'date': DateTime.now().toIso8601String(),
      'distance': distance,
      'duration': elapsedTime.inSeconds,
      'maxSpeed': maxSpeed,
      'caloriesBurned': caloriesBurned,
      'positions': _positions
          .map((p) => {
                'latitude': p.latitude,
                'longitude': p.longitude,
                'altitude': p.altitude,
                'timestamp': p.timestamp.toIso8601String(),
              })
          .toList(),
    };
    _rideHistory.add(ride);
    _saveRideHistory();
    notifyListeners();
  }

  Future<void> _loadRideHistory() async {
    final prefs = await SharedPreferences.getInstance();
    String? historyJson = prefs.getString('ride_history');
    if (historyJson != null) {
      List<dynamic> decodedList = json.decode(historyJson);
      _rideHistory = decodedList.cast<Map<String, dynamic>>();
      notifyListeners();
    }
    if (isTracking) {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied');
      }

      _isTracking = true;
      _positions.clear();
      _distance = 0;
      _elapsedTime = Duration.zero;
      _currentSpeed = 0;
      _maxSpeed = 0;
      _caloriesBurned = 0;

      _elapsedTimeTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        _elapsedTime += const Duration(seconds: 1);
        notifyListeners();
      });

      void updatePosition(Position position) {
        _latitude = position.latitude;
        _longitude = position.longitude;

        if (_positions.isNotEmpty) {
          _distance += Geolocator.distanceBetween(
                _positions.last.latitude,
                _positions.last.longitude,
                position.latitude,
                position.longitude,
              ) /
              1000; // Convert to kilometers
        }

        _positions.add(position);
        _currentSpeed = position.speed * 3.6; // Convert m/s to km/h
        _maxSpeed = _currentSpeed > _maxSpeed ? _currentSpeed : _maxSpeed;
        _caloriesBurned = _calculateCalories();

        notifyListeners();
      }

      Geolocator.getPositionStream(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
          timeLimit: Duration(seconds: _gpsUpdateInterval),
        ),
      ).listen(updatePosition);

      notifyListeners();
    }
  }

  Future<void> _saveRideHistory() async {
    final prefs = await SharedPreferences.getInstance();
    String historyJson = json.encode(_rideHistory);
    await prefs.setString('ride_history', historyJson);
  }

  Future<void> clearRideHistory() async {
    _rideHistory.clear();
    await _saveRideHistory();
    notifyListeners();
  }

  // Settings methods
  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    _saveSettings();
    notifyListeners();
  }

  void setDistanceUnit(String unit) {
    if (unit == 'km' || unit == 'mi') {
      _distanceUnit = unit;
      _saveSettings();
      notifyListeners();
    }
  }

  void setGpsUpdateInterval(int interval) {
    if (interval > 0) {
      _gpsUpdateInterval = interval;
      _saveSettings();
      notifyListeners();
    }
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    _distanceUnit = prefs.getString('distanceUnit') ?? 'km';
    _gpsUpdateInterval = prefs.getInt('gpsUpdateInterval') ?? 10;
    notifyListeners();
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
    await prefs.setString('distanceUnit', _distanceUnit);
    await prefs.setInt('gpsUpdateInterval', _gpsUpdateInterval);
  }

  String generateGPX(Map<String, dynamic> ride) {
    final DateFormat dateFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
    final startTime = DateTime.parse(ride['date']);
    final endTime = startTime.add(Duration(seconds: ride['duration']));

    String gpx = '''<?xml version="1.0" encoding="UTF-8"?>
<gpx version="1.1" creator="BikeGPSTracker" xmlns="http://www.topografix.com/GPX/1/1">
  <metadata>
    <name>Bike Ride</name>
    <time>${dateFormat.format(startTime)}</time>
  </metadata>
  <trk>
    <name>Bike Ride on ${DateFormat('yyyy-MM-dd').format(startTime)}</name>
    <trkseg>
''';

    if (ride['positions'] != null && ride['positions'] is Iterable) {
      for (var position in ride['positions']) {
        if (position is Map<String, dynamic> &&
            position['latitude'] != null &&
            position['longitude'] != null) {
          gpx +=
              '''      <trkpt lat="${position['latitude']}" lon="${position['longitude']}">
        <ele>${position['altitude'] ?? 0}</ele>
        <time>${dateFormat.format(position['timestamp'] ?? startTime)}</time>
      </trkpt>
''';
        }
      }
    }

    gpx += '''    </trkseg>
  </trk>
</gpx>''';

    return gpx;
  }
}
