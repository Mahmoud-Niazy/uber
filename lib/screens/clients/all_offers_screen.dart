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
  final String orderId;
   double rate = 3.5;

   AllOffersScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      UberCubit.get(context).getAllOffers(orderId: orderId);

      return BlocConsumer<UberCubit, UberStates>(
        listener: (context, state) {
          if (state is RateDriverSuccessfullyState) {
            Fluttertoast.showToast(
              msg:
                  AppLocalizations.of(context)!.translate('Rated Successfully'),
              backgroundColor: Colors.green,
            );
          }
          if (state is DeleteOrderFromClientSuccessfullyState) {
            navigate(screen: const LayoutForClient(), context: context);
          }
        },
        builder: (context, state) {
          var cubit = UberCubit.get(context);
          var locale = AppLocalizations.of(context)!;
          List<OrderDataModel> order =
              UberCubit.get(context).orders.where((element) {
            return element.orderId == orderId;
          }).toList();
          return Scaffold(
            appBar: AppBar(),
            body: order[0] != null
                ? order[0].agreement == false
                    ? cubit.offers.isNotEmpty
                        ? ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) => BuildOfferItem(
                              offer: cubit.offers[index],
                              order: order[0],
                            ),
                            separatorBuilder: (context, index) => const SizedBox(
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
                                  locale.translate('There is no offers yet'),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          )
                    : Center(
                        child: Card(
                          margin: const EdgeInsets.all(20),
                          elevation: 10,
                          child: Container(
                            padding: EdgeInsets.all(
                                MediaQuery.of(context).size.width * .05),
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '${locale.translate('There is an agreement with')} : ',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(
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
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Text(
                                          order[0].driverName!,
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '${locale.translate('Price')} :   ',
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              order[0].price! + '\$',
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '${locale.translate('Phone')} :   ',
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              order[0].driverPhone!,
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 50,
                                        ),
                                        Text(
                                          locale.translate('Rate the driver'),
                                          style: const TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                        const SizedBox(
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
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        state is RateDriverLoadingState
                                            ? const Center(
                                                child:
                                                    CircularProgressIndicator())
                                            : BuildButton(
                                                onPressed: () {
                                                  cubit.rateDriver(
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
                                                label: locale.translate(
                                                    'Confirm rate'),
                                              ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        BuildButton(
                                          label: locale.translate('Chat'),
                                          onPressed: () {
                                            navigate(
                                              screen: ChatScreen(order[0]),
                                              context: context,
                                            );
                                          },
                                        ),
                                        const SizedBox(
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
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          );
        },
      );
    });
  }
}
