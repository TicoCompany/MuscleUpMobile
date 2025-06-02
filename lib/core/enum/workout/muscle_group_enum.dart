enum MuscleGroupEnum {
  peito,
  costas,
  ombro,
  biceps,
  triceps,
  antebraco,
  abdomen,
  gluteo,
  quadriceps,
  posteriorDeCoxa,
  panturrilha,
  lombar,
  corpoInteiro, // Para exercícios compostos como levantamento terra ou burpee
}

extension MuscleGroupEnumExtension on MuscleGroupEnum {
  String get name {
    switch (this) {
      case MuscleGroupEnum.peito:
        return 'Peito';
      case MuscleGroupEnum.costas:
        return 'Costas';
      case MuscleGroupEnum.ombro:
        return 'Ombro';
      case MuscleGroupEnum.biceps:
        return 'Bíceps';
      case MuscleGroupEnum.triceps:
        return 'Tríceps';
      case MuscleGroupEnum.antebraco:
        return 'Antebraço';
      case MuscleGroupEnum.abdomen:
        return 'Abdômen';
      case MuscleGroupEnum.gluteo:
        return 'Glúteo';
      case MuscleGroupEnum.quadriceps:
        return 'Quadríceps';
      case MuscleGroupEnum.posteriorDeCoxa:
        return 'Posterior de Coxa';
      case MuscleGroupEnum.panturrilha:
        return 'Panturrilha';
      case MuscleGroupEnum.lombar:
        return 'Lombar';
      case MuscleGroupEnum.corpoInteiro:
        return 'Corpo Inteiro';
    }
  }
}
