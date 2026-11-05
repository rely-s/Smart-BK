import '../../../../core/constants/enums.dart';
import '../entities/incident_report_entity.dart';

abstract class ReportRepository {
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
  });

  Future<IncidentReportEntity?> getReportByTicket(String ticketNumber);

  Future<List<IncidentReportEntity>> getReportsForSchool(String schoolId);

  Future<IncidentReportEntity> updateReportStatus({
    required String reportId,
    required CaseStatus newStatus,
    required String actorUserId,
    required String actionSummary,
  });
}

