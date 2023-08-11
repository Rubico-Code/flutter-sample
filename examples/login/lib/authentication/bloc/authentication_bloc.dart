import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:login/model/session.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc(AuthenticationRepository authRepository)
      : _authRepository = authRepository,
        super(const AuthenticationUnknown()) {
    on<AppLoaded>((event, emit) => _onAppLoaded(event, emit));
    on<UserLoggedIn>((event, emit) => _onUserLoggedIn(event, emit));
    on<UserLoggedOut>((event, emit) => _onUserLoggedOut(event, emit));
  }

  final AuthenticationRepository _authRepository;

  void _onAppLoaded(
    AppLoaded event,
    Emitter<AuthenticationState> emit,
  ) async {
    await Future.delayed(
      const Duration(seconds: 3),
      () => emit(
        const AuthenticationUnknown(),
      ),
    );
  }

  void _onUserLoggedIn(
      UserLoggedIn event, Emitter<AuthenticationState> emit) async {
    emit(Authenticated(session: event.session));
  }

  void _onUserLoggedOut(
      UserLoggedOut event, Emitter<AuthenticationState> emit) async {
    emit(const UnAuthenticated());
  }
}
