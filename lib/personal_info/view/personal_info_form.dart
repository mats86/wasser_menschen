import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:intl/intl.dart';
import 'package:formz/formz.dart';

import '../../checkout/cubit/checkout_cubit.dart';
import '../bloc/personal_info_bloc.dart';

class PersonalInfoForm extends StatefulWidget {
  const PersonalInfoForm({Key? key}) : super(key: key);

  @override
  State<PersonalInfoForm> createState() =>_PersonalInfoForm();
}

class _PersonalInfoForm extends State<PersonalInfoForm> {
  final _emailFocusNode = FocusNode();
  final TextEditingController _emailTextField = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener(() {
      if (!_emailFocusNode.hasFocus) {
        context.read<PersonalInfoBloc>().add(EmailChanged(_emailTextField.text));
        // FocusScope.of(context).requestFocus()
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PersonalInfoBloc, PersonalInfoState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Something went wrong!')),
            );
        }
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            _EmailInput(focusNode: _emailFocusNode, textField: _emailTextField,),
            _NameInput(),
            _PhoneNumberInput(),
            _BirthDataInput(),
            Row(
              children: [
                Expanded(child: _CancelButton()),
                const SizedBox(width: 8.0),
                Expanded(child: _SubmitButton()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  const _EmailInput({required this.focusNode, required this.textField});

  final FocusNode focusNode;
  final TextEditingController textField;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PersonalInfoBloc, PersonalInfoState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          key: const Key('personalInfoForm_emailInput_textField'),
          controller: textField,
          focusNode: focusNode,
          // onChanged: (email) =>
          //     context.read<PersonalInfoBloc>().add(EmailUnfocused(email)),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Email',
            errorText: state.email.invalid ? state.email.error?.message : null,
          ),
          textInputAction: TextInputAction.next,
        );
      },
    );
  }
}

class _NameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PersonalInfoBloc, PersonalInfoState>(
      buildWhen: (previous, current) => previous.name != current.name,
      builder: (context, state) {
        return TextField(
          key: const Key('personalInfoForm_nameInput_textField'),
          onChanged: (name) =>
              context.read<PersonalInfoBloc>().add(NameChanged(name)),
          decoration: InputDecoration(
            labelText: 'Name',
            errorText: state.name.invalid ? state.name.error?.message : null,
          ),
        );
      },
    );
  }
}

class _PhoneNumberInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PersonalInfoBloc, PersonalInfoState>(
      buildWhen: (previous, current) =>
      previous.phoneNumber != current.phoneNumber,
      builder: (context, state) {
        return TextField(
          key: const Key('personalInfoForm_phoneNumberInput_textField'),
          onChanged: (phoneNumber) => context
              .read<PersonalInfoBloc>()
              .add(PhoneNumberChanged(phoneNumber)),
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: 'Phone Number',
            errorText: state.phoneNumber.invalid
                ? state.phoneNumber.error?.message
                : null,
          ),
        );
      },
    );
  }
}

class _BirthDataInput extends StatelessWidget {
  // Define _textField as an instance variable.
  final TextEditingController _textField = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PersonalInfoBloc, PersonalInfoState>(
      buildWhen: (previous, current) =>
      previous.birthDay != current.birthDay,
      builder: (context, state) {
        return TextField(
          key: const Key('personalInfoForm_birthDayInput_textField'),
          // onChanged: (birthday) => context
          //     .read<PersonalInfoBloc>()
          //     .add(BirthdayChanged(birthday)),
          controller: _textField,
          readOnly: true,
          onTap: () async {
            DatePicker.showDatePicker(context,
                showTitleActions: true,
                currentTime: DateTime.now(),
                locale: LocaleType.de,
                maxTime: DateTime(2022, 1, 1),
                onConfirm: (date) {
                  // Set the date in the text field.
                  // (Note: We need to use DateFormat to format the date.)
                  var formattedDate = DateFormat('dd.MM.yyyy').format(date);
                  // Set the text of the text field.
                  _textField.text = formattedDate;
                  context
                      .read<PersonalInfoBloc>()
                      .add(BirthdayChanged(formattedDate));
                });
          },
          keyboardType: TextInputType.datetime,
          decoration: InputDecoration(
            labelText: 'Birth day',
            errorText: state.birthDay.invalid
              ? state.birthDay.error?.message
                : null,
          ),
        );
      },
    );
  }
}

class _SubmitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PersonalInfoBloc, PersonalInfoState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status.isSubmissionSuccess) {
          context.read<CheckoutCubit>().stepContinued();
        }
      },
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
          key: const Key('personalInfoForm_submitButton_elevatedButton'),
          style: ElevatedButton.styleFrom(elevation: 0),
          onPressed: state.status.isValidated
              ? () =>
              context.read<PersonalInfoBloc>().add(FormSubmitted())
              : null,
          child: const Text('SUBMIT'),
        );
      },
    );
  }
}

class _CancelButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PersonalInfoBloc, PersonalInfoState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const SizedBox.shrink()
            : TextButton(
          key: const Key('personalInfoForm_cancelButton_elevatedButton'),
          onPressed: () => context.read<CheckoutCubit>().stepCancelled(),
          child: const Text('CANCEL'),
        );
      },
    );
  }
}
