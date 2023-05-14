import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rate/rate.dart';
import 'package:uber_final/app_localization.dart';
import 'package:uber_final/cashe_helper/cashe_helper.dart';
import 'package:uber_final/data_models/offer_data_model.dart';
import 'package:uber_final/data_models/order_data_model.dart';
import 'package:uber_final/data_models/rate_data_model.dart';
import 'package:uber_final/screens/clients/all_driver_rates.dart';
import 'package:uber_final/screens/clients/all_offers_screen.dart';
import 'package:uber_final/screens/drivers/location_of_order_screen.dart';
import 'package:uber_final/screens/drivers/make_offer_screen.dart';
import 'package:uber_final/uber_cubit/uber_cubit.dart';

class BuildTextFormField extends StatelessWidget {
  String label;

  IconData pIcon;
  IconData? sIcon;
  bool? isPassword;
  TextInputType? type;
  void Function()? onPressedOnPIcon;
  void Function()? onPressedOnSIcon;
  String? Function(String?)? validation;
  TextEditingController controller;
  Color? pIconColor;

  BuildTextFormField({
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
  void Function()? onPressed;
  double height;

  double width;
  String label;
  Color color;

  BuildButton({
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
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class BuildTextButton extends StatelessWidget {
  String label;

  void Function()? onPressed;

  BuildTextButton({
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(
        label,
      ),
      onPressed: onPressed,
    );
  }
}

navigate({
  required Widget screen,
  required BuildContext context,
}) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => screen),
  );
}

navigateAndFinish({
  required Widget screen,
  required BuildContext context,
}) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => screen),
    (route) => false,
  );
}

navigatePop({
  required BuildContext context,
}) {
  Navigator.pop(context);
}

class BuildClientOrderItem extends StatelessWidget {
  OrderDataModel order;

  BuildClientOrderItem({
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        navigate(
            screen: AllOffersScreen(
              orderId: this.order.orderId!,
            ),
            context: context);
      },
      child: Card(
        elevation: 15,
        child: Container(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * .05),
          // decoration: BoxDecoration(
          //     border: Border.all(
          //   color: Colors.black,
          // )),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: 2)),
                child: CircleAvatar(
                  radius: 40,
                  child: Text(
                    '${order.time}',
                  ),
                  backgroundColor: Colors.white,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                        ),
                        Text(
                            " ${AppLocalizations.of(context)!.Translate('From')} : ${order.from}"),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                        ),
                        Text(
                            " ${AppLocalizations.of(context)!.Translate('To')} : ${order.to}"),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.date_range_outlined,
                        ),
                        Text(
                            " ${AppLocalizations.of(context)!.Translate('Date')} : ${order.date}"),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.phone_android,
                        ),
                        Text(
                            " ${AppLocalizations.of(context)!.Translate('Phone')} : ${order.clientPhone}"),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BuildDriverOrderItem extends StatelessWidget {
  OrderDataModel order;

  BuildDriverOrderItem({
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        navigate(screen: MakeOfferScreen(this.order), context: context);
        print(this.order.time);
      },
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Card(
          elevation: 15,
          child: Container(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * .05),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(
                    order.clientImage!,
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      order.clientName!,
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            fontSize: 20,
                          ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                        ),
                        Text(
                            " ${AppLocalizations.of(context)!.Translate('From')} : ${order.from} "),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                        ),
                        Text(
                            " ${AppLocalizations.of(context)!.Translate('To')} : ${order.to} "),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.date_range_outlined,
                        ),
                        Text(
                            " ${AppLocalizations.of(context)!.Translate('Date')} : ${order.date} "),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.watch_later_outlined,
                        ),
                        Text(
                            " ${AppLocalizations.of(context)!.Translate('Time')} : ${order.time} "),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.phone_android,
                        ),
                        Text(
                            " ${AppLocalizations.of(context)!.Translate('Phone')} : ${order.clientPhone} "),
                      ],
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

class BuildDriverAcceptedOrderItem extends StatelessWidget {
  OrderDataModel order;

  BuildDriverAcceptedOrderItem({
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
      child: Card(
        elevation: 15,
        child: Container(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * .05),
          child: Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(
                  order.clientImage!,
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    order.clientName!,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          fontSize: 20,
                        ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                      ),
                      Text(
                          " ${AppLocalizations.of(context)!.Translate('From')} : ${order.from} "),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                      ),
                      Text(
                          " ${AppLocalizations.of(context)!.Translate('To')} : ${order.to} "),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.date_range_outlined,
                      ),
                      Text(
                          " ${AppLocalizations.of(context)!.Translate('Date')} : ${order.date} "),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.watch_later_outlined,
                      ),
                      Text(
                          " ${AppLocalizations.of(context)!.Translate('Time')} : ${order.time} "),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.phone_android,
                      ),
                      Text(
                          " ${AppLocalizations.of(context)!.Translate('Phone')} : ${order.clientPhone} "),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  BuildTextButton(
                    label: AppLocalizations.of(context)!.Translate('Delete the agreement'),
                    onPressed: () {
                      if (DateTime.parse(order.dateToDeleteTheAgreement)
                              .difference(
                                  DateTime.parse(DateTime.now().toString()))
                              .inDays ==
                          0) {
                        Fluttertoast.showToast(
                          msg: AppLocalizations.of(context)!.Translate('can\'t be deleted'),
                          backgroundColor: Colors.red,
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            content: Text(AppLocalizations.of(context)!.Translate('Are you sure ?')),
                            actions: [
                              BuildTextButton(
                                label: AppLocalizations.of(context)!.Translate('Confirm'),
                                onPressed: () {
                                  UberCubit.get(context).DeleteOrderFromDriver(
                                    driverId: CasheHelper.GetData(key: 'uId'),
                                    acceptedOrderId: order.acceptedOrderId!,
                                    to: order.fcmToken!,
                                    driverName: order.driverName!,
                                    clientId: order.clientId!,
                                    orderId: order.orderId!,
                                  );
                                  Fluttertoast.showToast(
                                    msg: AppLocalizations.of(context)!.Translate('Deleted successfully'),
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
    );
  }
}

class BuildOfferItem extends StatelessWidget {
  OfferDataModel offer;

  OrderDataModel order;

  BuildOfferItem({
    required this.offer,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Card(
        elevation: 15,
        child: Container(
          padding: EdgeInsets.all(30),
          child: Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(
                  offer.driverImage!,
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    offer.driverName!,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          fontSize: 20,
                        ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Text(
                        '${offer.price} \$',
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              fontSize: 17,
                            ),
                      ),
                      SizedBox(
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

                          UberCubit.get(context).AcceptOffer(
                            order: order,
                            offer: offer,
                            context: context,
                            dateToDeleteTheAgreement:
                                order.dateToDeleteTheAgreement,
                          );
                        },
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.green,
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      InkWell(
                        onTap: () {
                          UberCubit.get(context).RejectOffer(
                            orderId: order.orderId!,
                            offerId: offer.offerId!,
                            to: offer.driverFcmToken!,
                            clientName: order.clientName!,
                            context: context,
                          );
                        },
                        child: CircleAvatar(
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
                  SizedBox(
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
                        .Translate('Show Driver Rates'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BuildClientRateItem extends StatelessWidget {
  RateDataModel rate;

  BuildClientRateItem({required this.rate});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Card(
        elevation: 15,
        child: Container(
          padding: EdgeInsets.all(25),
          child: Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(
                  rate.clientImage!,
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    rate.clientName!,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
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
    );
  }
}
//////////////
