import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uber_final/app_localization.dart';
import 'package:uber_final/screens/login_screen.dart';
import 'package:uber_final/uber_cubit/uber_cubit.dart';
import '../../cashe_helper/cashe_helper.dart';
import '../../components/components.dart';
import '../../uber_cubit/uber_states.dart';

class ClientSettingScreen extends StatelessWidget {
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
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 30,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                          SizedBox(
                            height: 50,
                          ),
                          BuildButton(
                            label: locale.Translate('Sign out'),
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
                ),
              ),
        )
            : Center(child: CircularProgressIndicator());
      },
    );
  }
}
