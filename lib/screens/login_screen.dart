import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uber_final/cashe_helper/cashe_helper.dart';
import 'package:uber_final/login_cubit/login_cubit.dart';
import 'package:uber_final/screens/register_screen.dart';
import 'package:uber_final/uber_cubit/uber_cubit.dart';
import '../components/components.dart';
import '../layout_for_client/layout_for_client.dart';
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
          if(state is UserLoginSuccessfullyState){
            CasheHelper.SaveData(key: 'isDriver', value: LoginCubit.get(context).isDriver).then((value){
              UberCubit.get(context).GetUserData(
                userId: state.userId,
              );
              navigateAndFinish(screen: LayoutForClient(), context: context);
            });
          }
          print(state);
        },
        builder: (context, state) {
          var cubit = LoginCubit.get(context);
          return SafeArea(
            child: Scaffold(
              body: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Image.asset(
                              'assets/images/33088-1-taxi-driver-file.png',
                              height: 200,
                              width: double.infinity,
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * .1,
                          ),
                          BuildTextFormField(
                            label: 'Email',
                            controller: emailController,
                            pIcon: Icons.email_outlined,
                            validation: (value) {
                              if (value!.isEmpty) {
                                return 'Email can\'t be empty';
                              }
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          BuildTextFormField(
                            label: 'Password',
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
                                return 'Email can\'t be empty';
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
                                    cubit.changeTypeOfUser();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 20,
                                    ),
                                    child: Text(
                                      'Driver',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                        color: cubit.isDriver
                                            ? Colors.green
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
                                    cubit.changeTypeOfUser();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 20,
                                    ),
                                    child: Text(
                                      'Client',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                        color: cubit.isDriver
                                            ? Colors.grey
                                            : Colors.green,
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
                          state is UserLoginLoadingState ?
                          Center(child: CircularProgressIndicator())
                          :
                          BuildButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                cubit.userLogin(
                                  email: emailController.text,
                                  password: passwordController.text,
                                );
                              }
                            },
                            label: 'Login',
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * .02,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Don\'t have an account ? '),
                              SizedBox(
                                width: 5,
                              ),
                              BuildTextButton(
                                label: 'Register now',
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
