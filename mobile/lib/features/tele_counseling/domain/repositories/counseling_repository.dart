import '../../../../core/constants/enums.dart';
import '../entities/counseling_entity.dart';

abstract class CounselingRepository {
  Future<List<CounselingSessionEntity>> getSessionsForUser({
    required String userId,
    required bool isCounselor,
  });

  Future<CounselingSessionEntity> requestSession({
    required String studentUserId,
    required String studentName,
    required String counselorUserId,
    required String counselorName,
    required ChannelType channel,
    required DateTime scheduledStart,
  });

  Future<List<CounselingMessageEntity>> getMessages(String sessionId, String currentUserId);

  Future<CounselingMessageEntity> sendMessage({
    required String sessionId,
    required String senderUserId,
    required String senderName,
    required String content,
  });

  Future<ClinicalNoteEntity?> getClinicalNote(String sessionId);

  Future<ClinicalNoteEntity> saveClinicalNote({
    required String sessionId,
    required String counselorUserId,
    required String subjective,
    required String objective,
    required String assessment,
    required String intervention,
    String? parentSharedSummary,
  });
}

