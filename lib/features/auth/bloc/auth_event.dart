abstract class AuthEvent {}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  LoginRequested(this.email, this.password);
}

class SignupRequested extends AuthEvent {
  final String email;
  final String password;

  SignupRequested(this.email, this.password);
}

class GoogleSignInRequested extends AuthEvent {}

class LogoutRequested extends AuthEvent {}
