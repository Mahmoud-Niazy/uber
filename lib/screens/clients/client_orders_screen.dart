import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uber_final/components/components.dart';

import '../../app_localization.dart';
import '../../uber_cubit/uber_cubit.dart';
import '../../uber_cubit/uber_states.dart';

class ClientOrdersScreen extends StatelessWidget {
  const ClientOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UberCubit, UberStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = UberCubit.get(context);
        var locale = AppLocalizations.of(context)!;
        return Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 25,
            horizontal: 15,
          ),
          child: cubit.orders.isNotEmpty
              ? ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) => BuildClientOrderItem(
                    order: cubit.orders[index],
                  ),
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 20,
                  ),
                  itemCount: cubit.orders.length,
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/Order ride-bro.png',
                        width: MediaQuery.of(context).size.width,
                      ),
                      Text(
                       locale.translate('There is no orders yet') ,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
