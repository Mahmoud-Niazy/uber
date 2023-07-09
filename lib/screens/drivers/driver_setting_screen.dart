import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uber_final/app_localization.dart';

import '../../cashe_helper/cashe_helper.dart';
import '../../components/components.dart';
import '../../uber_cubit/uber_cubit.dart';
import '../../uber_cubit/uber_states.dart';
import '../login_screen.dart';

class DriverSettingScreen extends StatelessWidget{
  const DriverSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UberCubit, UberStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = UberCubit.get(context);
        var locale = AppLocalizations.of(context)!;
        return cubit.client != null ||
            cubit.driver != null
            ? Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Card(
                  elevation: 20,
                  child: Container(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: const BoxDecoration(
                      color: Color(0xffe3f2fd),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 30,
                      horizontal: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white,
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: CachedNetworkImage(
                              imageUrl: cubit.driver!.image,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          cubit.driver!.name,
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontSize: 25,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          cubit.driver!.phone,
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          cubit.driver!.email,
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        BuildButton(
                          label: locale.translate('Sign out'),
                          onPressed: (){
                            CasheHelper.removeData(key: 'uId').then((value) {
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
              ),
            ),
          ),
        )
            : const Center(child: CircularProgressIndicator());
      },
    );
  }
}