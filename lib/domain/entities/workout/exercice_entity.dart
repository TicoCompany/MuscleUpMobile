class ExerciseEntity {
  final int id;  // Não é mais final
  String name;
  int? sets;
  int? reps;
  double? weight;
  String? notes;  // Não é mais final

  ExerciseEntity({
    required this.id,
    required this.name,
    this.sets,
    this.reps,
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
