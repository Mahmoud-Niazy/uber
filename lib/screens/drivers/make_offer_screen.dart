import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uber_final/components/components.dart';
import 'package:uber_final/uber_cubit/uber_cubit.dart';

import '../../data_models/order_data_model.dart';
import '../../uber_cubit/uber_states.dart';

class MakeOfferScreen extends StatelessWidget {
  var priceController = TextEditingController();
  OrderDataModel order;

  MakeOfferScreen(this.order);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UberCubit, UberStates>(
      listener: (context, state) {},
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
              child: Padding(
                padding: const EdgeInsets.all(20),
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
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    state is MakeOfferLoadingState?
                    Center(child: CircularProgressIndicator())
                    :
                    BuildButton(
                      onPressed: () {
                        cubit.MakeOffer(
                          orderId: order.orderId!,
                          price: priceController.text,
                          clientFcmToken: order.fcmToken!,
                        );
                      },
                      label: 'Confirm',
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
