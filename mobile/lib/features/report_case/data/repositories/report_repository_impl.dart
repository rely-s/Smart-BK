import 'package:uuid/uuid.dart';
import '../../../../core/constants/enums.dart';
import '../../../../core/security/crypto_helper.dart';
import '../../domain/entities/incident_report_entity.dart';
import '../../domain/repositories/report_repository.dart';

class ReportRepositoryImpl implements ReportRepository {
  static const _uuid = Uuid();

  final List<IncidentReportEntity> _reports = [
    IncidentReportEntity(
      id: 'rep-001',
      ticketNumber: 'BK-REP-202611-0081',
      reporterUserId: null,
      reporterName: null,
      isAnonymous: true,
      schoolId: 'a11bbd91-382a-4389-a541-11910cf90001',
      schoolName: 'SMAN 1 Padang',
      incidentType: IncidentType.cyberBullying,
      incidentDate: DateTime.now().subtract(const Duration(days: 2)),
      location: 'Grup Chat WhatsApp Kelas & Kolom Komentar Media Sosial',
      chronology: 'Terdapat akun tiruan yang menyebarkan editan foto dan fitnah yang merendahkan saya secara berulang di medsos.',
      urgencyLevel: CaseUrgency.high,
      status: CaseStatus.investigation,
      assignedCounselorId: 'e28bbd91-382a-4389-a541-11910cf90022',
      assignedCounselorName: 'Dra. Rahmi Fadilah, M.Pd., Kons.',
      attachmentPaths: ['screenshot_chat_01.jpg'],
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    IncidentReportEntity(
      id: 'rep-002',
      ticketNumber: 'BK-REP-202611-0092',
      reporterUserId: 'e28bbd91-382a-4389-a541-11910cf90011',
      reporterName: 'Fajri Pratama',
      isAnonymous: false,
      schoolId: 'a11bbd91-382a-4389-a541-11910cf90001',
      schoolName: 'SMAN 1 Padang',
      incidentType: IncidentType.extortion,
      incidentDate: DateTime.now().subtract(const Duration(days: 4)),
      location: 'Lorong Kantin Belakang Sekolah',
      chronology: 'Dimintai uang saku secara paksa setiap istirahat kedua oleh oknum kakak kelas.',
      urgencyLevel: CaseUrgency.medium,
      status: CaseStatus.verified,
      assignedCounselorId: 'e28bbd91-382a-4389-a541-11910cf90022',
      assignedCounselorName: 'Dra. Rahmi Fadilah, M.Pd., Kons.',
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
      updatedAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  @override
  Future<IncidentReportEntity> submitReport({
    required String? reporterUserId,
    required String? reporterName,
    required bool isAnonymous,
    required String schoolId,
    required String schoolName,
    required IncidentType incidentType,
    required DateTime incidentDate,
    required String location,
    required String chronology,
    required CaseUrgency urgencyLevel,
    List<String> attachments = const [],
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));

    // Kebijakan Privasi Ketat (UU PDP): Jika anonim, kosongkan seluruh metadata identitas
    final sanitizedReporterId = isAnonymous ? null : reporterUserId;
    final sanitizedReporterName = isAnonymous ? null : reporterName;

    final report = IncidentReportEntity(
      id: _uuid.v4(),
      ticketNumber: CryptoHelper.generateTicketNumber(),
      reporterUserId: sanitizedReporterId,
      reporterName: sanitizedReporterName,
      isAnonymous: isAnonymous,
      schoolId: schoolId,
      schoolName: schoolName,
      incidentType: incidentType,
      incidentDate: incidentDate,
      location: location,
      chronology: chronology,
      urgencyLevel: urgencyLevel,
      status: CaseStatus.submitted,
      attachmentPaths: attachments,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _reports.insert(0, report);
    return report;
  }

  @override
  Future<IncidentReportEntity?> getReportByTicket(String ticketNumber) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final normalized = ticketNumber.trim().toUpperCase();
    final matches = _reports.where((r) => r.ticketNumber.toUpperCase() == normalized);
    return matches.isNotEmpty ? matches.first : null;
  }

  @override
  Future<List<IncidentReportEntity>> getReportsForSchool(String schoolId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _reports.where((r) => r.schoolId == schoolId).toList();
  }

  @override
  Future<IncidentReportEntity> updateReportStatus({
    required String reportId,
    required CaseStatus newStatus,
    required String actorUserId,
    required String actionSummary,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _reports.indexWhere((r) => r.id == reportId);
    if (index == -1) {
      throw Exception('Laporan tidak ditemukan');
    }

    final old = _reports[index];
    final updated = IncidentReportEntity(
      id: old.id,
      ticketNumber: old.ticketNumber,
      reporterUserId: old.reporterUserId,
      reporterName: old.reporterName,
      isAnonymous: old.isAnonymous,
      schoolId: old.schoolId,
      schoolName: old.schoolName,
      incidentType: old.incidentType,
      incidentDate: old.incidentDate,
      location: old.location,
      chronology: old.chronology,
      urgencyLevel: old.urgencyLevel,
      status: newStatus,
      assignedCounselorId: old.assignedCounselorId,
      assignedCounselorName: old.assignedCounselorName,
      attachmentPaths: old.attachmentPaths,
      createdAt: old.createdAt,
      updatedAt: DateTime.now(),
    );

    _reports[index] = updated;
    return updated;
  }
}

