import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uber_final/components/components.dart';

import '../../uber_cubit/uber_cubit.dart';
import '../../uber_cubit/uber_states.dart';

class ClientOrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UberCubit,UberStates>(
      listener: (context,state){},
      builder: (context,state){
        var cubit = UberCubit.get(context);
        return  Padding(
          padding: const EdgeInsets.all(15.0),
          child: ListView.separated(
            physics: BouncingScrollPhysics(),
            itemBuilder: (context,index)=> BuildClientOrderItem(
              order:  cubit.orders[index],
            ),
            separatorBuilder: (context,index)=> SizedBox(
              height: 20,
            ),
            itemCount: cubit.orders.length,
          ),
        );
      },
    );
  }

}