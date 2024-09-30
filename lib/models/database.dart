import 'package:bike_gps_tracker/models/all_time_ride_data.dart';
import 'package:bike_gps_tracker/models/currentride_data.dart';
import 'package:sqflite/sqflite.dart';

Future<void> createTable(Database db) async {
  await db.execute('''
    CREATE TABLE current_ride (
      id INTEGER PRIMARY KEY,
      start_time TEXT,
      end_time TEXT,
      distance REAL,
      time REAL,
      speed REAL,
      max_speed REAL,
      ascension REAL,
      descent REAL,
      calories REAL
    );
  ''');

  await db.execute('''
    CREATE TABLE all_time_ride (
      total_distance REAL,
      total_time REAL,
      average_speed REAL,
      max_speed REAL,
      total_ascension REAL,
      total_descent REAL,
      total_calories REAL
    );
  ''');
}

Future<void> insertCurrentRideData(Database db, CurrentRideData data) async {
  await db.insert('current_ride', data.toMap());
}

Future<void> insertAllTimeRideData(Database db, AllTimeRideData data) async {
  await db.insert('all_time_ride', data.toMap());
}
