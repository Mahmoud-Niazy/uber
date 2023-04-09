import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uber_final/uber_cubit/uber_cubit.dart';
import '../../uber_cubit/uber_states.dart';

class ClientSettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UberCubit, UberStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = UberCubit.get(context);
        return cubit.client != null ||
                cubit.driver != null
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(cubit.client!.image),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        cubit.client!.name,
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              fontSize: 25,
                            ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        cubit.client!.phone,
                        style: Theme.of(context).textTheme.caption!.copyWith(
                              fontSize: 15,
                            ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        cubit.client!.email,
                        style: Theme.of(context).textTheme.caption!.copyWith(
                              fontSize: 15,
                            ),
                      ),
                    ],
                  ),
                ),
              )
            : Center(child: CircularProgressIndicator());
      },
    );
  }
}
