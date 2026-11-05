import 'package:equatable/equatable.dart';
import '../../../../core/constants/enums.dart';

class IncidentReportEntity extends Equatable {
  final String id;
  final String ticketNumber;
  final String? reporterUserId;
  final String? reporterName;
  final bool isAnonymous;
  final String schoolId;
  final String schoolName;
  final IncidentType incidentType;
  final DateTime incidentDate;
  final String location;
  final String chronology;
  final CaseUrgency urgencyLevel;
  final CaseStatus status;
  final String? assignedCounselorId;
  final String? assignedCounselorName;
  final List<String> attachmentPaths;
  final DateTime createdAt;
  final DateTime updatedAt;

  const IncidentReportEntity({
    required this.id,
    required this.ticketNumber,
    this.reporterUserId,
    this.reporterName,
    required this.isAnonymous,
    required this.schoolId,
    required this.schoolName,
    required this.incidentType,
    required this.incidentDate,
    required this.location,
    required this.chronology,
    required this.urgencyLevel,
    required this.status,
    this.assignedCounselorId,
    this.assignedCounselorName,
    this.attachmentPaths = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        ticketNumber,
        reporterUserId,
        reporterName,
        isAnonymous,
        schoolId,
        schoolName,
        incidentType,
        incidentDate,
        location,
        chronology,
        urgencyLevel,
        status,
        assignedCounselorId,
        assignedCounselorName,
        attachmentPaths,
        createdAt,
        updatedAt,
      ];
}

