import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uber_final/components/components.dart';
import 'package:uber_final/data_models/order_data_model.dart';
import 'package:uber_final/uber_cubit/uber_cubit.dart';

import '../../uber_cubit/uber_states.dart';

class AllOffersScreen extends StatelessWidget {
  String orderId;

  AllOffersScreen({required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      UberCubit.get(context).GetAllOffers(orderId: this.orderId);

      return BlocConsumer<UberCubit, UberStates>(
        listener: (context, state) {
          print(state);
        },
        builder: (context, state) {
          var cubit = UberCubit.get(context);
          List<OrderDataModel> order =
              UberCubit.get(context).orders.where((element) {
            return element.orderId == this.orderId;
          }).toList();
          return Scaffold(
            appBar: AppBar(),
            body: order[0].agreement == false
                ? cubit.offers.length > 0
                    ? ListView.separated(
                        itemBuilder: (context, index) => BuildOfferItem(
                          offer: cubit.offers[index],
                          order: order[0],
                        ),
                        separatorBuilder: (context, index) => SizedBox(
                          height: 0,
                        ),
                        itemCount: cubit.offers.length,
                      )
                    : Center(child: CircularProgressIndicator())
                : Center(
                  child: Text(
                      'There is an agreement with ${order[0].driverName} ${order[0].price}',
              style: TextStyle(
                  fontSize: 20,
              ),
                    ),
                ),
          );
        },
      );
    });
  }
}
