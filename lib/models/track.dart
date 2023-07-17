class Track {
  DateTime date;
  double distance;
  double speed;
  String time;
  int steps;
  String routeImageURL;
  String routeImagePath;
  String place;

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

  void updateDistanceAndSpeed(double trackDistance, double trackSpeed) {
    distance += trackDistance;
    speed = trackSpeed;
  }

  void updateTrack(
      String trackTime, String trackPlace, String url, String path) {
    time = trackTime;
    place = trackPlace;
    routeImagePath = path;
    routeImageURL = url;
    date = DateTime.now();
    steps = (distance * 1312.336).round();
  }
}
