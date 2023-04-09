import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uber_final/components/components.dart';

import '../../uber_cubit/uber_cubit.dart';
import '../../uber_cubit/uber_states.dart';

class DriverOrderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UberCubit,UberStates>(
      listener: (context,state){},
      builder: (context,state){
        var cubit = UberCubit.get(context);
        return ListView.separated(
          physics: BouncingScrollPhysics(),
          itemBuilder:(context,index)=> BuildDriverOrderItem(
          order: cubit.allOrders[index],
          ),
          separatorBuilder: (context,index)=> SizedBox(
            height: 0,
          ),
          itemCount: cubit.allOrders.length,
        );
      },
    );
  }
}
