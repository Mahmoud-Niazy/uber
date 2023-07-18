import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rate/rate.dart';
import 'package:uber_final/core/app_localization.dart';
import 'package:uber_final/features/chat/presentation/chat_screen.dart';
import 'package:uber_final/uber_cubit/uber_cubit.dart';
import '../../features/clients/presentation/all_driver_rates.dart';
import '../../features/clients/presentation/all_offers_screen.dart';
import '../../features/drivers/presentation/location_of_order_screen.dart';
import '../../features/drivers/presentation/make_offer_screen.dart';
import '../cashe_helper/cashe_helper.dart';
import '../data_models/offer_data_model.dart';
import '../data_models/order_data_model.dart';
import '../data_models/rate_data_model.dart';
import '../functions/functions.dart';

class BuildTextFormField extends StatelessWidget {
  final String label;

  final IconData pIcon;
  final IconData? sIcon;
  final bool? isPassword;
  final TextInputType? type;
  final void Function()? onPressedOnPIcon;
  final void Function()? onPressedOnSIcon;
  final String? Function(String?)? validation;
  final TextEditingController controller;
  final Color? pIconColor;

  const BuildTextFormField({
    super.key,
    required this.label,
    required this.pIcon,
    this.sIcon,
    this.isPassword = false,
    this.onPressedOnSIcon,
    this.onPressedOnPIcon,
    this.validation,
    this.type,
    required this.controller,
    this.pIconColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        label: Text(
          label,
        ),
        prefixIcon: IconButton(
          icon: Icon(
            pIcon,
            color: pIconColor,
          ),
          onPressed: onPressedOnPIcon,
        ),
        suffixIcon: IconButton(
          icon: Icon(sIcon),
          onPressed: onPressedOnSIcon,
        ),
      ),
      validator: validation,
      obscureText: isPassword!,
      keyboardType: type,
      controller: controller,
    );
  }
}

class BuildButton extends StatelessWidget {
  final void Function()? onPressed;
  final double height;

  final double width;
  final String label;
  final Color color;

  const BuildButton({
    super.key,
    required this.onPressed,
    this.height = 55,
    this.width = double.infinity,
    required this.label,
    this.color = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: color,
      ),
      child: MaterialButton(
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class BuildTextButton extends StatelessWidget {
  final String label;

  final void Function()? onPressed;

  const BuildTextButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        label,
      ),
    );
  }
}

class PageTransition extends PageRouteBuilder {
  late Widget page;

  PageTransition(this.page)
      : super(pageBuilder: (context, animation1, animation2) {
          return page;
        }, transitionsBuilder: (context, animation1, animation2, child) {
          return SlideTransition(
            position: animation1.drive(Tween<Offset>(
              begin: const Offset(-1, 0),
              end: const Offset(0, 0),
            )),
            child: child,
          );
        });
}

class BuildClientOrderItem extends StatelessWidget {
  final OrderDataModel order;

  const BuildClientOrderItem({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        navigate(
            screen: AllOffersScreen(
              orderId: order.orderId!,
            ),
            context: context);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Card(
          elevation: 8,
          child: Container(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * .05),
            decoration: const BoxDecoration(
              color: Color(0xffe3f2fd),
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 40,
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: CachedNetworkImage(
                      imageUrl: order.clientImage!,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                // CircleAvatar(
                //   radius: 40,
                //   backgroundImage: NetworkImage(
                //     order.clientImage!,
                //   ),
                // ),
                // Container(
                //   decoration: BoxDecoration(
                //       shape: BoxShape.circle,
                //       border: Border.all(color: Colors.black, width: 2)),
                //   child: CircleAvatar(
                //     radius: 40,
                //     child: Text(
                //       '${order.time}',
                //     ),
                //     backgroundColor: Colors.white,
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  // Expanded Here is the problem
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            color: Colors.black45,
                          ),
                          Text(
                              " ${AppLocalizations.of(context)!.translate('From')} : ${order.from}"),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            color: Colors.black45,
                          ),
                          Text(
                              " ${AppLocalizations.of(context)!.translate('To')} : ${order.to}"),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.date_range_outlined,
                            color: Colors.black45,
                          ),
                          Text(
                              " ${AppLocalizations.of(context)!.translate('Date')} : ${order.date}"),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.watch_later_outlined,
                            color: Colors.black45,
                          ),
                          Text(
                              " ${AppLocalizations.of(context)!.translate('Time')} : ${order.time}"),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.phone_android,
                            color: Colors.black45,
                          ),
                          Text(
                              " ${AppLocalizations.of(context)!.translate('Phone')} : ${order.clientPhone}"),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      if (order.agreement == true)
                        BuildTextButton(
                          label: AppLocalizations.of(context)!
                              .translate('Delete the agreement'),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                content: Text(
                                  AppLocalizations.of(context)!
                                      .translate('Are you sure ?'),
                                ),
                                actions: [
                                  BuildTextButton(
                                    label: AppLocalizations.of(context)!
                                        .translate('Confirm'),
                                    onPressed: () {
                                      UberCubit.get(context)
                                          .deleteOrderFromClient(
                                        context: context,
                                        driverId: order.driverId!,
                                        acceptedOrderId:
                                            order.acceptedOrderId!,
                                        to: order.driverFcmToken!,
                                        clientName: order.clientName!,
                                        clientId: order.clientId!,
                                        orderId: order.orderId!,
                                      );
                                      Fluttertoast.showToast(
                                        msg: AppLocalizations.of(context)!
                                            .translate(
                                                'Deleted successfully'),
                                        backgroundColor: Colors.green,
                                      ).then((value) {
                                        navigatePop(context: context);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            );
                            //   if (DateTime.parse(order
                            //       .dateToDeleteTheAgreement)
                            //       .difference(DateTime.parse(
                            //       DateTime.now()
                            //           .toString()))
                            //       .inDays ==
                            //       0) {
                            //     Fluttertoast.showToast(
                            //       msg: AppLocalizations.of(context)!.Translate(
                            //           'can\'t be deleted'),
                            //       backgroundColor: Colors.red,
                            //     );
                            //   } else {
                            //     showDialog(
                            //       context: context,
                            //       builder: (context) =>
                            //           AlertDialog(
                            //             content: Text(
                            //               AppLocalizations.of(context)!.Translate(
                            //                   'Are you sure ?'),
                            //             ),
                            //             actions: [
                            //               BuildTextButton(
                            //                 label: AppLocalizations.of(context)!.Translate(
                            //                     'Confirm'),
                            //                 onPressed: () {
                            //                   UberCubit.get(context)
                            //                       .DeleteOrderFromClient(
                            //                     context: context,
                            //                     driverId: order
                            //                         .driverId!,
                            //                     acceptedOrderId: order
                            //                         .acceptedOrderId!,
                            //                     to: order
                            //                         .driverFcmToken!,
                            //                     clientName: order
                            //                         .clientName!,
                            //                     clientId: order
                            //                         .clientId!,
                            //                     orderId:
                            //                     order.orderId!,
                            //                   );
                            //                   Fluttertoast.showToast(
                            //                     msg: AppLocalizations.of(context)!.Translate(
                            //                         'Deleted successfully'),
                            //                     backgroundColor:
                            //                     Colors.green,
                            //                   ).then((value) {
                            //                     navigatePop(
                            //                         context: context);
                            //                   });
                            //                 },
                            //               ),
                            //             ],
                            //           ),
                            //     );
                            //   }
                          },
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
  }
}

class BuildDriverOrderItem extends StatelessWidget {
  final OrderDataModel order;

  const BuildDriverOrderItem({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        navigate(screen: MakeOfferScreen(order), context: context);
      },
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Card(
            elevation: 8,
            child: Container(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: const BoxDecoration(
                color: Color(0xffe3f2fd),
              ),
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * .05),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 40,
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: CachedNetworkImage(
                        imageUrl: order.clientImage!,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        order.clientName!,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontSize: 20,
                            ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            color: Colors.black45,
                          ),
                          Text(
                              " ${AppLocalizations.of(context)!.translate('From')} : ${order.from} "),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            color: Colors.black45,
                          ),
                          Text(
                              " ${AppLocalizations.of(context)!.translate('To')} : ${order.to} "),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.date_range_outlined,
                            color: Colors.black45,
                          ),
                          Text(
                              " ${AppLocalizations.of(context)!.translate('Date')} : ${order.date} "),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.watch_later_outlined,
                            color: Colors.black45,
                          ),
                          Text(
                              " ${AppLocalizations.of(context)!.translate('Time')} : ${order.time} "),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.phone_android,
                            color: Colors.black45,
                          ),
                          Text(
                              " ${AppLocalizations.of(context)!.translate('Phone')} : ${order.clientPhone} "),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BuildDriverAcceptedOrderItem extends StatelessWidget {
  final OrderDataModel order;

  const BuildDriverAcceptedOrderItem({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        navigate(screen: LocationOfOrderScreen(order: order), context: context);
        // navigate(screen: MakeOfferScreen(this.order), context: context);
        // print(this.order.time);
      },
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Card(
            elevation: 8,
            child: Container(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: const BoxDecoration(
                color: Color(0xffe3f2fd),
              ),
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * .05),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: CachedNetworkImage(
                        imageUrl: order.clientImage!,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        order.clientName!,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontSize: 20,
                            ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            color: Colors.black45,
                          ),
                          Text(
                              " ${AppLocalizations.of(context)!.translate('From')} : ${order.from} "),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            color: Colors.black45,
                          ),
                          Text(
                              " ${AppLocalizations.of(context)!.translate('To')} : ${order.to} "),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.date_range_outlined,
                            color: Colors.black45,
                          ),
                          Text(
                              " ${AppLocalizations.of(context)!.translate('Date')} : ${order.date} "),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.watch_later_outlined,
                            color: Colors.black45,
                          ),
                          Text(
                              " ${AppLocalizations.of(context)!.translate('Time')} : ${order.time} "),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.phone_android,
                          ),
                          Text(
                              " ${AppLocalizations.of(context)!.translate('Phone')} : ${order.clientPhone} "),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      BuildTextButton(
                        onPressed: () {
                          navigate(screen: ChatScreen(order), context: context);
                        },
                        label: AppLocalizations.of(context)!.translate('Chat'),
                      ),

                      BuildTextButton(
                        label: AppLocalizations.of(context)!
                            .translate('Delete the agreement'),
                        onPressed: () {
                          if (DateTime.parse(order.dateToDeleteTheAgreement)
                                  .difference(
                                      DateTime.parse(DateTime.now().toString()))
                                  .inDays ==
                              0) {
                            Fluttertoast.showToast(
                              msg: AppLocalizations.of(context)!
                                  .translate('can\'t be deleted'),
                              backgroundColor: Colors.red,
                            );
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                content: Text(AppLocalizations.of(context)!
                                    .translate('Are you sure ?')),
                                actions: [
                                  BuildTextButton(
                                    label: AppLocalizations.of(context)!
                                        .translate('Confirm'),
                                    onPressed: () {
                                      UberCubit.get(context)
                                          .deleteOrderFromDriver(
                                        driverId:
                                            CasheHelper.getData(key: 'uId'),
                                        acceptedOrderId: order.acceptedOrderId!,
                                        to: order.fcmToken!,
                                        driverName: order.driverName!,
                                        clientId: order.clientId!,
                                        orderId: order.orderId!,
                                        context: context,
                                      );
                                      Fluttertoast.showToast(
                                        msg: AppLocalizations.of(context)!
                                            .translate('Deleted successfully'),
                                        backgroundColor: Colors.green,
                                      ).then((value) {
                                        navigatePop(context: context);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                      ),
                      // BuildButton(
                      //   onPressed: (){
                      //     if(DateTime.now().difference(order.dateToDeleteTheAgreement).inDays ==0){
                      //       print('Can\'t delete the agree ');
                      //     }
                      //     else{
                      //       print('deleted');
                      //     }
                      //   },
                      //   label: 'Delete the agreement',
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BuildOfferItem extends StatelessWidget {
  final OfferDataModel offer;

  final OrderDataModel order;

  const BuildOfferItem({
    super.key,
    required this.offer,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Card(
          elevation: 15,
          child: Container(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: const BoxDecoration(
              color: Color(0xffe3f2fd),
            ),
            padding: const EdgeInsets.all(30),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 50,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 40,
                    child: Container(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,

                      ),
                      child: CachedNetworkImage(
                        imageUrl: offer.driverImage!,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      offer.driverName!,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontSize: 20,
                          ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Text(
                          '${offer.price} \$',
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                fontSize: 17,
                              ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        InkWell(
                          onTap: () {
                            // OrderDataModel newOrder = OrderDataModel(
                            //   date: order!.date,
                            //   time: order!.time,
                            //   from: order!.from,
                            //   to: order!.to,
                            //   clientName: order!.clientName,
                            //   clientImage: order!.clientImage,
                            //   latFrom: order!.latFrom,
                            //   latTo: order!.latTo,
                            //   lngFrom: order!.lngFrom,
                            //   lngTo: order!.lngTo,
                            //   fcmToken: order!.fcmToken,
                            //   orderId: order!.orderId,
                            //   agreement: true,
                            // );
                            // FirebaseFirestore.instance
                            // .collection('clients')
                            // .doc(CasheHelper.GetData(key: 'uId'))
                            //     .collection('orders')
                            //     .doc(order!.orderId)
                            // .update(newOrder.toMap()).then((value){
                            //
                            // });

                            UberCubit.get(context).acceptOffer(
                              order: order,
                              offer: offer,
                              context: context,
                              dateToDeleteTheAgreement:
                                  order.dateToDeleteTheAgreement,
                            );
                          },
                          child: const CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.green,
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        InkWell(
                          onTap: () {
                            UberCubit.get(context).rejectOffer(
                              orderId: order.orderId!,
                              offerId: offer.offerId!,
                              to: offer.driverFcmToken!,
                              clientName: order.clientName!,
                              context: context,
                            );
                          },
                          child: const CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.red,
                            child: Icon(
                              Icons.disabled_by_default_outlined,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    BuildTextButton(
                      onPressed: () {
                        navigate(
                            screen: AllDriverRates(
                              offer.driverId!,
                            ),
                            context: context);
                      },
                      label: AppLocalizations.of(context)!
                          .translate('Show Driver Rates'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BuildClientRateItem extends StatelessWidget {
  final RateDataModel rate;

  const BuildClientRateItem({super.key, required this.rate});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Card(
          elevation: 15,
          child: Container(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: const Color(0xffe3f2fd),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: Container(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: CachedNetworkImage(
                      imageUrl: rate.clientImage!,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      rate.clientName!,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Rate(
                      initialValue: rate.rate!,
                      readOnly: true,
                      iconSize: 25,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
//////////////
