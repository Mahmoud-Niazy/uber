import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../uber_cubit/uber_cubit.dart';
import '../../uber_cubit/uber_states.dart';

class GoogleMapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UberCubit,UberStates>(
      listener: (context,state){},
      builder: (context,state){
        var cubit = UberCubit.get(context);
        return Scaffold(
          appBar: AppBar(),
          body: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(
                cubit.latitude,
                cubit.longitude,
              ),
              zoom: 30,
            ),

          ),
        );
      },
    );
  }
}
