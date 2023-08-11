part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object?> get props => [];
}

class AuthenticationUnknown extends AuthenticationState {
  const AuthenticationUnknown() : super();
}

// class AuthenticationLoading extends AuthenticationState {
//   const AuthenticationLoading() : super();
// }

class UnAuthenticated extends AuthenticationState {
  const UnAuthenticated() : super();
}

class Authenticated extends AuthenticationState {
  const Authenticated({required this.session}) : super();

  final Session session;

  @override
  List<Object?> get props => [session];
}
