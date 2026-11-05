import 'package:equatable/equatable.dart';
import '../../../../core/constants/enums.dart';

class CounselingSessionEntity extends Equatable {
  final String id;
  final String studentUserId;
  final String studentName;
  final String counselorUserId;
  final String counselorName;
  final ChannelType channel;
  final SessionStatus status;
  final DateTime scheduledStart;
  final DateTime? actualStart;
  final DateTime? actualEnd;
  final String? webrtcRoomToken;

  const CounselingSessionEntity({
    required this.id,
    required this.studentUserId,
    required this.studentName,
    required this.counselorUserId,
    required this.counselorName,
    required this.channel,
    required this.status,
    required this.scheduledStart,
    this.actualStart,
    this.actualEnd,
    this.webrtcRoomToken,
  });

  @override
  List<Object?> get props => [
        id,
        studentUserId,
        studentName,
        counselorUserId,
        counselorName,
        channel,
        status,
        scheduledStart,
        actualStart,
        actualEnd,
        webrtcRoomToken,
      ];
}

class CounselingMessageEntity extends Equatable {
  final String id;
  final String sessionId;
  final String senderUserId;
  final String senderName;
  final String content; // Dekripsi plain-text di sisi klien
  final DateTime sentAt;
  final bool isRead;
  final bool isMine;

  const CounselingMessageEntity({
    required this.id,
    required this.sessionId,
    required this.senderUserId,
    required this.senderName,
    required this.content,
    required this.sentAt,
    this.isRead = false,
    this.isMine = false,
  });

  @override
  List<Object?> get props => [
        id,
        sessionId,
        senderUserId,
        senderName,
        content,
        sentAt,
        isRead,
        isMine,
      ];
}

class ClinicalNoteEntity extends Equatable {
  final String id;
  final String sessionId;
  final String counselorUserId;
  final String subjective;
  final String objective;
  final String assessment;
  final String intervention;
  final String? parentSharedSummary;
  final DateTime finalizedAt;

  const ClinicalNoteEntity({
    required this.id,
    required this.sessionId,
    required this.counselorUserId,
    required this.subjective,
    required this.objective,
    required this.assessment,
    required this.intervention,
    this.parentSharedSummary,
    required this.finalizedAt,
  });

  @override
  List<Object?> get props => [
        id,
        sessionId,
        counselorUserId,
        subjective,
        objective,
        assessment,
        intervention,
        parentSharedSummary,
        finalizedAt,
      ];
}

