import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uber_final/core/app_localization.dart';
import 'package:uber_final/register_cubit/register_cubit.dart';
import 'package:uber_final/features/register/check_code_screen.dart';
import '../../core/components/components.dart';
import '../../core/functions/functions.dart';
import '../../register_cubit/register_states.dart';
import '../../core/variables.dart';

class RegisterScreen extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterStates>(
      listener: (context, state) {
        if (state is PhoneCorrectState) {
          name = nameController.text;
          email = emailController.text;
          phone = phoneController.text;
          password = passwordController.text;
          navigateAndFinish(screen: CheckCodeScreen(), context: context);
        }
        if(state is CreateUserSuccessfullyState){
          RegisterCubit.get(context).profileImage = null ;
        }
      },
      builder: (context, state) {
        var cubit = RegisterCubit.get(context);
        var locale = AppLocalizations.of(context)!;
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                locale.translate('Register'),
              ),
            ),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Form(
                  key: formKey,
                  child: Column(
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
                        label: locale.translate('Name'),
                        controller: nameController,
                        pIcon: Icons.person,
                        validation: (value) {
                          if (value!.isEmpty) {
                            return locale.translate('Name can\'t be empty');
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 15,
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
                        validation: (value) {
                          if (value!.isEmpty) {
                            return locale.translate('Password can\'t be empty');
                          }
                          return null;
                        },
                        isPassword: cubit.isPassword,
                        sIcon: cubit.isPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        onPressedOnSIcon: () {
                          cubit.changePasswordVisibility();
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      BuildTextFormField(
                        label: locale.translate('Phone'),
                        controller: phoneController,
                        pIcon: Icons.phone,
                        validation: (value) {
                          if (value!.isEmpty) {
                            return locale.translate('Phone can\'t be empty');
                          }
                          return null;
                        },
                        type: TextInputType.phone,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.photo,
                            color: Colors.blue,
                          ),
                          BuildTextButton(
                            label: locale.translate('Pick your photo'),
                            onPressed: () {
                              cubit.getProfileImage();
                            },
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      if (cubit.profileImage != null)
                        Container(
                          height: 100,
                          width: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: FileImage(cubit.profileImage!),
                            ),
                          ),
                        ),
                      const SizedBox(
                        height: 10,
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
                      state is PhoneAuthLoadingState
                          ? const Center(child: CircularProgressIndicator())
                          : BuildButton(
                              onPressed: () {
                                if (formKey.currentState!.validate() &&
                                    cubit.profileImage != null) {
                                  cubit.phoneAuth(
                                    phoneNumber: phoneController.text,
                                  );
                                }
                              },
                              label: locale.translate('Register now'),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
