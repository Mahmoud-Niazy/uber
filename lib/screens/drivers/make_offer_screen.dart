import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uber_final/components/components.dart';
import 'package:uber_final/uber_cubit/uber_cubit.dart';

import '../../app_localization.dart';
import '../../data_models/order_data_model.dart';
import '../../uber_cubit/uber_states.dart';

class MakeOfferScreen extends StatelessWidget {
  final priceController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final OrderDataModel order;

  MakeOfferScreen(this.order, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UberCubit, UberStates>(
      listener: (context, state) {
        if (state is MakeOfferSuccessfullyState) {
          Fluttertoast.showToast(
            msg: AppLocalizations.of(context)!.translate('Your offer sent successfully'),
            backgroundColor: Colors.green,
          ).then((value) {
            priceController.text = '';
          });
        }
      },
      builder: (context, state) {
        var cubit = UberCubit.get(context);
        var locale = AppLocalizations.of(context)!;
        return Scaffold(
          appBar: AppBar(
            title: Text(
              locale.translate('Apply'),
            ),
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/Investment data-rafiki.png',
                    height: MediaQuery.of(context).size.height*.35,
                  ),
                  Center(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                locale.translate('Enter Your price'),
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              BuildTextFormField(
                                label: locale.translate('Price'),
                                pIcon: Icons.monetization_on_outlined,
                                controller: priceController,
                                type: TextInputType.number,
                                validation: (value) {
                                  if (value!.isEmpty) {
                                    return locale.translate('Enter your price please');
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              state is MakeOfferLoadingState
                                  ? const Center(child: CircularProgressIndicator())
                                  : BuildButton(
                                      onPressed: () {
                                        if (formKey.currentState!.validate()) {
                                          cubit.makeOffer(
                                            orderId: order.orderId!,
                                            price: priceController.text,
                                            clientFcmToken: order.fcmToken!,
                                            context: context,
                                          );
                                        }
                                      },
                                      label: locale.translate('Confirm'),
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
