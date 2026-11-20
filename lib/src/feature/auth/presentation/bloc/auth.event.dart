import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object> get props => [];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  const LoginRequested({required this.email, required this.password});
  @override
  List<Object> get props => [email, password];
}

class RegisterRequested extends AuthEvent {
  final String fullName;
  final String phoneNumber;
  final String email;
  final String nic;
  final String password;
 
  const RegisterRequested({
    required this.fullName,
    required this.phoneNumber,
    required this.email,
    required this.nic,
    required this.password,
  });
 
  @override
  List<Object> get props => [fullName, phoneNumber, email, nic, password];
}

class LogoutRequested extends AuthEvent {}

class ReauthenticateRequested extends AuthEvent {
  final String password;
  const ReauthenticateRequested({required this.password});
  @override
  List<Object> get props => [password];
}

class VerifyEmailRequested extends AuthEvent {
  final String email;
  const VerifyEmailRequested({required this.email});
  @override
  List<Object> get props => [email];
}

class AuthReset extends AuthEvent {
  const AuthReset();
}