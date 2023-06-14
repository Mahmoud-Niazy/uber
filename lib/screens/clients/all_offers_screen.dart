import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rate/rate.dart';
import 'package:uber_final/app_localization.dart';
import 'package:uber_final/components/components.dart';
import 'package:uber_final/data_models/order_data_model.dart';
import 'package:uber_final/layout/layout_for_client.dart';
import 'package:uber_final/screens/chat_screen.dart';
import 'package:uber_final/uber_cubit/uber_cubit.dart';
import '../../uber_cubit/uber_states.dart';

class AllOffersScreen extends StatelessWidget {
  String orderId;
  double rate = 3.5;

  AllOffersScreen({required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      UberCubit.get(context).GetAllOffers(orderId: this.orderId);

      return BlocConsumer<UberCubit, UberStates>(
        listener: (context, state) {
          if (state is RateDriverSuccessfullyState) {
            Fluttertoast.showToast(
              msg:
                  AppLocalizations.of(context)!.Translate('Rated Successfully'),
              backgroundColor: Colors.green,
            );
          }
          if (state is DeleteOrderFromClientSuccessfullyState) {
            navigate(screen: LayoutForClient(), context: context);
          }
          print(state);
        },
        builder: (context, state) {
          var cubit = UberCubit.get(context);
          var locale = AppLocalizations.of(context)!;
          List<OrderDataModel> order =
              UberCubit.get(context).orders.where((element) {
            return element.orderId == this.orderId;
          }).toList();
          return Scaffold(
            appBar: AppBar(),
            body: order[0] != null
                ? order[0].agreement == false
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
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/Waiting-bro.png',
                                  width: MediaQuery.of(context).size.width,
                                ),
                                Text(
                                  locale.Translate('There is no offers yet'),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          )
                    : Center(
                        child: Card(
                          margin: EdgeInsets.all(20),
                          elevation: 10,
                          child: Container(
                            padding: EdgeInsets.all(
                                MediaQuery.of(context).size.width * .05),
                            child: SingleChildScrollView(
                              physics: BouncingScrollPhysics(),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '${locale.Translate('There is an agreement with')} : ',
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '${locale.Translate('Price')} :   ',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              order[0].price! + '\$',
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '${locale.Translate('Phone')} :   ',
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
                                          locale.Translate('Rate the driver'),
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
                                        state is RateDriverLoadingState
                                            ? Center(
                                                child:
                                                    CircularProgressIndicator())
                                            : BuildButton(
                                                onPressed: () {
                                                  cubit.RateDriver(
                                                    driverId:
                                                        order[0].driverId!,
                                                    clientId:
                                                        order[0].clientId!,
                                                    rate: rate,
                                                    clientImage:
                                                        cubit.client!.image,
                                                    clientName:
                                                        cubit.client!.name,
                                                  );
                                                },
                                                label: locale.Translate(
                                                    'Confirm rate'),
                                              ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        BuildButton(
                                          label: locale.Translate('Chat'),
                                          onPressed: () {
                                            navigate(
                                              screen: ChatScreen(order[0]),
                                              context: context,
                                            );
                                          },
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        // BuildTextButton(
                                        //   label: locale.Translate(
                                        //       'Delete the agreement'),
                                        //   onPressed: () {
                                        //     if (DateTime.parse(order[0]
                                        //                 .dateToDeleteTheAgreement)
                                        //             .difference(DateTime.parse(
                                        //                 DateTime.now()
                                        //                     .toString()))
                                        //             .inDays ==
                                        //         0) {
                                        //       Fluttertoast.showToast(
                                        //         msg: locale.Translate(
                                        //             'can\'t be deleted'),
                                        //         backgroundColor: Colors.red,
                                        //       );
                                        //     } else {
                                        //       showDialog(
                                        //         context: context,
                                        //         builder: (context) =>
                                        //             AlertDialog(
                                        //           content: Text(
                                        //             locale.Translate(
                                        //                 'Are you sure ?'),
                                        //           ),
                                        //           actions: [
                                        //             BuildTextButton(
                                        //               label: locale.Translate(
                                        //                   'Confirm'),
                                        //               onPressed: () {
                                        //                 UberCubit.get(context)
                                        //                     .DeleteOrderFromClient(
                                        //                   context: context,
                                        //                   driverId: order[0]
                                        //                       .driverId!,
                                        //                   acceptedOrderId: order[
                                        //                           0]
                                        //                       .acceptedOrderId!,
                                        //                   to: order[0]
                                        //                       .driverFcmToken!,
                                        //                   clientName: order[0]
                                        //                       .clientName!,
                                        //                   clientId: order[0]
                                        //                       .clientId!,
                                        //                   orderId:
                                        //                       order[0].orderId!,
                                        //                 );
                                        //                 Fluttertoast.showToast(
                                        //                   msg: locale.Translate(
                                        //                       'Deleted successfully'),
                                        //                   backgroundColor:
                                        //                       Colors.green,
                                        //                 ).then((value) {
                                        //                   navigatePop(
                                        //                       context: context);
                                        //                 });
                                        //               },
                                        //             ),
                                        //           ],
                                        //         ),
                                        //       );
                                        //     }
                                        //   },
                                        // ),
                                        /////////////////////////////////////////////////
                                        // BuildButton(
                                        //   onPressed: () {
                                        //     if(DateTime.now().difference(order[0].dateToDeleteTheAgreement).inDays ==0){
                                        //       print('Can\'t delete the agree ');
                                        //     }
                                        //     else{
                                        //       print('deleted');
                                        //     }
                                        //   },
                                        //   label: locale.Translate('Delete the agreement'),
                                        // ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                : Center(
                    child: CircularProgressIndicator(),
                  ),
          );
        },
      );
    });
  }
}
