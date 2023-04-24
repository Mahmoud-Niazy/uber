import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uber_final/components/components.dart';
import 'package:uber_final/uber_cubit/uber_cubit.dart';

import '../../data_models/order_data_model.dart';
import '../../uber_cubit/uber_states.dart';

class MakeOfferScreen extends StatelessWidget {
  var priceController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  OrderDataModel order;

  MakeOfferScreen(this.order);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UberCubit, UberStates>(
      listener: (context, state) {
        if (state is MakeOfferSuccessfullyState) {
          Fluttertoast.showToast(
            msg: 'Your offer sent successfully',
            backgroundColor: Colors.green,
          ).then((value) {
            priceController.text = '';
          });
        }
      },
      builder: (context, state) {
        var cubit = UberCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Apply',
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
                                'Enter Your price',
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              BuildTextFormField(
                                label: 'price',
                                pIcon: Icons.monetization_on_outlined,
                                controller: priceController,
                                type: TextInputType.number,
                                validation: (value) {
                                  if (value!.isEmpty) {
                                    return 'Enter your price please ';
                                  }
                                },
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              state is MakeOfferLoadingState
                                  ? Center(child: CircularProgressIndicator())
                                  : BuildButton(
                                      onPressed: () {
                                        if (formKey.currentState!.validate()) {
                                          cubit.MakeOffer(
                                            orderId: order.orderId!,
                                            price: priceController.text,
                                            clientFcmToken: order.fcmToken!,
                                          );
                                        }
                                      },
                                      label: 'Confirm',
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
