class CurrentRideData {
  final int id;
  final double distance;
  final double time;
  final double speed;
  final double maxSpeed;
  final double ascension;
  final double descent;
  final double calories;

  const CurrentRideData({
    required this.id,
    required this.distance,
    required this.time,
    required this.speed,
    required this.maxSpeed,
    required this.ascension,
    required this.descent,
    required this.calories,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'distance': distance,
      'time': time,
      'speed': speed,
      'maxSpeed': maxSpeed,
      'ascension': ascension,
      'descent': descent,
      'calories': calories,
    };
  }

  factory CurrentRideData.fromMap(Map<String, dynamic> map) {
    return CurrentRideData(
      id: map['id'] as int,
      distance: map['distance'] as double,
      time: map['time'] as double,
      speed: map['speed'] as double,
      maxSpeed: map['maxSpeed'] as double,
      ascension: map['ascension'] as double,
      descent: map['descent'] as double,
      calories: map['calories'] as double,
    );
  }

  CurrentRideData copyWith({
    int? id,
    double? distance,
    double? time,
    double? speed,
    double? maxSpeed,
    double? ascension,
    double? descent,
    double? calories,
  }) {
    return CurrentRideData(
      id: id ?? this.id,
      distance: distance ?? this.distance,
      time: time ?? this.time,
      speed: speed ?? this.speed,
      maxSpeed: maxSpeed ?? this.maxSpeed,
      ascension: ascension ?? this.ascension,
      descent: descent ?? this.descent,
      calories: calories ?? this.calories,
    );
  }
}
