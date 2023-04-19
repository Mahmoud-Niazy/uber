import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cashe_helper/cashe_helper.dart';
import '../../components/components.dart';
import '../../uber_cubit/uber_cubit.dart';
import '../../uber_cubit/uber_states.dart';
import '../login_screen.dart';

class DriverSettingScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UberCubit, UberStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = UberCubit.get(context);
        return cubit.client != null ||
            cubit.driver != null
            ? Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(cubit.driver!.image),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    cubit.driver!.name,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      fontSize: 25,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    cubit.driver!.phone,
                    style: Theme.of(context).textTheme.caption!.copyWith(
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    cubit.driver!.email,
                    style: Theme.of(context).textTheme.caption!.copyWith(
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  BuildButton(
                    label: 'Sign out',
                    onPressed: (){
                      CasheHelper.RemoveData(key: 'uId').then((value) {
                        cubit.driver=null;
                        cubit.client=null;
                        navigateAndFinish(screen: LoginScreen(), context: context);
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        )
            : Center(child: CircularProgressIndicator());
      },
    );
  }
}