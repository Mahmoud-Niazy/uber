import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_final/core/app_localization.dart';
import '../../../core/components/components.dart';
import '../../../core/functions/functions.dart';
import '../../../uber_cubit/uber_cubit.dart';
import '../../../uber_cubit/uber_states.dart';

class GoogleMapScreen extends StatelessWidget {
  const GoogleMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UberCubit, UberStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = UberCubit.get(context);
        var locale = AppLocalizations.of(context)!;
        return Scaffold(
          appBar: AppBar(
            actions: [
              BuildTextButton(
                label: locale.translate('Confirm'),
                onPressed: cubit.i != 0 ?
                    () {
                  cubit.confirmFrom();
                  navigatePop(context: context);
                    }
                    :
                null,
              ),
            ],
          ),
          body: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(
                cubit.latitude,
                cubit.longitude,
              ),
              zoom: 30,
            ),
            onTap: (LatLng position) {
              cubit.addMark(position);
              if(cubit.isFrom){
                cubit.positionFrom = position;
              }
              if(!cubit.isFrom){
                cubit.positionTo = position;
              }
            },
            markers: cubit.marker,
          ),
        );
      },
    );
  }
}
