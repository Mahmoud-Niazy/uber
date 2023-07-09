import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../data_models/order_data_model.dart';
import '../../uber_cubit/uber_cubit.dart';
import '../../uber_cubit/uber_states.dart';

class LocationOfOrderScreen extends StatelessWidget {
  final OrderDataModel? order ;
  const LocationOfOrderScreen({super.key,
    required this.order,
});
  @override
  Widget build(BuildContext context) {
    return Builder(
        builder: (context){
          UberCubit.get(context).addMarkeratClientLocations(
            lngTo: order!.lngTo,
            latTo: order!.latTo,
            latFrom: order!.latFrom,
            lngFrom: order!.lngFrom,
          );
          StreamSubscription<Position>? ps;
          ps = Geolocator.getPositionStream().listen((Position? position) {
            UberCubit.get(context).addMarkeratDriverLocation(
              lngTo: order!.lngTo,
              latTo: order!.latTo,
              latFrom: order!.latFrom,
              lngFrom: order!.lngFrom,
              driverLat: position!.latitude,
              driverLng: position.longitude,
            );
            UberCubit.get(context).getLocationOfDriverInPloygon(position);
          });

      return BlocConsumer<UberCubit,UberStates>(
        listener: (context,state){},
        builder: (context,state){
          var cubit = UberCubit.get(context);
          return Scaffold(
            appBar: AppBar(),
            body: GoogleMap(
              polygons: cubit.myPolygon(
                lngFrom: order!.lngFrom,
                latFrom: order!.latFrom,
                latTo: order!.latTo,
                lngTo: order!.lngTo,
                driverLng: cubit.dLng,
                driverLat: cubit.dLat,
              ),
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  cubit.latitude,
                  cubit.longitude,
                ),
                zoom: 12,
              ),
              markers: cubit.orderLocationsMarkers,
            ),
          );
        },
      );
    });
  }
}
