import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uber_final/cashe_helper/cashe_helper.dart';
import 'package:uber_final/layout/layout_for_drivers.dart';
import 'package:uber_final/login_cubit/login_cubit.dart';
import 'package:uber_final/screens/register_screen.dart';
import 'package:uber_final/uber_cubit/uber_cubit.dart';
import '../app_localization.dart';
import '../components/components.dart';
import '../layout/layout_for_client.dart';
import '../login_cubit/login_states.dart';

class LoginScreen extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {
          if (state is UserLoginSuccessfullyState) {
            CasheHelper.saveData(
                key: 'isDriver', value: LoginCubit.get(context).isDriver)
                .then((value) {
              UberCubit.get(context).getUserData(
                userId: state.userId,
              );
              if(CasheHelper.getData(key: 'isDriver') ){
                FirebaseMessaging.instance.subscribeToTopic('drivers');
                UberCubit.get(context).getAcceptedOrders();
                navigateAndFinish(
                    screen: const LayoutForDrivers(), context: context);
              }
              if(!CasheHelper.getData(key: 'isDriver') ){
                FirebaseMessaging.instance.subscribeToTopic('clients');
                UberCubit.get(context).getClientOrders();
                navigateAndFinish(
                    screen: const LayoutForClient(), context: context);
              }

            });
          }
          if (state is UserLoginErrorState) {
            Fluttertoast.showToast(
              msg: 'Check your email and password please',
              backgroundColor: Colors.red,
            );
          }
        },
        builder: (context, state) {
          var cubit = LoginCubit.get(context);
          var locale = AppLocalizations.of(context)!;
          return SafeArea(
            child: Scaffold(
              body: Center(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Image.asset(
                              'assets/images/Carpool-rafiki.png',
                              height: MediaQuery.of(context).size.height * .35,
                              width: double.infinity,
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * .04,
                          ),
                          BuildTextFormField(
                            label: locale.translate('Email'),
                            controller: emailController,
                            pIcon: Icons.email_outlined,
                            validation: (value) {
                              if (value!.isEmpty) {
                                return locale.translate('Email can\'t be empty');
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          BuildTextFormField(
                            label: locale.translate('Password'),
                            controller: passwordController,
                            pIcon: Icons.lock_outline,
                            sIcon: cubit.isPassword
                                ? Icons.remove_red_eye_outlined
                                : Icons.visibility_off_outlined,
                            isPassword: cubit.isPassword,
                            onPressedOnSIcon: () {
                              cubit.changePasswordVisibility();
                            },
                            validation: (value) {
                              if (value!.isEmpty) {
                                return locale.translate('Password can\'t be empty');
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * .05,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                            ),
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    if(!cubit.isDriver) {
                                      cubit.changeTypeOfUser();
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 20,
                                    ),
                                    decoration: BoxDecoration(
                                        color: cubit.isDriver
                                            ? Colors.blue
                                            : Colors.grey,
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                          color: Colors.black,
                                        )),
                                    child: Text(
                                      locale.translate('Driver'),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                InkWell(
                                  onTap: () {
                                    if(cubit.isDriver) {
                                      cubit.changeTypeOfUser();
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 20,
                                    ),
                                    decoration: BoxDecoration(
                                        color: cubit.isDriver
                                            ? Colors.grey
                                            : Colors.blue,
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                          color: Colors.black,
                                        )),
                                    child: Text(
                                      locale.translate('Client'),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * .04,
                          ),
                          state is UserLoginLoadingState
                              ? const Center(child: CircularProgressIndicator())
                              : BuildButton(
                                  onPressed: () {
                                    if (formKey.currentState!.validate()) {
                                      cubit.userLogin(
                                        email: emailController.text,
                                        password: passwordController.text,
                                      );
                                    }
                                  },
                                  label: locale.translate('Login'),
                                ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * .02,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(locale.translate('Don\'t have an account ?')),
                              const SizedBox(
                                width: 5,
                              ),
                              BuildTextButton(
                                label: locale.translate('Register now'),
                                onPressed: () {
                                  navigate(
                                    screen: RegisterScreen(),
                                    context: context,
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
