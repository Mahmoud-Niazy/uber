import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uber_final/uber_cubit/uber_cubit.dart';
import '../../components/components.dart';
import '../../uber_cubit/uber_states.dart';

class AllDriverRates extends StatelessWidget {
  String driverId ;
  AllDriverRates(this.driverId);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Builder(
        builder: (context){
          UberCubit.get(context).GetDriverRates(driverId: driverId);
          return  BlocConsumer<UberCubit,UberStates>(
            listener: (context,state){},
            builder: (context,state){
              var cubit = UberCubit.get(context);
              return cubit.driverRates.length > 0 ?
              ListView.separated(
                physics: BouncingScrollPhysics(),
                itemBuilder: (context,index)=> BuildClientRateItem(
                  rate: cubit.driverRates[index] ,
                ),
                separatorBuilder: (context,index)=> SizedBox(
                  height: 0,
                ),
                itemCount: cubit.driverRates.length,
              )
              : Center(child: CircularProgressIndicator());
            },
          );
        },
      ),
    );
  }
}
