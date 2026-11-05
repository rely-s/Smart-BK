import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/enums.dart';
import '../../domain/entities/counseling_entity.dart';
import '../../domain/repositories/counseling_repository.dart';

// EVENTS
abstract class CounselingEvent extends Equatable {
  const CounselingEvent();
  @override
  List<Object?> get props => [];
}

class FetchUserSessionsEvent extends CounselingEvent {
  final String userId;
  final bool isCounselor;

  const FetchUserSessionsEvent({required this.userId, required this.isCounselor});

  @override
  List<Object?> get props => [userId, isCounselor];
}

class OpenSessionChatEvent extends CounselingEvent {
  final String sessionId;
  final String currentUserId;

  const OpenSessionChatEvent({required this.sessionId, required this.currentUserId});

  @override
  List<Object?> get props => [sessionId, currentUserId];
}

class SendChatMessageEvent extends CounselingEvent {
  final String sessionId;
  final String senderUserId;
  final String senderName;
  final String text;

  const SendChatMessageEvent({
    required this.sessionId,
    required this.senderUserId,
    required this.senderName,
    required this.text,
  });

  @override
  List<Object?> get props => [sessionId, senderUserId, senderName, text];
}

class RequestNewSessionEvent extends CounselingEvent {
  final String studentUserId;
  final String studentName;
  final String counselorUserId;
  final String counselorName;
  final ChannelType channel;
  final DateTime scheduledStart;

  const RequestNewSessionEvent({
    required this.studentUserId,
    required this.studentName,
    required this.counselorUserId,
    required this.counselorName,
    required this.channel,
    required this.scheduledStart,
  });

  @override
  List<Object?> get props => [
        studentUserId,
        studentName,
        counselorUserId,
        counselorName,
        channel,
        scheduledStart,
      ];
}

class SaveSoapNoteEvent extends CounselingEvent {
  final String sessionId;
  final String counselorUserId;
  final String subjective;
  final String objective;
  final String assessment;
  final String intervention;
  final String? parentSharedSummary;

  const SaveSoapNoteEvent({
    required this.sessionId,
    required this.counselorUserId,
    required this.subjective,
    required this.objective,
    required this.assessment,
    required this.intervention,
    this.parentSharedSummary,
  });

  @override
  List<Object?> get props => [
        sessionId,
        counselorUserId,
        subjective,
        objective,
        assessment,
        intervention,
        parentSharedSummary,
      ];
}

class PanicExitTriggeredEvent extends CounselingEvent {}

// STATES
abstract class CounselingState extends Equatable {
  const CounselingState();
  @override
  List<Object?> get props => [];
}

class CounselingInitial extends CounselingState {}

class CounselingLoading extends CounselingState {}

class SessionsLoadedState extends CounselingState {
  final List<CounselingSessionEntity> sessions;
  const SessionsLoadedState(this.sessions);
  @override
  List<Object?> get props => [sessions];
}

class ChatActiveState extends CounselingState {
  final String sessionId;
  final List<CounselingMessageEntity> messages;

  const ChatActiveState({required this.sessionId, required this.messages});

  @override
  List<Object?> get props => [sessionId, messages];
}

class PanicExitState extends CounselingState {}

class SoapNoteSavedState extends CounselingState {
  final ClinicalNoteEntity note;
  const SoapNoteSavedState(this.note);
  @override
  List<Object?> get props => [note];
}

class CounselingErrorState extends CounselingState {
  final String message;
  const CounselingErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

// BLOC
class CounselingBloc extends Bloc<CounselingEvent, CounselingState> {
  final CounselingRepository _repository;

  CounselingBloc({required CounselingRepository repository})
      : _repository = repository,
        super(CounselingInitial()) {
    on<FetchUserSessionsEvent>(_onFetchSessions);
    on<OpenSessionChatEvent>(_onOpenChat);
    on<SendChatMessageEvent>(_onSendMessage);
    on<RequestNewSessionEvent>(_onRequestSession);
    on<SaveSoapNoteEvent>(_onSaveSoapNote);
    on<PanicExitTriggeredEvent>(_onPanicExit);
  }

  Future<void> _onFetchSessions(
    FetchUserSessionsEvent event,
    Emitter<CounselingState> emit,
  ) async {
    emit(CounselingLoading());
    try {
      final sessions = await _repository.getSessionsForUser(
        userId: event.userId,
        isCounselor: event.isCounselor,
      );
      emit(SessionsLoadedState(sessions));
    } catch (e) {
      emit(CounselingErrorState('Gagal memuat sesi konseling: ${e.toString()}'));
    }
  }

  Future<void> _onOpenChat(
    OpenSessionChatEvent event,
    Emitter<CounselingState> emit,
  ) async {
    emit(CounselingLoading());
    try {
      final messages = await _repository.getMessages(event.sessionId, event.currentUserId);
      emit(ChatActiveState(sessionId: event.sessionId, messages: messages));
    } catch (e) {
      emit(CounselingErrorState('Gagal membuka ruang pesan: ${e.toString()}'));
    }
  }

  Future<void> _onSendMessage(
    SendChatMessageEvent event,
    Emitter<CounselingState> emit,
  ) async {
    try {
      await _repository.sendMessage(
        sessionId: event.sessionId,
        senderUserId: event.senderUserId,
        senderName: event.senderName,
        content: event.text,
      );
      final messages = await _repository.getMessages(event.sessionId, event.senderUserId);
      emit(ChatActiveState(sessionId: event.sessionId, messages: messages));
    } catch (e) {
      emit(CounselingErrorState('Gagal mengirim pesan: ${e.toString()}'));
    }
  }

  Future<void> _onRequestSession(
    RequestNewSessionEvent event,
    Emitter<CounselingState> emit,
  ) async {
    emit(CounselingLoading());
    try {
      await _repository.requestSession(
        studentUserId: event.studentUserId,
        studentName: event.studentName,
        counselorUserId: event.counselorUserId,
        counselorName: event.counselorName,
        channel: event.channel,
        scheduledStart: event.scheduledStart,
      );
      add(FetchUserSessionsEvent(userId: event.studentUserId, isCounselor: false));
    } catch (e) {
      emit(CounselingErrorState('Gagal mengajukan jadwal konseling: ${e.toString()}'));
    }
  }

  Future<void> _onSaveSoapNote(
    SaveSoapNoteEvent event,
    Emitter<CounselingState> emit,
  ) async {
    emit(CounselingLoading());
    try {
      final note = await _repository.saveClinicalNote(
        sessionId: event.sessionId,
        counselorUserId: event.counselorUserId,
        subjective: event.subjective,
        objective: event.objective,
        assessment: event.assessment,
        intervention: event.intervention,
        parentSharedSummary: event.parentSharedSummary,
      );
      emit(SoapNoteSavedState(note));
    } catch (e) {
      emit(CounselingErrorState('Gagal menyimpan catatan SOAP: ${e.toString()}'));
    }
  }

  void _onPanicExit(
    PanicExitTriggeredEvent event,
    Emitter<CounselingState> emit,
  ) {
    emit(PanicExitState());
  }
}

