import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:uber_final/core/app_localization.dart';
import 'package:uber_final/features/clients/data/models/client_data_model.dart';
import 'package:uber_final/features/drivers/data/models/driver_data_model.dart';
import 'package:uber_final/features/chat/data/models/messege_data_model.dart';
import 'package:uber_final/uber_cubit/uber_states.dart';
import '../core/api_services/api_services.dart';
import '../core/cashe_helper/cashe_helper.dart';
import '../core/data_models/offer_data_model.dart';
import '../core/data_models/order_data_model.dart';
import '../core/data_models/rate_data_model.dart';
import '../features/clients/presentation/client_orders_screen.dart';
import '../features/clients/presentation/client_setting_screen.dart';
import '../features/clients/presentation/make_order_screen.dart';
import '../features/drivers/presentation/accepted_orders_screen.dart';
import '../features/drivers/presentation/driver_orders_screen.dart';
import '../features/drivers/presentation/driver_setting_screen.dart';


class UberCubit extends Cubit<UberStates> {
  UberCubit() : super(UberInitialState());

  static UberCubit get(context) => BlocProvider.of(context);

  int currentIndexInClientsLayout = 0;

  bottomNavigationInClientsLayout(int index) {
    currentIndexInClientsLayout = index;
    emit(BottomNavigationState());
  }

  List<Widget> screensInClientsLayout = [
    const ClientOrdersScreen(),
    MakeOrderScreen(),
    const ClientSettingScreen(),
  ];

  List<String> titlesForClient = [
    'Your Orders',
    'Make Your order',
    'Your information',
  ];

  List<String> titlesForDriver = [
    'All Orders',
    'Your accepted orders',
    'Your information',
  ];

  DriverDataModel? driver;
  ClientDataModel? client;

  getUserData({
    String? userId,
  }) {
    emit(GetUserDataLoadingState());
    if (CasheHelper.getData(key: 'isDriver')) {
      FirebaseFirestore.instance
          .collection('drivers')
          .doc(userId)
          .get()
          .then((value) {
        driver = DriverDataModel.fromJson(value.data()!);
        FirebaseMessaging.instance.getToken().then((fcmToken) {
          driver = DriverDataModel(
            phone: driver!.phone,
            email: driver!.email,
            name: driver!.name,
            image: driver!.image,
            userId: driver!.userId,
            fcmToken: fcmToken,
          );
          FirebaseFirestore.instance
              .collection('drivers')
              .doc(userId)
              .update(driver!.toMap());
        });
        emit(GetDriverDataSuccessfullyState());
      }).catchError((error) {
        emit(GetDriverDataErrorState());
      });
    } else {
      FirebaseFirestore.instance
          .collection('clients')
          .doc(userId)
          .get()
          .then((value) {
        client = ClientDataModel.fromJson(value.data()!);
        FirebaseMessaging.instance.getToken().then((fcmToken) {
          client = ClientDataModel(
            phone: client!.phone,
            email: client!.email,
            name: client!.name,
            image: client!.image,
            userId: client!.userId,
            fcmToken: fcmToken,
          );
          FirebaseFirestore.instance
              .collection('clients')
              .doc(userId)
              .update(client!.toMap());
        });
        emit(GetClientDataSuccessfullyState());
      }).catchError((error) {
        emit(GetClientDataErrorState());
      });
    }
  }

  double latitude = 0;

  double longitude = 0;

  double dLat = 0;
  double dLng = 0;

  var clientLocation;

  Future<Position> getUserLocation() async {
    emit(GetClientLocationErrorState());
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    clientLocation = await Geolocator.getCurrentPosition();
    latitude = clientLocation.latitude;
    longitude = clientLocation.longitude;

    dLat = clientLocation.latitude;
    dLng = clientLocation.longitude;

    return clientLocation;
  }

  var marker = HashSet<Marker>();
  int i = 0;
  bool isFrom = true;

  LatLng? positionFrom;

  LatLng? from;
  TextEditingController fromController = TextEditingController();

  LatLng? positionTo;

  LatLng? to;
  TextEditingController toController = TextEditingController();

  confirmFrom() async {
    if (isFrom) {
      from = positionFrom;
      List<Placemark> placemarks =
          await placemarkFromCoordinates(from!.latitude, from!.longitude);
      fromController.text = placemarks[0].locality!;
      isFrom = false;
      emit(ConfirmState());
    } else {
      to = positionTo;
      List<Placemark> placemarks =
          await placemarkFromCoordinates(to!.latitude, to!.longitude);
      toController.text = placemarks[0].locality!;
      emit(ConfirmState());
    }
    marker.clear();
  }

  addMark(LatLng position) {
    marker.clear();
    marker.add(Marker(
      position: position,
      markerId: MarkerId('$i'),
    ));
    i++;
    emit(AddMarkState());
  }

  makeOrder({
    required String time,
    required String date,
    required String fromPlace,
    required String toPlace,
    required dynamic dateToDeleteTheAgreement,
    required String dateToOrder,
  }) {
    emit(MakeOrderLoadingState());
    OrderDataModel order = OrderDataModel(
      date: date,
      time: time,
      from: fromPlace,
      to: toPlace,
      clientName: client!.name,
      clientImage: client!.image,
      latFrom: from!.latitude,
      lngFrom: from!.longitude,
      latTo: to!.latitude,
      lngTo: to!.longitude,
      fcmToken: client!.fcmToken,
      agreement: false,
      dateToDeleteTheAgreement: dateToDeleteTheAgreement,
      clientPhone: client!.phone,
      dateToOrder: dateToOrder,
    );
    FirebaseFirestore.instance
        .collection('clients')
        .doc(CasheHelper.getData(key: 'uId'))
      ..collection('orders').add(order.toMap()).then((value1) {
        order = OrderDataModel(
          date: date,
          time: time,
          from: fromPlace,
          to: toPlace,
          clientName: client!.name,
          clientImage: client!.image,
          latFrom: from!.latitude,
          lngFrom: from!.longitude,
          latTo: to!.latitude,
          lngTo: to!.longitude,
          fcmToken: client!.fcmToken,
          orderId: value1.id,
          agreement: false,
          dateToDeleteTheAgreement: dateToDeleteTheAgreement,
          clientPhone: client!.phone,
          dateToOrder: dateToOrder,
        );
        FirebaseFirestore.instance
            .collection('clients')
            .doc(CasheHelper.getData(key: 'uId'))
          ..collection('orders')
              .doc(value1.id)
              .update(order.toMap())
              .then((value) {});

        FirebaseFirestore.instance
            .collection('orders')
            .doc(value1.id)
            .set(order.toMap())
            .then((valueWithId) {
          order = OrderDataModel(
            date: date,
            time: time,
            from: fromPlace,
            to: toPlace,
            clientName: client!.name,
            clientImage: client!.image,
            latFrom: from!.latitude,
            lngFrom: from!.longitude,
            latTo: to!.latitude,
            lngTo: to!.longitude,
            fcmToken: client!.fcmToken,
            orderId: value1.id,
            agreement: false,
            dateToDeleteTheAgreement: dateToDeleteTheAgreement,
            clientPhone: client!.phone,
            dateToOrder: dateToOrder,
          );

          FirebaseFirestore.instance
              .collection('orders')
              .doc(value1.id)
              .update(order.toMap());

          emit(MakeOrderSuccessfullyState());
          isFrom = true;
        });
      }).catchError((error) {
        emit(MakeOrderErrorState());
      });
  }

  List<OrderDataModel> orders = [];

  getClientOrders() {
    emit(GetClientOrdersLoadingState());
    FirebaseFirestore.instance
        .collection('clients')
        .doc(CasheHelper.getData(key: 'uId'))
        .collection('orders')
        .orderBy('dateToOrder')
        .snapshots()
        .listen((value) {
      orders = [];
      value.docs.forEach((element) {
        orders.add(OrderDataModel.fromJson(element.data()));
      });
      emit(GetClientOrdersSuccessfullyState());
    });
  }

  int currentIndexInDriversLayout = 0;

  bottomNavigationInDriversLayout(int index) {
    currentIndexInDriversLayout = index;
    emit(BottomNavigationState());
  }

  List<Widget> screensInDriversLayout = [
    const DriverOrderScreen(),
    const AcceptedOrdersScreen(),
    const DriverSettingScreen(),
  ];

  sendNotificationToAlldrivers({
    required String clientName,
    required BuildContext context,
  }) {
    emit(SendNotificationToAllDriversLoadingState());
    DioHelper.postData(url: 'send', data: {
      "to": "/topics/drivers",
      "priority": "high",
      "notification": {
        "body":
            "$clientName ${AppLocalizations.of(context)!.translate('make an order')}",
        "title": "New order for you",
        "subtitle": "Firebase Cloud Message Subtitle"
      }
    }).then((value) {
      emit(SendNotificationToAllDriversSuccessfullyState());
    }).catchError((error) {
      emit(SendNotificationToAllDriversErrorState());
    });
  }

  List<OrderDataModel> allOrders = [];

  getAllOrders() {
    if (CasheHelper.getData(key: 'isDriver')) {
      emit(GetAllOrdersLoadingState());
      FirebaseFirestore.instance
          .collection('orders')
          .orderBy('dateToOrder',descending:true, )
          .snapshots()
          .listen((event) {
        allOrders = [];
        event.docs.forEach((element) {
          allOrders.add(OrderDataModel.fromJson(element.data()));
        });
        emit(GelAllOrdersSuccessfullyState());
      });
    }
    return 1;
  }

  makeOffer({
    required String orderId,
    required dynamic price,
    required String clientFcmToken,
    required BuildContext context,
  }) {
    emit(MakeOfferLoadingState());

    DioHelper.postData(
      url: 'send',
      data: {
        "to": clientFcmToken,
        "priority": "high",
        "notification": {
          "body": driver!.name +
              ' ' +
              "${AppLocalizations.of(context)!.translate('send an offer')} ",
          "title": "$price \$ ",
          "subtitle": ""
        }
      },
    ).then((value) {
      emit(SendNotificationToClientSuccessfullyState());
      OfferDataModel offer = OfferDataModel(
        driverEmail: driver!.email,
        driverFcmToken: driver!.fcmToken,
        driverName: driver!.name,
        driverPhone: driver!.phone,
        price: price,
        driverImage: driver!.image,
        driverId: driver!.userId,
      );

      FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .collection('offers')
          .add(offer.toMap())
          .then((value) {
        offer = OfferDataModel(
          driverEmail: driver!.email,
          driverFcmToken: driver!.fcmToken,
          driverName: driver!.name,
          driverPhone: driver!.phone,
          price: price,
          driverImage: driver!.image,
          driverId: driver!.userId,
          offerId: value.id,
        );
        FirebaseFirestore.instance
            .collection('orders')
            .doc(orderId)
            .collection('offers')
            .doc(value.id)
            .update(offer.toMap());
        emit(MakeOfferSuccessfullyState());
      }).catchError((error) {
        print(error);
        emit(MakeOfferErrorState());
      });
    }).catchError((error) {
      print(error);
      emit(SendNotificationToClientErrorState());
    });
  }

  List<OfferDataModel> offers = [];

  getAllOffers({
    required String orderId,
  }) {
    offers = [];
    emit(GetAllOffersLoadingState());
    FirebaseFirestore.instance
        .collection('orders')
        .doc(orderId)
        .collection('offers')
        .snapshots()
        .listen((value) {
      offers = [];
      value.docs.forEach((element) {
        offers.add(OfferDataModel.fromJson(element.data()));
        emit(GetAllOffersSuccessfullyState());
      });
    });
  }

  acceptOffer({
    required OrderDataModel order,
    OfferDataModel? offer,
    required BuildContext context,
    required dynamic dateToDeleteTheAgreement,
  }) {
    emit(AcceptedOfferLoadingState());

    OrderDataModel newOrder = OrderDataModel(
      date: order.date,
      time: order.time,
      from: order.from,
      to: order.to,
      dateToOrder: order.dateToOrder,
      clientName: order.clientName,
      clientImage: order.clientImage,

      latFrom: order.latFrom,
      latTo: order.latTo,
      lngFrom: order.lngFrom,
      lngTo: order.lngTo,
      fcmToken: order.fcmToken,
      orderId: order.orderId,
      agreement: true,
      driverImage: offer!.driverImage,
      driverEmail: offer.driverEmail,
      driverFcmToken: offer.driverFcmToken,
      driverName: offer.driverName,
      driverPhone: offer.driverPhone,
      price: offer.price,
      driverId: offer.driverId,
      clientId: CasheHelper.getData(key: 'uId'),
      dateToDeleteTheAgreement: dateToDeleteTheAgreement,
      clientPhone: client!.phone,
    );

    FirebaseFirestore.instance.collection('orders').doc(order.orderId).delete();
    FirebaseFirestore.instance
        .collection('drivers')
        .doc(offer.driverId)
        .collection('acceptedOrders')
        .add(newOrder.toMap())
        .then((value) {
      newOrder = OrderDataModel(
        date: order.date,
        time: order.time,
        from: order.from,
        dateToOrder: order.dateToOrder,
        to: order.to,
        clientName: order.clientName,
        clientImage: order.clientImage,
        latFrom: order.latFrom,
        latTo: order.latTo,
        lngFrom: order.lngFrom,
        lngTo: order.lngTo,
        fcmToken: order.fcmToken,
        orderId: order.orderId,
        agreement: true,
        driverImage: offer.driverImage,
        driverEmail: offer.driverEmail,
        driverFcmToken: offer.driverFcmToken,
        driverName: offer.driverName,
        driverPhone: offer.driverPhone,
        price: offer.price,
        driverId: offer.driverId,
        clientId: CasheHelper.getData(key: 'uId'),
        dateToDeleteTheAgreement: dateToDeleteTheAgreement,
        acceptedOrderId: value.id,
        clientPhone: client!.phone,
      );
      FirebaseFirestore.instance
          .collection('drivers')
          .doc(offer.driverId)
          .collection('acceptedOrders')
          .doc(value.id)
          .update(newOrder.toMap());

      FirebaseFirestore.instance
          .collection('clients')
          .doc(CasheHelper.getData(key: 'uId'))
          .collection('orders')
          .doc(order.orderId)
          .update(newOrder.toMap());
    });

    //     .then((value) {
    //   GetClientOrders();
    emit(AcceptedOfferSuccessfullyState());
    // });

    sendNotification(
      to: newOrder.driverFcmToken!,
      title: newOrder.clientName!,
      body:
          "${newOrder.clientName!}   ${AppLocalizations.of(context)!.translate('accept your offer')} ",
    );

    // SendNotification(
    //   to: order.driverFcmToken!,
    //   title: "${order.clientName}  ",
    //   body: "${order.clientName} accept your offer ",
    // );

    // DioHelper.PostData(
    //   url: 'send',
    //   data: {
    //     "to": order.driverFcmToken,
    //     "priority": "high",
    //     "notification": {
    //       "body": "${order.clientName} accept your offer ",
    //       "title": "${order.clientName}  ",
    //       "subtitle": ""
    //     }
    //   },
    // );
  }

  sendNotification({
    required String to,
    required String title,
    required String body,
  }) {
    DioHelper.postData(
      url: 'send',
      data: {
        "to": to,
        "priority": "high",
        "notification": {"body": body, "title": title, "subtitle": ""}
      },
    );
    emit(SendNotificationSuccessfullyState());
  }

  List<OrderDataModel> acceptedOrders = [];

  getAcceptedOrders() {
    if (CasheHelper.getData(key: 'isDriver')) {
      acceptedOrders = [];
      emit(GetAcceptedOrdersLoadingState());
      FirebaseFirestore.instance
          .collection('drivers')
          .doc(CasheHelper.getData(key: 'uId'))
          .collection('acceptedOrders')
      .orderBy('dateToOrder')
          .snapshots()
          .listen((event) {
        acceptedOrders = [];
        event.docs.forEach((element) {
          acceptedOrders.add(OrderDataModel.fromJson(element.data()));
        });
        emit(GetAcceptedOrdersSuccessfullyState());
      });
    }
  }

  int x = 2;

  addMarkeratDriverLocation({
    double? driverLat,
    double? driverLng,
    double? latFrom,
    double? lngFrom,
    double? latTo,
    double? lngTo,
  }) {
    orderLocationsMarkers.clear();
    addMarkeratClientLocations(
      lngFrom: lngFrom,
      latFrom: latFrom,
      latTo: latTo,
      lngTo: lngTo,
    );
    orderLocationsMarkers.add(Marker(
      markerId: MarkerId('$x'),
      position: LatLng(driverLat!, driverLng!),
      infoWindow: const InfoWindow(title: 'Your location'),
    ));
    emit(AddMarkerToDriverLocationState());
  }

  var orderLocationsMarkers = HashSet<Marker>();

  addMarkeratClientLocations({
    double? latFrom,
    double? lngFrom,
    double? latTo,
    double? lngTo,
  }) {
    orderLocationsMarkers.add(
      Marker(
        markerId: const MarkerId('0'),
        position: LatLng(latFrom!, lngFrom!),
        infoWindow: const InfoWindow(title: 'From'),
      ),
    );
    orderLocationsMarkers.add(
      Marker(
        markerId: const MarkerId('1'),
        position: LatLng(latTo!, lngTo!),
        infoWindow: const InfoWindow(title: 'To'),
      ),
    );
  }

  Set<Polygon> myPolygon({
    double? latFrom,
    double? lngFrom,
    double? latTo,
    double? lngTo,
    double? driverLat,
    double? driverLng,
  }) {
    var polygonCoords = <LatLng>[];

    polygonCoords.add(LatLng(latTo!, lngTo!));
    polygonCoords.add(LatLng(latFrom!, lngFrom!));
    polygonCoords.add(LatLng(driverLat!, driverLng!));

    var polygonSet = Set<Polygon>();
    polygonSet.add(Polygon(
        polygonId: const PolygonId('test'),
        points: polygonCoords,
        strokeColor: Colors.red.withOpacity(.2),
        visible: true,
        fillColor: Colors.black.withOpacity(.1)));

    return polygonSet;
  }

  getLocationOfDriverInPloygon(Position? position) {
    dLat = position!.latitude;
    dLng = position.longitude;
    emit(PolygonState());
  }

  rateDriver({
    required String driverId,
    required String clientId,
    required double rate,
    required String clientName,
    required String clientImage,
  }) {
    emit(RateDriverLoadingState());
    RateDataModel clientRate = RateDataModel(
      rate: rate,
      clientName: clientName,
      clientImage: clientImage,
    );
    FirebaseFirestore.instance
        .collection('drivers')
        .doc(driverId)
        .collection('rates')
        .add(clientRate.toMap())
        .then((value) {
      emit(RateDriverSuccessfullyState());
    }).catchError((error) {
      emit(RateDriverErrorState());
    });
  }

  List<RateDataModel> driverRates = [];

  getDriverRates({
    required String driverId,
  }) {
    emit(GetDriverRatesLoadingState());
    FirebaseFirestore.instance
        .collection('drivers')
        .doc(driverId)
        .collection('rates')
        .snapshots()
        .listen((event) {
      driverRates = [];
      event.docs.forEach((element) {
        driverRates.add(RateDataModel.fromJson(element.data()));
      });
      emit(GetDriverRatesSuccessfullyState());
    });
  }

  rejectOffer(
      {required String orderId,
      required String offerId,
      required String to,
      required String clientName,
      required BuildContext context}) {
    emit(RejectOfferLoadingState());
    FirebaseFirestore.instance
        .collection('orders')
        .doc(orderId)
        .collection('offers')
        .doc(offerId)
        .delete()
        .then((value) {

      emit(RejectOfferSuccessfullyState());
    });
    sendNotification(
      to: to,
      title: clientName,
      body:
      " ${AppLocalizations.of(context)!.translate('reject your offer')} ",
    );
  }

  deleteOrderFromDriver({
    required String driverId,
    required String acceptedOrderId,
    required String to,
    required String driverName,
    required String orderId,
    required String clientId,
    required BuildContext context,
  }) {
    emit(DeleteOrderFromDriverLoadingState());
    FirebaseFirestore.instance
        .collection('drivers')
        .doc(driverId)
        .collection('acceptedOrders')
        .doc(acceptedOrderId)
        .delete()
        .then((value) {

      emit(DeleteOrderFromDriverSuccessfullyState());
    });
    sendNotification(
      to: to,
      title: driverName,
      body: 'delete the agreement please order it again',
    );
    FirebaseFirestore.instance
        .collection('clients')
        .doc(clientId)
        .collection('orders')
        .doc(orderId)
        .delete();
  }

  deleteOrderFromClient({
    required String driverId,
    required String acceptedOrderId,
    required String to,
    required String clientName,
    required String orderId,
    required String clientId,
    required BuildContext context,
  }) {
    emit(DeleteOrderFromClientLoadingState());
    FirebaseFirestore.instance
        .collection('drivers')
        .doc(driverId)
        .collection('acceptedOrders')
        .doc(acceptedOrderId)
        .delete()
        .then((value) {
      sendNotification(
        to: to,
        title: clientName,
        body: 'delete the agreement',
      );
      emit(DeleteOrderFromClientSuccessfullyState());
    });
    FirebaseFirestore.instance
        .collection('clients')
        .doc(clientId)
        .collection('orders')
        .doc(orderId)
        .delete();
  }

  sendMessege({
    required String recieverId,
    required String senderId,
    required String text,
    // required String FcmTo,
    // required String title,
    // required String body,
  }) {
    emit(SendMessegeLoadingState());
    // SendNotification(
    //   to: FcmTo,
    //   title: title,
    //   body: body,
    // );
    MessegeDataModel messege = MessegeDataModel(
      time: DateFormat.jm().format(DateTime.now()),
      dateTime: DateTime.now(),
      senderId: senderId,
      text: text,
      recieverId: recieverId,
      date: DateFormat('yMd').format(DateTime.now()),
    );

    if (!CasheHelper.getData(key: 'isDriver')) {
      FirebaseFirestore.instance
          .collection('clients')
          .doc(senderId)
          .collection('messeges')
          .doc(recieverId)
          .collection('messeges')
          .add(messege.toMap());

      FirebaseFirestore.instance
          .collection('drivers')
          .doc(recieverId)
          .collection('messeges')
          .doc(senderId)
          .collection('messeges')
          .add(messege.toMap())
          .then((value) {

        emit(SendMessegeSuccessfullyState());
      });
    } else {
      FirebaseFirestore.instance
          .collection('clients')
          .doc(recieverId)
          .collection('messeges')
          .doc(senderId)
          .collection('messeges')
          .add(messege.toMap());

      FirebaseFirestore.instance
          .collection('drivers')
          .doc(senderId)
          .collection('messeges')
          .doc(recieverId)
          .collection('messeges')
          .add(messege.toMap())
          .then((value) {
        emit(SendMessegeSuccessfullyState());
      });
    }

  }

  List<MessegeDataModel> allMesseges = [];

  getAllMesseges({
    String? clientId,
    String? driverId,
    // required String driverSend ,
  }) {
      allMesseges = [];
      emit(GetAllMessegesLoadingState());
      if (CasheHelper.getData(key: 'isDriver')) {
        FirebaseFirestore.instance
            .collection('drivers')
            .doc(CasheHelper.getData(key: 'uId'))
            .collection('messeges')
            .doc(clientId)
            .collection('messeges')
            .orderBy('dateTime')
            .snapshots()
            .listen((event) {
          if(CasheHelper.getData(key: 'uId') == driverId){
            allMesseges = [];
            event.docs.forEach((element) {
              allMesseges.add(MessegeDataModel.fromJson(element.data()));
            });
            emit(GetAllMessegesSuccessfullyStates());
          }
        });
      }
      else {
        FirebaseFirestore.instance
            .collection('clients')
            .doc(CasheHelper.getData(key: 'uId'))
            .collection('messeges')
            .doc(driverId)
            .collection('messeges')
            .orderBy('dateTime')
            .snapshots()
            .listen((event) {
          allMesseges = [];
          // GetAllMesseges(
          //   clientId: clientId,
          //   driverId: driverId,
          // );
          event.docs.forEach((element) {
            allMesseges.add(MessegeDataModel.fromJson(element.data()));
          });
          emit(GetAllMessegesSuccessfullyStates());
        });
      }


  }

//   List<OrderDataModel> acceptedOffers = [];
//
//   AcceptOffer({
//     required String driverId,
//     required String date,
//     required String time,
//     required String from,
//     required String to,
//     required String clientName,
//     required String clientImage,
//     required double latFrom,
//     required double latTo,
//     required double lngFrom,
//     required double lngTo,
//     required String fcmToken,
//     required String orderId,
//
//
//
//   }) {
//     emit(AcceptedOfferLoadingState());
//     OrderDataModel acceptedOffer = OrderDataModel(
//       date: date,
//       time: time,
//       from: from,
//       to: to,
//       clientName: clientName,
//       clientImage: clientImage,
//       latFrom: latFrom,
//       latTo: latTo,
//       lngFrom: lngFrom,
//       lngTo: lngTo,
//       fcmToken: fcmToken,
//       orderId: orderId,
//     );
//     FirebaseFirestore.instance.collection('drivers').doc(driverId)
//       ..collection('acceptedOffers').add(acceptedOffer.toMap())
//     .then((value) {
//       FirebaseFirestore.instance.collection('orders')
//       .doc(orderId)
//       .delete().then((value) {
//         emit(AcceptedOfferSuccessfullyState());
//       });
//       })
//     .catchError((error){
//       emit(AcceptedOfferErrorState());
//       });
//   }
//
//   GetAcceptedOffers({
//     required String driverId,
// }){
//     FirebaseFirestore.instance
//         .collection('drivers')
//         .doc(driverId)
//         .collection('acceptedOffers')
//         .snapshots()
//         .listen((event) {
//           acceptedOffers =[];
//           event.docs.forEach((element) {
//             acceptedOffers.add(OrderDataModel.fromJson(element.data()));
//           });
//     });
//   }

}
