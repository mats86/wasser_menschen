part of 'personal_info_bloc.dart';

class PersonalInfoState extends Equatable {
  const PersonalInfoState({
    this.email = const Email.pure(),
    this.name = const Name.pure(),
    this.phoneNumber = const PhoneNumber.pure(),
    this.birthDay = const BirthDay.pure(),
    this.status = FormzStatus.pure,
  });

  final Email email;
  final Name name;
  final PhoneNumber phoneNumber;
  final BirthDay birthDay;
  final FormzStatus status;

  PersonalInfoState copyWith({
    Email? email,
    Name? name,
    PhoneNumber? phoneNumber,
    BirthDay? birthday,
    FormzStatus? status,
  }) {
    return PersonalInfoState(
      email: email ?? this.email,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      birthDay: birthday ?? this.birthDay,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [email, name, phoneNumber, birthDay, status];
}