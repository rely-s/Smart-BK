import '../entities/screening_entity.dart';

abstract class ScreeningRepository {
  Future<List<ScreeningInstrumentEntity>> getInstruments();
  Future<ScreeningInstrumentEntity> getInstrumentById(String id);
  Future<ScreeningAttemptEntity> submitScreening({
    required String studentUserId,
    required String instrumentId,
    required Map<String, int> answers,
  });
  Future<List<ScreeningAttemptEntity>> getAttemptsByStudent(String studentUserId);
}

