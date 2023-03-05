import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uber_final/data_models/client_data_model.dart';
import 'package:uber_final/data_models/driver_data_model.dart';
import 'package:uber_final/screens/clients/client_orders_screen.dart';
import 'package:uber_final/screens/clients/client_setting_screen.dart';
import 'package:uber_final/screens/clients/make_order_screen.dart';
import 'package:uber_final/uber_cubit/uber_states.dart';
import '../cashe_helper/cashe_helper.dart';

class UberCubit extends Cubit<UberStates> {
  UberCubit() : super(UberInitialState());

  static UberCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0 ;
  BottomNavigation(int index){
    currentIndex = index ;
    emit(BottomNavigationState());
  }

  List<Widget> screens = [
    ClientOrdersScreen(),
    MakeOrderScreen(),
    ClientSettingScreen(),
  ];

  DriverDataModel? driver ;
  ClientDataModel? client ;
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
      })
          .catchError((error) {
            emit(GetDriverDataErrorState());
      });
    }

    else{
      FirebaseFirestore.instance
          .collection('clients')
          .doc(userId)
          .get()
          .then((value) {
        client = ClientDataModel.fromJson(value.data()!);
        emit(GetClientDataSuccessfullyState());
      })
          .catchError((error) {
            emit(GetClientDataErrorState());
            print(error);
      });
    }
    }

    double latitude = 0 ;
    double longitude = 0 ;
    var clientLocation ;
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
     clientLocation =  await  Geolocator.getCurrentPosition();
    latitude = clientLocation.latitude;
    longitude = clientLocation.longitude ;
    print(latitude);
    return clientLocation;
  }
  }

