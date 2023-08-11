import 'dart:io';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:login/authentication/authentication.dart';
import 'package:login/form_fields/form_fields.dart';
import 'package:login/model/session.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    required AuthenticationBloc authenticationBloc,
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationBloc = authenticationBloc,
        _authenticationRepository = authenticationRepository,
        super(const LoginState()) {
    on<LoginUsernameChanged>(_onUsernameChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onSubmitted);
    on<LoginEmailUnfocused>(_onEmailUnfocused);
    on<LoginPasswordUnfocused>(_onPasswordUnfocused);
  }

  final AuthenticationBloc _authenticationBloc;
  final AuthenticationRepository _authenticationRepository;

  void _onUsernameChanged(
    LoginUsernameChanged event,
    Emitter<LoginState> emit,
  ) {
    final username = Email.dirty(event.username);
    emit(state.copyWith(
        email: username, isValid: Formz.validate([username, state.password])));
  }

  void _onEmailUnfocused(LoginEmailUnfocused event, Emitter<LoginState> emit) {
    final email = Email.dirty(state.email.value);
    emit(
      state.copyWith(
        email: email,
        isValid: Formz.validate([email, state.password]),
      ),
    );
  }

  void _onPasswordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) {
    final password = Password.dirty(event.password);
    emit(state.copyWith(
        password: password, isValid: Formz.validate([password, state.email])));
  }

  void _onPasswordUnfocused(
    LoginPasswordUnfocused event,
    Emitter<LoginState> emit,
  ) {
    final password = Password.dirty(state.password.value);
    emit(
      state.copyWith(
        password: password,
        isValid: Formz.validate([state.email, password]),
      ),
    );
  }

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    emit(
      state.copyWith(
        email: email,
        password: password,
        isValid: Formz.validate([email, password]),
      ),
    );

    if (state.isValid) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
      try {
        final response = await _authenticationRepository.logIn(
          email: state.email.value,
          password: state.password.value,
        );
        emit(state.copyWith(status: FormzSubmissionStatus.success));

        if (response.statusCode == HttpStatus.ok) {}
        _authenticationBloc.add(UserLoggedIn(
            session: Session.fromJson(response.data! as Map<String, dynamic>)));
      } catch (_) {
        emit(state.copyWith(status: FormzSubmissionStatus.success));
      }
    }
  }
}
