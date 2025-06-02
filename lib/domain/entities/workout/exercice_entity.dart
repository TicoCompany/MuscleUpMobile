
class ExerciseEntity {
  final int id;
  final String name;
  final int sets;
  final int reps;
  final double? weight;
  final String? notes;

  const ExerciseEntity({
    required this.id,
    required this.name,
    required this.sets,
    required this.reps,
    this.weight,
    this.notes,
  });

  factory ExerciseEntity.fromMap(Map<String, dynamic> map) {
    return ExerciseEntity(
      id: map['id'],
      name: map['name'],
      sets: map['sets'],
      reps: map['reps'],
      weight: map['weight']?.toDouble(),
      notes: map['notes'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'sets': sets,
      'reps': reps,
      'weight': weight,
      'notes': notes,
    };
  }
}
