import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rate/rate.dart';
import 'package:uber_final/components/components.dart';
import 'package:uber_final/data_models/order_data_model.dart';
import 'package:uber_final/uber_cubit/uber_cubit.dart';
import '../../uber_cubit/uber_states.dart';

class AllOffersScreen extends StatelessWidget {
  String orderId;
  double rate =3.5 ;

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
              physics: BouncingScrollPhysics(),
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
                    child: Card(
                      margin: EdgeInsets.all(20),
                      elevation: 10,
                      child: Padding(
                        padding: const EdgeInsets.all(50),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'There is an agreement with : ',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Center(
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    radius: 60,
                                    backgroundImage: NetworkImage(
                                      order[0].driverImage!,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    order[0].driverName!,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Price :   ',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        order[0].price!,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Phone :   ',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        order[0].driverPhone!,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 50,
                                  ),
                                  Text(
                                    'Rate the driver',
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Rate(
                                    iconSize: 40,
                                    color: Colors.yellow.shade600,
                                    allowHalf: true,
                                    allowClear: true,
                                    initialValue: 3.5,
                                    readOnly: false,
                                    onChange: (value) {
                                      rate = value;
                                    },

                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  state is RateDriverLoadingState?
                                  Center(child: CircularProgressIndicator())
                                  :
                                  BuildButton(
                                    onPressed: () {
                                      cubit.RateDriver(
                                        driverId: order[0].driverId!,
                                        clientId: order[0].clientId!,
                                        rate: rate,
                                        clientImage: cubit.client!.image,
                                        clientName: cubit.client!.name,
                                      );
                                    },
                                    label: 'Confirm rate',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          );
        },
      );
    });
  }
}
