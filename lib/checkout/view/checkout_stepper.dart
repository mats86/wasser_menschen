import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../billing_address/view/billing_address_page.dart';
import '../../payment/view/payment_page.dart';
import '../../personal_info/view/personal_info_page.dart';
import '../cubit/checkout_cubit.dart';
import 'package:im_stepper/stepper.dart';

class CheckoutStepper extends StatelessWidget {
  const CheckoutStepper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckoutCubit, CheckoutState>(
      builder: (context, state) {
        return Column(
          children: [
            IconStepper(
              enableNextPreviousButtons: false,
              icons: [
                state.activeStepperIndex <= 0
                    ? const Icon(IconData(1, fontFamily: 'MaterialIcons'))
                    : Icon(Icons.co2),
                Icon(Icons.looks_one_rounded),
                Icon(Icons.looks_two),
                Icon(Icons.three_g_mobiledata),
                Icon(Icons.four_g_mobiledata),
              ],
              activeStep: state.activeStepperIndex,
              onStepReached: (index) {
                context.read<CheckoutCubit>().stepTapped(index);
              },
            ),
            header(state.activeStepperIndex),
            body(state.activeStepperIndex),
          ],
        );
        // return Stepper(
        //   type: StepperType.horizontal,
        //   currentStep: state.activeStepperIndex,
        //   onStepTapped: context.read<CheckoutCubit>().stepTapped,
        //   controlsBuilder: (context, controlDetails) {
        //     return const SizedBox.shrink();
        //   },
        //   steps: [
        //     Step(
        //       title: const Text('Personal Info'),
        //       content: const PersonalInfoPage(),
        //       isActive: state.activeStepperIndex >= 0,
        //       state: state.activeStepperIndex >= 0
        //           ? StepState.complete
        //           : StepState.disabled,
        //     ),
        //     Step(
        //       title: const Text('Address'),
        //       content: const BillingAddressPage(),
        //       isActive: state.activeStepperIndex >= 1,
        //       state: state.activeStepperIndex >= 1
        //           ? StepState.complete
        //           : StepState.disabled,
        //     ),
        //     Step(
        //       title: const Text('Payment'),
        //       content: const PaymentPage(),
        //       isActive: state.activeStepperIndex >= 2,
        //       state: state.activeStepperIndex >= 2
        //           ? StepState.complete
        //           : StepState.disabled,
        //     ),
        //   ],
        // );
      },
    );
  }

  /// Returns the header wrapping the header text.
  Widget header(int activeStepperIndex) {
    return Container(
      decoration: BoxDecoration(
        // color: Colors.orange,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          headerText(activeStepperIndex),
          style: const TextStyle(
            // color: Colors.black,
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  // Returns the header text based on the activeStep.
  String headerText(int activeStepperIndex) {
    switch (activeStepperIndex) {
      case 0:
        return 'Persönliche Informationen';

      case 1:
        return 'Table of Contents';

      case 2:
        return 'About the Author';

      case 3:
        return 'Publisher Information';

      case 4:
        return 'Reviews';

      case 5:
        return 'Chapters #1';

      default:
        return 'Introduction';
    }
  }

  /// Returns the body.
  Widget body(int activeStepperIndex) {
    switch (activeStepperIndex) {
      case 0:
        return PersonalInfoPage();

      case 1:
        return BillingAddressPage();

      default:
        return Container();
    }
  }
}
