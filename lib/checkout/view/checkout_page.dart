import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/checkout_cubit.dart';
import 'checkout_stepper.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout Form'),
      ),
      body: BlocProvider<CheckoutCubit>(
        create: (_) => CheckoutCubit(4),
        child: const CheckoutStepper(),
      ),
    );
  }
}