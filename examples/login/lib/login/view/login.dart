import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:login/authentication/authentication.dart';
import 'package:login/login/bloc/login_bloc.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const Login());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return LoginBloc(
          authenticationBloc: context.read<AuthenticationBloc>(),
          authenticationRepository: context.read<AuthenticationRepository>(),
        );
      },
      child: const LoginView(),
    );
  }
}

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  LoginViewState createState() => LoginViewState();
}

class LoginViewState extends State<LoginView> {
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener(() {
      if (!_emailFocusNode.hasFocus) {
        context.read<LoginBloc>().add(LoginEmailUnfocused());
        FocusScope.of(context).requestFocus(_passwordFocusNode);
      }
    });
    _passwordFocusNode.addListener(() {
      if (!_passwordFocusNode.hasFocus) {
        context.read<LoginBloc>().add(LoginPasswordUnfocused());
      }
    });
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Login'),
        automaticallyImplyLeading: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      80,
                    ),
                    border: Border.all(
                      width: 2,
                      color: Colors.blue,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: const CircleAvatar(
                    radius: 70,
                    foregroundImage: AssetImage('assets/images/flutter.png'),
                    backgroundColor: Colors.transparent,
                  ),
                ),
                const SizedBox(
                  height: 60,
                ),
                _EmailInput(
                  focusNode: _emailFocusNode,
                ),
                const SizedBox(
                  height: 20,
                ),
                _PasswordInput(
                  focusNode: _passwordFocusNode,
                ),
                const SizedBox(
                  height: 40,
                ),
                BlocConsumer<LoginBloc, LoginState>(
                  listener: (context, state) {
                    if (state.status == FormzSubmissionStatus.failure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(state.error ?? ''),
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state.status == FormzSubmissionStatus.inProgress) {
                      return const CircularProgressIndicator();
                    } else {
                      return MaterialButton(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        minWidth: double.infinity,
                        color: Colors.blue.shade600,
                        onPressed: () {
                          context.read<LoginBloc>().add(const LoginSubmitted());
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(
                  height: 40,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  const _EmailInput({super.key, required this.focusNode});

  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextFormField(
          key: const Key('username_input_text_field'),
          initialValue: state.email.value,
          focusNode: focusNode,
          keyboardType: TextInputType.emailAddress,
          autocorrect: false,
          autovalidateMode: focusNode.hasFocus
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          decoration: InputDecoration(
            hintText: 'Email',
            counterText: '',
            errorText: state.email.errorText,
            errorMaxLines: 2,
          ),
          onChanged: (email) =>
              context.read<LoginBloc>().add(LoginUsernameChanged(email)),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  const _PasswordInput({super.key, required this.focusNode});

  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return TextFormField(
          key: const Key('password_input_text_field'),
          initialValue: state.password.value,
          focusNode: focusNode,
          obscureText: state.obscurePassword,
          keyboardType: TextInputType.visiblePassword,
          decoration: InputDecoration(
            hintText: 'Password',
            counterText: '',
            errorText: state.password.errorText,
            errorMaxLines: 2,
          ),
          onChanged: (password) =>
              context.read<LoginBloc>().add(LoginPasswordChanged(password)),
        );
      },
    );
  }
}
