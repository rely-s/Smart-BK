import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/enums.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

// EVENTS
abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class CheckAuthStatusEvent extends AuthEvent {}

class LoginSubmittedEvent extends AuthEvent {
  final String identityOrEmail;
  final String password;

  const LoginSubmittedEvent({
    required this.identityOrEmail,
    required this.password,
  });

  @override
  List<Object?> get props => [identityOrEmail, password];
}

class LogoutRequestedEvent extends AuthEvent {}

class SwitchRoleEvent extends AuthEvent {
  final UserRole targetRole;

  const SwitchRoleEvent(this.targetRole);

  @override
  List<Object?> get props => [targetRole];
}

// STATES
abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final UserEntity user;

  const Authenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class Unauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLOC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthInitial()) {
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<LoginSubmittedEvent>(_onLoginSubmitted);
    on<LogoutRequestedEvent>(_onLogoutRequested);
    on<SwitchRoleEvent>(_onSwitchRole);
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.getCurrentUser();
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(Unauthenticated());
    }
  }

  Future<void> _onLoginSubmitted(
    LoginSubmittedEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.login(
        identityNumberOrEmail: event.identityOrEmail,
        password: event.password,
      );
      emit(Authenticated(user));
    } catch (e) {
      emit(AuthError('Gagal melakukan autentikasi: ${e.toString()}'));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequestedEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    await _authRepository.logout();
    emit(Unauthenticated());
  }

  Future<void> _onSwitchRole(
    SwitchRoleEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final user = await _authRepository.switchDemoRole(event.targetRole);
    emit(Authenticated(user));
  }
}

