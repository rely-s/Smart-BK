import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/enums.dart';
import '../../domain/entities/incident_report_entity.dart';
import '../../domain/repositories/report_repository.dart';

// EVENTS
abstract class ReportEvent extends Equatable {
  const ReportEvent();
  @override
  List<Object?> get props => [];
}

class SubmitReportEvent extends ReportEvent {
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
  final List<String> attachments;

  const SubmitReportEvent({
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
    this.attachments = const [],
  });

  @override
  List<Object?> get props => [
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
        attachments,
      ];
}

class TrackTicketEvent extends ReportEvent {
  final String ticketNumber;
  const TrackTicketEvent(this.ticketNumber);
  @override
  List<Object?> get props => [ticketNumber];
}

class FetchSchoolReportsEvent extends ReportEvent {
  final String schoolId;
  const FetchSchoolReportsEvent(this.schoolId);
  @override
  List<Object?> get props => [schoolId];
}

class UpdateCaseStatusEvent extends ReportEvent {
  final String reportId;
  final CaseStatus newStatus;
  final String actorUserId;
  final String actionSummary;

  const UpdateCaseStatusEvent({
    required this.reportId,
    required this.newStatus,
    required this.actorUserId,
    required this.actionSummary,
  });

  @override
  List<Object?> get props => [reportId, newStatus, actorUserId, actionSummary];
}

class ResetReportEvent extends ReportEvent {}

// STATES
abstract class ReportState extends Equatable {
  const ReportState();
  @override
  List<Object?> get props => [];
}

class ReportInitial extends ReportState {}

class ReportLoading extends ReportState {}

class ReportSubmittedSuccess extends ReportState {
  final IncidentReportEntity report;
  const ReportSubmittedSuccess(this.report);
  @override
  List<Object?> get props => [report];
}

class ReportTicketFound extends ReportState {
  final IncidentReportEntity report;
  const ReportTicketFound(this.report);
  @override
  List<Object?> get props => [report];
}

class ReportTicketNotFound extends ReportState {
  final String ticketNumber;
  const ReportTicketNotFound(this.ticketNumber);
  @override
  List<Object?> get props => [ticketNumber];
}

class SchoolReportsLoaded extends ReportState {
  final List<IncidentReportEntity> reports;
  const SchoolReportsLoaded(this.reports);
  @override
  List<Object?> get props => [reports];
}

class ReportError extends ReportState {
  final String message;
  const ReportError(this.message);
  @override
  List<Object?> get props => [message];
}

// BLOC
class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final ReportRepository _repository;

  ReportBloc({required ReportRepository repository})
      : _repository = repository,
        super(ReportInitial()) {
    on<SubmitReportEvent>(_onSubmitReport);
    on<TrackTicketEvent>(_onTrackTicket);
    on<FetchSchoolReportsEvent>(_onFetchSchoolReports);
    on<UpdateCaseStatusEvent>(_onUpdateCaseStatus);
    on<ResetReportEvent>((event, emit) => emit(ReportInitial()));
  }

  Future<void> _onSubmitReport(
    SubmitReportEvent event,
    Emitter<ReportState> emit,
  ) async {
    emit(ReportLoading());
    try {
      final report = await _repository.submitReport(
        reporterUserId: event.reporterUserId,
        reporterName: event.reporterName,
        isAnonymous: event.isAnonymous,
        schoolId: event.schoolId,
        schoolName: event.schoolName,
        incidentType: event.incidentType,
        incidentDate: event.incidentDate,
        location: event.location,
        chronology: event.chronology,
        urgencyLevel: event.urgencyLevel,
        attachments: event.attachments,
      );
      emit(ReportSubmittedSuccess(report));
    } catch (e) {
      emit(ReportError('Gagal mengirimkan laporan pengaduan: ${e.toString()}'));
    }
  }

  Future<void> _onTrackTicket(
    TrackTicketEvent event,
    Emitter<ReportState> emit,
  ) async {
    emit(ReportLoading());
    try {
      final report = await _repository.getReportByTicket(event.ticketNumber);
      if (report != null) {
        emit(ReportTicketFound(report));
      } else {
        emit(ReportTicketNotFound(event.ticketNumber));
      }
    } catch (e) {
      emit(ReportError('Gagal melacak tiket pengaduan: ${e.toString()}'));
    }
  }

  Future<void> _onFetchSchoolReports(
    FetchSchoolReportsEvent event,
    Emitter<ReportState> emit,
  ) async {
    emit(ReportLoading());
    try {
      final reports = await _repository.getReportsForSchool(event.schoolId);
      emit(SchoolReportsLoaded(reports));
    } catch (e) {
      emit(ReportError('Gagal memuat daftar laporan: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateCaseStatus(
    UpdateCaseStatusEvent event,
    Emitter<ReportState> emit,
  ) async {
    try {
      await _repository.updateReportStatus(
        reportId: event.reportId,
        newStatus: event.newStatus,
        actorUserId: event.actorUserId,
        actionSummary: event.actionSummary,
      );
      add(FetchSchoolReportsEvent(event.reportId));
    } catch (e) {
      emit(ReportError('Gagal memperbarui status kasus: ${e.toString()}'));
    }
  }
}

