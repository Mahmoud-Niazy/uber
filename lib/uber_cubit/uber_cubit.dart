import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_final/data_models/client_data_model.dart';
import 'package:uber_final/data_models/driver_data_model.dart';
import 'package:uber_final/data_models/order_data_model.dart';
import 'package:uber_final/screens/clients/client_orders_screen.dart';
import 'package:uber_final/screens/clients/client_setting_screen.dart';
import 'package:uber_final/screens/clients/make_order_screen.dart';
import 'package:uber_final/screens/drivers/driver_orders_screen.dart';
import 'package:uber_final/screens/drivers/driver_setting_screen.dart';
import 'package:uber_final/uber_cubit/uber_states.dart';
import '../cashe_helper/cashe_helper.dart';
import '../dio_helper/dio_helper.dart';

class UberCubit extends Cubit<UberStates> {
  UberCubit() : super(UberInitialState());

  static UberCubit get(context) => BlocProvider.of(context);

  int currentIndexInClientsLayout = 0;

  BottomNavigationInClientsLayout(int index) {
    currentIndexInClientsLayout = index;
    emit(BottomNavigationState());
  }

  List<Widget> screensInClientsLayout = [
    ClientOrdersScreen(),
    MakeOrderScreen(),
    ClientSettingScreen(),
  ];

  DriverDataModel? driver;
  ClientDataModel? client;

  GetUserData({
    String? userId,
  }) {
    emit(GetUserDataLoadingState());
    if (CasheHelper.GetData(key: 'isDriver')) {
      FirebaseFirestore.instance
          .collection('drivers')
          .doc(userId)
          .get()
          .then((value) {
        driver = DriverDataModel.fromJson(value.data()!);
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
        emit(GetClientDataSuccessfullyState());
      }).catchError((error) {
        emit(GetClientDataErrorState());
        print(error);
      });
    }
  }

  double latitude = 0;

  double longitude = 0;

  var clientLocation;

  Future<Position> GetClientLocation() async {
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
    print(latitude);
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

  AddMark(LatLng position) {
    marker.clear();
    marker.add(Marker(
      position: position,
      markerId: MarkerId('${i}'),
    ));
    i++;
    emit(AddMarkState());
  }

  MakeOrder({
    required String time,
    required String date,
    required String fromPlace,
    required String toPlace,
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
    );
    FirebaseFirestore.instance
        .collection('clients')
        .doc(CasheHelper.GetData(key: 'uId'))
      ..collection('orders').add(order.toMap()).then((value) {
        FirebaseFirestore.instance
            .collection('orders')
            .add(order.toMap())
            .then((value) {
          emit(MakeOrderSuccessfullyState());
          isFrom = true;
        });
      }).catchError((error) {
        emit(MakeOrderErrorState());
      });
  }

  List<OrderDataModel> orders = [];

  GetClientOrders() {
    emit(GetClientOrdersLoadingState());
    FirebaseFirestore.instance
        .collection('clients')
        .doc(CasheHelper.GetData(key: 'uId'))
        .collection('orders')
        .orderBy('date')
        .orderBy('time')
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

  BottomNavigationInDriversLayout(int index) {
    currentIndexInDriversLayout = index;
    emit(BottomNavigationState());
  }

  List<Widget> screensInDriversLayout = [
    DriverOrderScreen(),
    DriverSettingScreen(),
  ];

  SendNotificationToAlldrivers({
    required String clientName,
}) {
    emit(SendNotificationToAllDriversLoadingState());
    DioHelper.PostData(
      url: 'send',
      data: {
        "to": "/topics/drivers",
        "priority": "high",
        "notification": {
          "body": "$clientName make an order",
          "title": "New order for you",
          "subtitle": "Firebase Cloud Message Subtitle"
        }
      }
    ).then((value) {
      emit(SendNotificationToAllDriversSuccessfullyState());
    }).catchError((error) {
      emit(SendNotificationToAllDriversErrorState());
    });
  }

  List<OrderDataModel> allOrders = [];
  GetAllOrders(){
    if(CasheHelper.GetData(key: 'isDriver')){
      emit(GetAllOrdersLoadingState());
      FirebaseFirestore.instance.collection('orders')
          .orderBy('date').snapshots()
          .listen((event) {
        allOrders = [];
        event.docs.forEach((element) {
          allOrders.add(OrderDataModel.fromJson(element.data()));
        });
        emit(GelAllOrdersSuccessfullyState());
      });
    }
  }
}
