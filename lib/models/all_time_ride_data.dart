class AllTimeRideData {
  final double totalDistance;
  final double totalTime;
  final double averageSpeed;
  final double maxSpeed;
  final double totalAscension;
  final double totalDescent;
  final double totalCalories;

  const AllTimeRideData({
    required this.totalDistance,
    required this.totalTime,
    required this.averageSpeed,
    required this.maxSpeed,
    required this.totalAscension,
    required this.totalDescent,
    required this.totalCalories,
  });

  Map<String, double> toMap() {
    return {
      'totalDistance': totalDistance,
      'totalTime': totalTime,
      'averageSpeed': averageSpeed,
      'maxSpeed': maxSpeed,
      'totalAscension': totalAscension,
      'totalDescent': totalDescent,
      'totalCalories': totalCalories,
    };
  }

  factory AllTimeRideData.fromMap(Map<String, double> map) {
    return AllTimeRideData(
      totalDistance: map['totalDistance']!,
      totalTime: map['totalTime']!,
      averageSpeed: map['averageSpeed']!,
      maxSpeed: map['maxSpeed']!,
      totalAscension: map['totalAscension']!,
      totalDescent: map['totalDescent']!,
      totalCalories: map['totalCalories']!,
    );
  }

  AllTimeRideData copyWith({
    double? totalDistance,
    double? totalTime,
    double? averageSpeed,
    double? maxSpeed,
    double? totalAscension,
    double? totalDescent,
    double? totalCalories,
  }) {
    return AllTimeRideData(
      totalDistance: totalDistance ?? this.totalDistance,
      totalTime: totalTime ?? this.totalTime,
      averageSpeed: averageSpeed ?? this.averageSpeed,
      maxSpeed: maxSpeed ?? this.maxSpeed,
      totalAscension: totalAscension ?? this.totalAscension,
      totalDescent: totalDescent ?? this.totalDescent,
      totalCalories: totalCalories ?? this.totalCalories,
    );
  }
}
