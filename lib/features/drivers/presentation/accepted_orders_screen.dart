import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uber_final/core/app_localization.dart';

import '../../../core/components/components.dart';
import '../../../uber_cubit/uber_cubit.dart';
import '../../../uber_cubit/uber_states.dart';

class AcceptedOrdersScreen extends StatelessWidget {
  const AcceptedOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UberCubit, UberStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = UberCubit.get(context);
        var locale = AppLocalizations.of(context);
        return cubit.acceptedOrders.isNotEmpty
            ? ListView.separated(
          physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) => BuildDriverAcceptedOrderItem(
                  order: cubit.acceptedOrders[index],
                ),
                separatorBuilder: (context, index) => const SizedBox(
                  height: 0,
                ),
                itemCount: cubit.acceptedOrders.length,
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/Accept request-rafiki.png',
                      width: MediaQuery.of(context).size.width,
                    ),
                    Text(
                      locale!.translate('There is no accepted orders yet'),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
      },
    );
  }
}
