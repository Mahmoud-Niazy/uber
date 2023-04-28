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
  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {
          if (state is UserLoginSuccessfullyState) {
            CasheHelper.SaveData(
                key: 'isDriver', value: LoginCubit.get(context).isDriver)
                .then((value) {
              UberCubit.get(context).GetUserData(
                userId: state.userId,
              );
              if(CasheHelper.GetData(key: 'isDriver') ){
                FirebaseMessaging.instance.subscribeToTopic('drivers');
                UberCubit.get(context).GetAcceptedOrders();
                navigateAndFinish(
                    screen: LayoutForDrivers(), context: context);
              }
              if(!CasheHelper.GetData(key: 'isDriver') ){
                FirebaseMessaging.instance.subscribeToTopic('clients');
                UberCubit.get(context).GetClientOrders();
                navigateAndFinish(
                    screen: LayoutForClient(), context: context);
              }

            });
          }
          if (state is UserLoginErrorState) {
            Fluttertoast.showToast(
              msg: 'Check your email and password please',
              backgroundColor: Colors.red,
            );
          }
          print(state);
        },
        builder: (context, state) {
          var cubit = LoginCubit.get(context);
          var locale = AppLocalizations.of(context)!;
          return SafeArea(
            child: Scaffold(
              body: Center(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
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
                            label: locale.Translate('Email'),
                            controller: emailController,
                            pIcon: Icons.email_outlined,
                            validation: (value) {
                              if (value!.isEmpty) {
                                return locale.Translate('Email can\'t be empty');
                              }
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          BuildTextFormField(
                            label: locale.Translate('Password'),
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
                                return locale.Translate('Password can\'t be empty');
                              }
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
                                    if(!cubit.isDriver)
                                    cubit.changeTypeOfUser();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 20,
                                    ),
                                    child: Text(
                                      locale.Translate('Driver'),
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                        color: cubit.isDriver
                                            ? Colors.blue
                                            : Colors.grey,
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                          color: Colors.black,
                                        )),
                                  ),
                                ),
                                Spacer(),
                                InkWell(
                                  onTap: () {
                                    if(cubit.isDriver)
                                      cubit.changeTypeOfUser();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 20,
                                    ),
                                    child: Text(
                                      locale.Translate('Client'),
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                        color: cubit.isDriver
                                            ? Colors.grey
                                            : Colors.blue,
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                          color: Colors.black,
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * .04,
                          ),
                          state is UserLoginLoadingState
                              ? Center(child: CircularProgressIndicator())
                              : BuildButton(
                                  onPressed: () {
                                    if (formKey.currentState!.validate()) {
                                      cubit.userLogin(
                                        email: emailController.text,
                                        password: passwordController.text,
                                      );
                                    }
                                  },
                                  label: locale.Translate('Login'),
                                ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * .02,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(locale.Translate('Don\'t have an account ?')),
                              SizedBox(
                                width: 5,
                              ),
                              BuildTextButton(
                                label: locale.Translate('Register now'),
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
