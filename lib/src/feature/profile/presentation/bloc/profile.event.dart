import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class ProfileUpdateRequested extends ProfileEvent {
  final String userId;
  final bool isEmailChanged;
  final String fullName;
  final String phoneNumber;
  final String email;
  final String nic;

  const ProfileUpdateRequested({required this.userId, required this.isEmailChanged, required this.fullName, required this.phoneNumber, required this.email, required this.nic});

  @override
  List<Object?> get props => [userId, isEmailChanged, fullName, phoneNumber, email, nic];
}

class PasswordUpdateRequested extends ProfileEvent {
  final String password;

  const PasswordUpdateRequested({required this.password});

  @override
  List<Object?> get props => [password];
}

class ProfileReset extends ProfileEvent {
  const ProfileReset();
}
