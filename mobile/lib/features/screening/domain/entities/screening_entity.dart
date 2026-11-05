import 'package:equatable/equatable.dart';
import '../../../../core/constants/enums.dart';

class QuestionOptionEntity extends Equatable {
  final String id;
  final String label;
  final int value;

  const QuestionOptionEntity({
    required this.id,
    required this.label,
    required this.value,
  });

  @override
  List<Object?> get props => [id, label, value];
}

class ScreeningQuestionEntity extends Equatable {
  final String id;
  final int orderIndex;
  final String questionText;
  final bool isReversedScore;
  final List<QuestionOptionEntity> options;

  const ScreeningQuestionEntity({
    required this.id,
    required this.orderIndex,
    required this.questionText,
    this.isReversedScore = false,
    required this.options,
  });

  @override
  List<Object?> get props => [id, orderIndex, questionText, isReversedScore, options];
}

class ScreeningInstrumentEntity extends Equatable {
  final String id;
  final String code;
  final String title;
  final InstrumentCategory category;
  final String description;
  final List<ScreeningQuestionEntity> questions;

  const ScreeningInstrumentEntity({
    required this.id,
    required this.code,
    required this.title,
    required this.category,
    required this.description,
    required this.questions,
  });

  @override
  List<Object?> get props => [id, code, title, category, description, questions];
}

class ScreeningAttemptEntity extends Equatable {
  final String id;
  final String studentUserId;
  final String instrumentId;
  final String instrumentTitle;
  final int totalScore;
  final RiskLevel calculatedRisk;
  final bool alertTriggered;
  final DateTime completedAt;
  final Map<String, int> answers; // questionId -> selectedValue

  const ScreeningAttemptEntity({
    required this.id,
    required this.studentUserId,
    required this.instrumentId,
    required this.instrumentTitle,
    required this.totalScore,
    required this.calculatedRisk,
    required this.alertTriggered,
    required this.completedAt,
    required this.answers,
  });

  @override
  List<Object?> get props => [
        id,
        studentUserId,
        instrumentId,
        instrumentTitle,
        totalScore,
        calculatedRisk,
        alertTriggered,
        completedAt,
        answers,
      ];
}

