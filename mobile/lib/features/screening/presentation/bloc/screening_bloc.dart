import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/screening_entity.dart';
import '../../domain/repositories/screening_repository.dart';

// EVENTS
abstract class ScreeningEvent extends Equatable {
  const ScreeningEvent();
  @override
  List<Object?> get props => [];
}

class FetchInstrumentsEvent extends ScreeningEvent {}

class SelectInstrumentEvent extends ScreeningEvent {
  final ScreeningInstrumentEntity instrument;
  const SelectInstrumentEvent(this.instrument);
  @override
  List<Object?> get props => [instrument];
}

class AnswerQuestionEvent extends ScreeningEvent {
  final String questionId;
  final int value;
  const AnswerQuestionEvent({required this.questionId, required this.value});
  @override
  List<Object?> get props => [questionId, value];
}

class NextQuestionEvent extends ScreeningEvent {}

class PreviousQuestionEvent extends ScreeningEvent {}

class SubmitAnswersEvent extends ScreeningEvent {
  final String studentUserId;
  const SubmitAnswersEvent(this.studentUserId);
  @override
  List<Object?> get props => [studentUserId];
}

class ResetScreeningEvent extends ScreeningEvent {}

// STATES
abstract class ScreeningState extends Equatable {
  const ScreeningState();
  @override
  List<Object?> get props => [];
}

class ScreeningInitial extends ScreeningState {}

class ScreeningLoading extends ScreeningState {}

class InstrumentsLoadedState extends ScreeningState {
  final List<ScreeningInstrumentEntity> instruments;
  const InstrumentsLoadedState(this.instruments);
  @override
  List<Object?> get props => [instruments];
}

class ScreeningActiveState extends ScreeningState {
  final ScreeningInstrumentEntity instrument;
  final int currentQuestionIndex;
  final Map<String, int> answers;

  const ScreeningActiveState({
    required this.instrument,
    required this.currentQuestionIndex,
    required this.answers,
  });

  bool get isCompleted => answers.length == instrument.questions.length;
  bool get hasAnsweredCurrent =>
      answers.containsKey(instrument.questions[currentQuestionIndex].id);

  ScreeningActiveState copyWith({
    ScreeningInstrumentEntity? instrument,
    int? currentQuestionIndex,
    Map<String, int>? answers,
  }) {
    return ScreeningActiveState(
      instrument: instrument ?? this.instrument,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      answers: answers ?? this.answers,
    );
  }

  @override
  List<Object?> get props => [instrument, currentQuestionIndex, answers];
}

class ScreeningSubmittingState extends ScreeningState {}

class ScreeningResultState extends ScreeningState {
  final ScreeningAttemptEntity attempt;
  const ScreeningResultState(this.attempt);
  @override
  List<Object?> get props => [attempt];
}

class ScreeningErrorState extends ScreeningState {
  final String message;
  const ScreeningErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

// BLOC
class ScreeningBloc extends Bloc<ScreeningEvent, ScreeningState> {
  final ScreeningRepository _repository;

  ScreeningBloc({required ScreeningRepository repository})
      : _repository = repository,
        super(ScreeningInitial()) {
    on<FetchInstrumentsEvent>(_onFetchInstruments);
    on<SelectInstrumentEvent>(_onSelectInstrument);
    on<AnswerQuestionEvent>(_onAnswerQuestion);
    on<NextQuestionEvent>(_onNextQuestion);
    on<PreviousQuestionEvent>(_onPreviousQuestion);
    on<SubmitAnswersEvent>(_onSubmitAnswers);
    on<ResetScreeningEvent>(_onResetScreening);
  }

  Future<void> _onFetchInstruments(
    FetchInstrumentsEvent event,
    Emitter<ScreeningState> emit,
  ) async {
    emit(ScreeningLoading());
    try {
      final instruments = await _repository.getInstruments();
      emit(InstrumentsLoadedState(instruments));
    } catch (e) {
      emit(ScreeningErrorState('Gagal memuat instrumen asesmen: ${e.toString()}'));
    }
  }

  void _onSelectInstrument(
    SelectInstrumentEvent event,
    Emitter<ScreeningState> emit,
  ) {
    emit(ScreeningActiveState(
      instrument: event.instrument,
      currentQuestionIndex: 0,
      answers: const {},
    ));
  }

  void _onAnswerQuestion(
    AnswerQuestionEvent event,
    Emitter<ScreeningState> emit,
  ) {
    if (state is ScreeningActiveState) {
      final current = state as ScreeningActiveState;
      final newAnswers = Map<String, int>.from(current.answers);
      newAnswers[event.questionId] = event.value;

      emit(current.copyWith(answers: newAnswers));
    }
  }

  void _onNextQuestion(
    NextQuestionEvent event,
    Emitter<ScreeningState> emit,
  ) {
    if (state is ScreeningActiveState) {
      final current = state as ScreeningActiveState;
      if (current.currentQuestionIndex < current.instrument.questions.length - 1) {
        emit(current.copyWith(currentQuestionIndex: current.currentQuestionIndex + 1));
      }
    }
  }

  void _onPreviousQuestion(
    PreviousQuestionEvent event,
    Emitter<ScreeningState> emit,
  ) {
    if (state is ScreeningActiveState) {
      final current = state as ScreeningActiveState;
      if (current.currentQuestionIndex > 0) {
        emit(current.copyWith(currentQuestionIndex: current.currentQuestionIndex - 1));
      }
    }
  }

  Future<void> _onSubmitAnswers(
    SubmitAnswersEvent event,
    Emitter<ScreeningState> emit,
  ) async {
    if (state is ScreeningActiveState) {
      final current = state as ScreeningActiveState;
      emit(ScreeningSubmittingState());
      try {
        final result = await _repository.submitScreening(
          studentUserId: event.studentUserId,
          instrumentId: current.instrument.id,
          answers: current.answers,
        );
        emit(ScreeningResultState(result));
      } catch (e) {
        emit(ScreeningErrorState('Gagal mengirimkan asesmen: ${e.toString()}'));
      }
    }
  }

  void _onResetScreening(
    ResetScreeningEvent event,
    Emitter<ScreeningState> emit,
  ) {
    add(FetchInstrumentsEvent());
  }
}

