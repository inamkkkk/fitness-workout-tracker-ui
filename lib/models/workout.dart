class Workout {
  final int? id;
  final String name;
  final String createdAt;

  Workout({this.id, required this.name, required this.createdAt});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'createdAt': createdAt,
    };
  }

  factory Workout.fromMap(Map<String, dynamic> map) {
    return Workout(
      id: map['id'],
      name: map['name'],
      createdAt: map['createdAt'],
    );
  }
}
