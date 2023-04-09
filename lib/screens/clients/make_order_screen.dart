import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:uber_final/components/components.dart';
import 'package:uber_final/screens/clients/google_map_screen.dart';

import '../../uber_cubit/uber_cubit.dart';
import '../../uber_cubit/uber_states.dart';

class MakeOrderScreen extends StatelessWidget {
  // var fromController = TextEditingController();
  // var toController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UberCubit, UberStates>(
      listener: (context, state) {
        if (state is MakeOrderSuccessfullyState) {
          UberCubit.get(context).SendNotificationToAlldrivers(
            clientName: UberCubit.get(context).client!.name,
          );
          UberCubit.get(context).currentIndexInClientsLayout = 0;
          timeController.text = '';
          dateController.text = '';
          UberCubit.get(context).fromController.text = '';
          UberCubit.get(context).toController.text = '';
        }
        print(state);
      },
      builder: (context, state) {
        var cubit = UberCubit.get(context);
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Make Your order',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .05,
                    ),
                    BuildTextFormField(
                      label: 'From',
                      pIcon: Icons.location_on_outlined,
                      controller: cubit.fromController,
                      onPressedOnPIcon: () {
                        cubit.isFrom = true;
                        navigate(screen: GoogleMapScreen(), context: context);
                      },
                      validation: (value) {
                        if (value!.isEmpty) {
                          return 'Location is empty';
                        }
                      },
                      pIconColor: Colors.blue,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    BuildTextFormField(
                      label: 'To',
                      pIcon: Icons.location_on_outlined,
                      controller: cubit.toController,
                      onPressedOnPIcon: cubit.isFrom
                          ? null
                          : () {
                              navigate(
                                  screen: GoogleMapScreen(), context: context);
                            },
                      validation: (value) {
                        if (value!.isEmpty) {
                          return 'Location is empty';
                        }
                      },
                      pIconColor: cubit.isFrom ? Colors.grey : Colors.blue,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    BuildTextFormField(
                      label: 'Time',
                      pIcon: Icons.watch_later_outlined,
                      controller: timeController,
                      onPressedOnPIcon: () {
                        showTimePicker(
                                context: context, initialTime: TimeOfDay.now())
                            .then((value) {
                          timeController.text = value!.format(context);
                        });
                      },
                      validation: (value) {
                        if (value!.isEmpty) {
                          return 'Time is empty';
                        }
                      },
                      pIconColor: Colors.blue,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    BuildTextFormField(
                      label: 'Date',
                      pIcon: Icons.date_range_outlined,
                      controller: dateController,
                      onPressedOnPIcon: () {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.parse('2023-09-03'),
                        ).then((value) {
                          dateController.text =
                              DateFormat.yMMMMd().format(value!);
                        });
                      },
                      validation: (value) {
                        if (value!.isEmpty) {
                          return 'Date is empty';
                        }
                      },
                      pIconColor: Colors.blue,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .1,
                    ),
                    state is MakeOrderLoadingState
                        ? Center(child: CircularProgressIndicator())
                        : BuildButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                cubit.MakeOrder(
                                  time: timeController.text,
                                  date: dateController.text,
                                  fromPlace: cubit.fromController.text,
                                  toPlace: cubit.toController.text,
                                );
                              }
                            },
                            label: 'Order',
                          ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
