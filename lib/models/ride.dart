class Ride {
  final double distance;
  final DateTime date;
  final Duration duration;
  final double averageSpeed;
  final double caloriesBurned;

  Ride({
    required this.distance,
    required this.date,
    required this.duration,
    required this.averageSpeed,
    required this.caloriesBurned,
  });

  String get formattedDate =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  Map<String, dynamic> toJson() {
    return {
      'distance': distance,
      'date': date.toIso8601String(),
      'duration': duration.inSeconds,
      'averageSpeed': averageSpeed,
      'caloriesBurned': caloriesBurned,
    };
  }

  factory Ride.fromJson(Map<String, dynamic> json) {
    return Ride(
      distance: json['distance'],
      date: DateTime.parse(json['date']),
      duration: Duration(seconds: json['duration']),
      averageSpeed: json['averageSpeed'],
      caloriesBurned: json['caloriesBurned'],
    );
  }
}
