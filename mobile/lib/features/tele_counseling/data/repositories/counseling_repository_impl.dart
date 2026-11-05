import 'package:uuid/uuid.dart';
import 'package:smart_bk_care/core/constants/enums.dart';
import 'package:smart_bk_care/features/tele_counseling/domain/entities/counseling_entity.dart';
import 'package:smart_bk_care/features/tele_counseling/domain/repositories/counseling_repository.dart';

class CounselingRepositoryImpl implements CounselingRepository {
  static const _uuid = Uuid();

  final List<CounselingSessionEntity> _sessions = [
    CounselingSessionEntity(
      id: 'sess-001',
      studentUserId: 'e28bbd91-382a-4389-a541-11910cf90011',
      studentName: 'Fajri Pratama',
      counselorUserId: 'e28bbd91-382a-4389-a541-11910cf90022',
      counselorName: 'Dra. Rahmi Fadilah, M.Pd., Kons.',
      channel: ChannelType.chat,
      status: SessionStatus.active,
      scheduledStart: DateTime.now().subtract(const Duration(hours: 1)),
      actualStart: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
    CounselingSessionEntity(
      id: 'sess-002',
      studentUserId: 'e28bbd91-382a-4389-a541-11910cf90011',
      studentName: 'Fajri Pratama',
      counselorUserId: 'e28bbd91-382a-4389-a541-11910cf90022',
      counselorName: 'Dra. Rahmi Fadilah, M.Pd., Kons.',
      channel: ChannelType.video,
      status: SessionStatus.completed,
      scheduledStart: DateTime.now().subtract(const Duration(days: 7)),
      actualStart: DateTime.now().subtract(const Duration(days: 7)),
      actualEnd: DateTime.now().subtract(const Duration(days: 7, minutes: -45)),
    ),
  ];

  final Map<String, List<CounselingMessageEntity>> _messages = {
    'sess-001': [
      CounselingMessageEntity(
        id: 'msg-01',
        sessionId: 'sess-001',
        senderUserId: 'e28bbd91-382a-4389-a541-11910cf90022',
        senderName: 'Dra. Rahmi Fadilah, M.Pd., Kons.',
        content: 'Halo Fajri, salam sehat. Dari hasil evaluasi skrining mandiri kemarin, Ibu melihat kamu merasa cukup tegang menghadapi jadwal ujian akhir. Bagaimana keadaanmu sekarang?',
        sentAt: DateTime.now().subtract(const Duration(minutes: 25)),
      ),
      CounselingMessageEntity(
        id: 'msg-02',
        sessionId: 'sess-001',
        senderUserId: 'e28bbd91-382a-4389-a541-11910cf90011',
        senderName: 'Fajri Pratama',
        content: 'Iya Bu, akhir-akhir ini saya susah tidur nyenyak dan sering merasa cemas nilainya tidak memenuhi syarat beasiswa...',
        sentAt: DateTime.now().subtract(const Duration(minutes: 18)),
      ),
      CounselingMessageEntity(
        id: 'msg-03',
        sessionId: 'sess-001',
        senderUserId: 'e28bbd91-382a-4389-a541-11910cf90022',
        senderName: 'Dra. Rahmi Fadilah, M.Pd., Kons.',
        content: 'Sangat wajar merasakan hal tersebut, Fajri. Kamu tidak sendirian. Mari kita buat jadwal belajar bertahap dan latihan relasi pernapasan 4-7-8 yang bisa kamu coba malam ini.',
        sentAt: DateTime.now().subtract(const Duration(minutes: 10)),
      ),
    ],
  };

  final Map<String, ClinicalNoteEntity> _clinicalNotes = {
    'sess-002': ClinicalNoteEntity(
      id: 'cn-001',
      sessionId: 'sess-002',
      counselorUserId: 'e28bbd91-382a-4389-a541-11910cf90022',
      subjective: 'Konseli mengeluhkan ketakutan menghadapi ekspektasi akademik orang tua.',
      objective: 'Konseli tampak kooperatif, artikulasi jelas, namun ada ketegangan gestur tangan.',
      assessment: 'Kecemasan performa akademik tingkat sedang (Non-klinis). Mekanisme koping adaptif masih berkembang.',
      intervention: 'Psikoedukasi restrukturisasi kognitif dan pembagian ritme belajar berkala.',
      parentSharedSummary: 'Siswa diarahkan untuk menjaga pola istirahat yang seimbang menjelang asesmen sumatif.',
      finalizedAt: DateTime.now().subtract(const Duration(days: 7)),
    ),
  };

  @override
  Future<List<CounselingSessionEntity>> getSessionsForUser({
    required String userId,
    required bool isCounselor,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _sessions.where((s) {
      if (isCounselor) {
        return s.counselorUserId == userId;
      } else {
        return s.studentUserId == userId;
      }
    }).toList();
  }

  @override
  Future<CounselingSessionEntity> requestSession({
    required String studentUserId,
    required String studentName,
    required String counselorUserId,
    required String counselorName,
    required ChannelType channel,
    required DateTime scheduledStart,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final session = CounselingSessionEntity(
      id: _uuid.v4(),
      studentUserId: studentUserId,
      studentName: studentName,
      counselorUserId: counselorUserId,
      counselorName: counselorName,
      channel: channel,
      status: SessionStatus.pending,
      scheduledStart: scheduledStart,
    );
    _sessions.insert(0, session);
    return session;
  }

  @override
  Future<List<CounselingMessageEntity>> getMessages(String sessionId, String currentUserId) async {
    await Future.delayed(const Duration(milliseconds: 150));
    final raw = _messages[sessionId] ?? [];
    return raw.map((m) => CounselingMessageEntity(
      id: m.id,
      sessionId: m.sessionId,
      senderUserId: m.senderUserId,
      senderName: m.senderName,
      content: m.content,
      sentAt: m.sentAt,
      isRead: m.isRead,
      isMine: m.senderUserId == currentUserId,
    )).toList();
  }

  @override
  Future<CounselingMessageEntity> sendMessage({
    required String sessionId,
    required String senderUserId,
    required String senderName,
    required String content,
  }) async {
    await Future.delayed(const Duration(milliseconds: 150));
    final msg = CounselingMessageEntity(
      id: _uuid.v4(),
      sessionId: sessionId,
      senderUserId: senderUserId,
      senderName: senderName,
      content: content,
      sentAt: DateTime.now(),
      isMine: true,
    );

    if (!_messages.containsKey(sessionId)) {
      _messages[sessionId] = [];
    }
    _messages[sessionId]!.add(msg);
    return msg;
  }

  @override
  Future<ClinicalNoteEntity?> getClinicalNote(String sessionId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _clinicalNotes[sessionId];
  }

  @override
  Future<ClinicalNoteEntity> saveClinicalNote({
    required String sessionId,
    required String counselorUserId,
    required String subjective,
    required String objective,
    required String assessment,
    required String intervention,
    String? parentSharedSummary,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final note = ClinicalNoteEntity(
      id: _uuid.v4(),
      sessionId: sessionId,
      counselorUserId: counselorUserId,
      subjective: subjective,
      objective: objective,
      assessment: assessment,
      intervention: intervention,
      parentSharedSummary: parentSharedSummary,
      finalizedAt: DateTime.now(),
    );
    _clinicalNotes[sessionId] = note;
    return note;
  }
}
