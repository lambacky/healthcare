class Track {
  final DateTime date;
  final double distance;
  final double speed;
  final String time;
  final int steps;
  final String routeImageURL;
  final String routeImagePath;
  final String place;

  Track(
      {required this.date,
      required this.distance,
      required this.speed,
      required this.time,
      required this.steps,
      required this.routeImageURL,
      required this.routeImagePath,
      required this.place});

  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
        date: json['date'].toDate(),
        distance: json['distance'],
        speed: json['speed'],
        time: json['time'],
        steps: json['steps'],
        routeImageURL: json['routeImageURL'],
        routeImagePath: json['routeImagePath'],
        place: json['place']);
  }

  Map<String, dynamic> toJson() {
    return {
      "date": date,
      "distance": distance,
      "speed": speed,
      "time": time,
      "steps": steps,
      "routeImageURL": routeImageURL,
      "routeImagePath": routeImagePath,
      "place": place
    };
  }
}
