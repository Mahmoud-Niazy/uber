import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:uber_final/app_localization.dart';
import 'package:uber_final/components/components.dart';
import 'package:uber_final/screens/clients/google_map_screen.dart';

import '../../uber_cubit/uber_cubit.dart';
import '../../uber_cubit/uber_states.dart';

class MakeOrderScreen extends StatelessWidget {
  // var fromController = TextEditingController();
  // var toController = TextEditingController();
  final timeController = TextEditingController();
  final dateController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  dynamic dateToDeleteTheAgreement ;

  MakeOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UberCubit, UberStates>(
      listener: (context, state) {
        if (state is MakeOrderSuccessfullyState) {
          UberCubit.get(context).sendNotificationToAlldrivers(
            clientName: UberCubit.get(context).client!.name,
            context: context,
          );
          UberCubit.get(context).currentIndexInClientsLayout = 0;
          timeController.text = '';
          dateController.text = '';
          UberCubit.get(context).fromController.text = '';
          UberCubit.get(context).toController.text = '';
        }
      },
      builder: (context, state) {
        var cubit = UberCubit.get(context);
        var locale = AppLocalizations.of(context)!;
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Image.asset(
                'assets/images/City driver-rafiki.png',
                height: 250,
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          locale.translate('Make Your order'),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .05,
                        ),
                        BuildTextFormField(
                          label: locale.translate('From'),
                          pIcon: Icons.location_on_outlined,
                          controller: cubit.fromController,
                          onPressedOnPIcon: () {
                            cubit.isFrom = true;
                            navigate(
                                screen: const GoogleMapScreen(), context: context);
                          },
                          validation: (value) {
                            if (value!.isEmpty) {
                              return locale.translate('Location is empty');
                            }
                            return null;
                          },
                          pIconColor: Colors.blue,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        BuildTextFormField(
                          label: locale.translate('To'),
                          pIcon: Icons.location_on_outlined,
                          controller: cubit.toController,
                          onPressedOnPIcon: cubit.isFrom
                              ? null
                              : () {
                                  navigate(
                                      screen: const GoogleMapScreen(),
                                      context: context);
                                },
                          validation: (value) {
                            if (value!.isEmpty) {
                              return locale.translate('Location is empty');
                            }
                            return null;
                          },
                          pIconColor: cubit.isFrom ? Colors.grey : Colors.blue,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        BuildTextFormField(
                          label: locale.translate('Time'),
                          pIcon: Icons.watch_later_outlined,
                          controller: timeController,
                          onPressedOnPIcon: () {
                            showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now())
                                .then((value) {
                              timeController.text = value!.format(context);
                            });
                          },
                          validation: (value) {
                            if (value!.isEmpty) {
                              return locale.translate('Time is empty');
                            }
                            return null;
                          },
                          pIconColor: Colors.blue,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        BuildTextFormField(
                          label: locale.translate('Date'),
                          pIcon: Icons.date_range_outlined,
                          controller: dateController,
                          onPressedOnPIcon: () {
                            // print(DateTime.parse(DateTime.now().toString()).difference(DateTime.parse('2023-04-29 01:40:29.589629')).inDays);
                            showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.parse('2023-09-03'),
                            ).then((value) {
                              dateToDeleteTheAgreement = value.toString();
                              dateController.text =
                                  DateFormat.yMMMMd().format(value!);
                            });
                          },
                          validation: (value) {
                            if (value!.isEmpty) {
                              return locale.translate('Date is empty');
                            }
                            return null;
                          },
                          pIconColor: Colors.blue,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .06,
                        ),
                        state is MakeOrderLoadingState
                            ? const Center(child: CircularProgressIndicator())
                            : BuildButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    cubit.makeOrder(
                                      time: timeController.text,
                                      date: dateController.text,
                                      fromPlace: cubit.fromController.text,
                                      toPlace: cubit.toController.text,
                                      dateToDeleteTheAgreement:dateToDeleteTheAgreement,
                                      dateToOrder: DateTime.now().toString(),
                                    );
                                    dateToDeleteTheAgreement = null ;
                                  }
                                },
                                label: locale.translate('Order'),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
