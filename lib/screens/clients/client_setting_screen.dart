import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uber_final/app_localization.dart';
import 'package:uber_final/screens/login_screen.dart';
import 'package:uber_final/uber_cubit/uber_cubit.dart';
import '../../cashe_helper/cashe_helper.dart';
import '../../components/components.dart';
import '../../uber_cubit/uber_states.dart';

class ClientSettingScreen extends StatelessWidget {
  const ClientSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UberCubit, UberStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var locale = AppLocalizations.of(context)!;
        var cubit = UberCubit.get(context);
        return cubit.client != null ||
                cubit.driver != null
            ?
        Center(
          child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Card(
                    elevation: 15,
                    child: Container(
                      color: const Color(0xffe3f2fd),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 30,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 50,
                            child: Container(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: CachedNetworkImage(
                                imageUrl: cubit.client!.image,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            cubit.client!.name,
                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                  fontSize: 25,
                                ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            cubit.client!.phone,
                            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                  fontSize: 15,
                                ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            cubit.client!.email,
                            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                  fontSize: 15,
                                ),
                          ),
                          const SizedBox(
                            height: 50,
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
        )
            : const Center(child: CircularProgressIndicator());
      },
    );
  }
}
